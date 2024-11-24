import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_quill/translations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/common/global.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_locale.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/router.dart';
import 'package:simple_app/utils/Notification.dart';

CurrentTheme? nightMode;
CurrentLocale? locale;

late String? strLocale;
final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

void main(List<String> args) {
  WidgetsFlutterBinding.ensureInitialized();
  // 读取持久化数据
  _prefs.then((prefs) async {
    strLocale = prefs.getString(ConstantKey.localeKey);
    bool? isNightMode = prefs.getBool(ConstantKey.isNightMode);
    // 优先读取持久化数据
    if (strLocale != null) {
      locale = CurrentLocale(locale: strLocaleToLocale(strLocale!));
    } else {
      locale = CurrentLocale();
    }
    if (isNightMode != null) {
      nightMode = CurrentTheme(
          themeMode: isNightMode ? ThemeMode.dark : ThemeMode.light);
    } else {
      nightMode = CurrentTheme(themeMode: ThemeMode.light);
    }

    runApp(MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => locale),
        ChangeNotifierProvider(create: (_) => nightMode),
      ],
      child: const MyApp(),
    ));
    // 初始化本地通知插件
    // 是否为web环境
    if (!kIsWeb) {
      await flutterLocalNotificationsPluginInit();
    }
  });
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// 通过navigatorKey的方式 保存全局的context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 750),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        routes: routes,
        title: 'simple_app',
        // 国际化
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
          FlutterQuillLocalizations.delegate,
          S.delegate
        ],
        themeMode: context.watch<CurrentTheme>().value,
        theme: ThemeData(
          brightness: Brightness.light,
        ),
        darkTheme:
            ThemeData(brightness: Brightness.dark, primaryColor: darkColor),
        //应用支持的语言列表
        supportedLocales: const [
          Locale('en', 'US'), // English
          Locale('zh', 'CN'), // 中文
        ],
        // 保存全局navigatorkey
        navigatorKey: navigatorKey,
        // 当前语言
        locale: context.watch<CurrentLocale>().value,
        localeResolutionCallback: (deviceLocale, supportedLocales) {
          _prefs.then((prefs) {
            strLocale = prefs.getString(ConstantKey.localeKey);
            // 如果本地环境不为中文,而且没有设置过语言,则设置为英文
            if (locale == null &&
                localeToStrLocale(deviceLocale!) != 'zh' &&
                strLocale == null) {
              locale?.setLocale(const Locale('en', 'US'));
            }
          });
          return null;
        },
      ),
    );
  }
}
