import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/common/Color.dart';
import 'package:simple_app/common/Global.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_locale.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/router.dart';
import 'package:simple_app/utils/Notification.dart';

final locale = CurrentLocale();
final nightMode = CurrentTheme();

void main(List<String> args) async {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => locale),
      ChangeNotifierProvider(create: (_) => nightMode),
    ],
    child: const MyApp(),
  ));
  await flutterLocalNotificationsPluginInit();
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

// 通过navigatorKey的方式 保存全局的context
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class _MyAppState extends State<MyApp> {
  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  late String? strLocale;
  @override
  void initState() {
    super.initState();
    // 读取持久化数据
    _prefs.then((prefs) {
      strLocale = prefs.getString(ConstantKey.localeKey);
      bool? isNightMode = prefs.getBool(ConstantKey.isNightMode);
      if (strLocale != null) {
        locale.initLocale(nativeLocale: locale.strLocaleToLocale(strLocale!));
      }
      if (isNightMode != null) {
        nightMode.initNightMode(isNightMode: isNightMode);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
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
      //应用支持的语言列表
      supportedLocales: const [
        Locale('en', 'US'), // English
        Locale('zh', 'CN'), // 中文
      ],
      // 保存全局navigatorkey
      navigatorKey: navigatorKey,
      // 当前语言
      locale: context.watch<CurrentLocale>().value,
      // // 当系统请求“暗模式”时使用时, 使用暗模式
      // darkTheme: ThemeData.dark(),
      theme: ThemeData(
          primarySwatch: themeColor,
          brightness: context.watch<CurrentTheme>().isNightMode
              ? Brightness.dark
              : Brightness.light),
      localeResolutionCallback: (deviceLocale, supportedLocales) {
        _prefs.then((prefs) {
          strLocale = prefs.getString(ConstantKey.localeKey);
          // 如果本地环境不为中文,而且没有设置过语言,则设置为英文
          if (locale.localeToStrLocale(deviceLocale!) != 'zh' &&
              strLocale == null) {
            locale.setLocale(const Locale('en', 'US'));
          }
        });
        // 判断需要改变当前语言
      },
    );
  }
}
