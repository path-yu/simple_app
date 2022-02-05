import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/Global.dart';

const _defaultLocale = Locale('en', 'US');

class CurrentLocale with ChangeNotifier {
  // 当前语言环境
  Locale _locale = const Locale('zh', 'CN');

  Locale get value => _locale;
  // 语言是否为英语环境
  bool get languageIsEnglishMode => _locale.languageCode == 'en' ? true : false;

  String get localeType => localeToStrLocale(_locale);

  // 初始化加载当前语言
  void initLocale({Locale? nativeLocale = _defaultLocale}) async {
    if (nativeLocale != null) {
      _locale = nativeLocale;
      notifyListeners();
    }
  }

  // 将持久化存储的locale数据转为locale;
  Locale strLocaleToLocale(String strLocale) {
    Locale locale;
    if (strLocale == 'zh_CN') {
      locale = const Locale('zh', 'CN');
    } else {
      locale = const Locale('en', 'US');
    }
    return locale;
  }

  /// 将locale类 转化为 zh或cn字符串方便进行保存
  String localeToStrLocale(Locale locale) {
    String strLocale;
    if (locale.languageCode == 'zh') {
      strLocale = 'zh';
    } else {
      strLocale = 'en';
    }
    return strLocale;
  }

  //切换当前语言 并持久化保存
  void setLocale(Locale locale) async {
    _locale = locale;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ConstantKey.localeKey, localeToStrLocale(locale));
    notifyListeners();
  }
}
