import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_theme.dart';

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

// showCupertinoModalPopup 展示ios的风格弹出框，通常情况下和CupertinoActionSheet配合使用，
showBaseCupertinoModalPopup(BuildContext context, Function onConfirm) {
  showCupertinoModalPopup(
      context: context,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          title: Text(S.of(context).hint),
          message: Text(S.of(context).deleteMessage),
          actions: <Widget>[
            CupertinoActionSheetAction(
              child: Text(
                S.of(context).cancel,
                style: TextStyle(
                    fontSize: ScreenUtil().setSp(25),
                    color: context
                        .read<CurrentTheme>()
                        .mainThemeOrSecondThemeColor),
              ),
              onPressed: () => Navigator.pop(context),
              isDefaultAction: true,
            ),
            CupertinoActionSheetAction(
              child: Text(
                S.of(context).delete,
                style: TextStyle(fontSize: ScreenUtil().setSp(25)),
              ),
              onPressed: () {
                onConfirm();
                Navigator.pop(context);
              },
              isDestructiveAction: true,
            ),
          ],
        );
      });
}
