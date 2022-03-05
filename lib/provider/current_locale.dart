import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/common/global.dart';
import 'package:simple_app/utils/notification.dart';



const _defaultLocale = Locale('en', 'US');
void main(List<String> args) {}

class CurrentLocale with ChangeNotifier {
  // 当前语言环境
  Locale locale;
  CurrentLocale({this.locale = const Locale('zh', 'CN')});
  Locale get value => locale;
  // 语言是否为英语环境
  bool get languageIsEnglishMode => locale.languageCode == 'en' ? true : false;

  String get localeType => localeToStrLocale(locale);

  // 初始化加载当前语言
  void initLocale({Locale? nativeLocale = _defaultLocale}) async {
    if (nativeLocale != null) {
      locale = nativeLocale;
      // 开启通知
      notifyListeners();
      // 异步发起通知
      Future.delayed(const Duration(seconds: 2), () {
        showNotification(message: 'todo', payload: '/todo_list');
      });
    }
  }

  //切换当前语言 并持久化保存
  void setLocale(Locale value) async {
    locale = value;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(ConstantKey.localeKey, localeToStrLocale(locale));
    notifyListeners();
  }
}

// 将持久化存储的locale数据转为locale;
Locale strLocaleToLocale(String strLocale) {
  Locale locale;
  if (strLocale == 'zh') {
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
