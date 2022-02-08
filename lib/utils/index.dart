import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

SharedPreferences? prefsinstance;
// 获取数据持久化存储对象的数据
Future<dynamic> getLocalStorageData(key) async {
  // 初始化数据持久化存储对象
  prefsinstance ??= await _prefs.then((value) => value);
  String? value = prefsinstance?.getString(key);
  value ??= "[]";
  //将string 转为json
  return json.decode(value);
}

//筛选listdata数据 返回正在进行中的todolist 或者已经完成的todoList
List filterListData(List arr, bool done) {
  return arr.where((element) => element['done'] == done).toList();
}
