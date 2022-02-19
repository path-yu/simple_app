import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
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
    await flutterLocalNotificationsPluginInit();
    if (Platform.isAndroid) {
      // 以下两行 设置android状态栏为透明的沉浸。写在组件渲染之后，是为了在渲染后进行set赋值，覆盖状态栏，写在渲染之前MaterialApp组件会覆盖掉这个值。
      SystemUiOverlayStyle systemUiOverlayStyle =
          const SystemUiOverlayStyle(statusBarColor: Colors.transparent);
      SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
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
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return NeumorphicApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: routes,
      title: 'simple_app',
      // 国际化
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        S.delegate
      ],
      themeMode: context.watch<CurrentTheme>().value,
      theme: const NeumorphicThemeData(
        baseColor: Color(0xfff7f7f7),
        lightSource: LightSource.bottom,
        depth: 8,
        // depth: 10,
      ),
      darkTheme: const NeumorphicThemeData(
        baseColor: darkColor,
        depth: 8,
        lightSource: LightSource.bottom,
      ),
      //应用支持的语言列表
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('zh', 'CN'), // 中文
      ],
      // 保存全局navigatorkey
      navigatorKey: navigatorKey,
      // 当前语言
      locale: context.watch<CurrentLocale>().value,
      // theme: ThemeData(
      //   primaryColor: themeColor,
      //   visualDensity: VisualDensity.adaptivePlatformDensity,
      //   brightness: context.watch<CurrentTheme>().isNightMode
      //       ? Brightness.dark
      //       : Brightness.light,
      // ),
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
    );
  }
}
