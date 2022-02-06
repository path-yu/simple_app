import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../common/Global.dart';

class CurrentTheme with ChangeNotifier {
  // 当前语言环境
  Brightness themeMode;

  Brightness get value => themeMode;
  CurrentTheme({this.themeMode = Brightness.light});
  // 是否为夜间模式
  bool get isNightMode => themeMode == Brightness.dark ? true : false;

  changeMode(Brightness mode) async {
    themeMode = mode;
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool(ConstantKey.isNightMode, isNightMode);
    notifyListeners();
  }

  // 初始化
  void initNightMode({bool? isNightMode}) async {
    if (isNightMode != null) {
      if (isNightMode) {
        themeMode = Brightness.dark;
        notifyListeners();
      }
    }
  }
}
