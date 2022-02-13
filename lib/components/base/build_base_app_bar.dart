import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:provider/provider.dart";
import 'package:simple_app/main.dart';
import 'package:simple_app/provider/current_theme.dart';

// 基础Appbar
AppBar buildBaseAppBar(String title, {Widget? leading, List<Widget>? action}) {
  return AppBar(
    toolbarHeight: ScreenUtil().setSp(55),
    leading: leading,
    actions: action,
    // 144,201,173 23,61,44 const Color.fromRGBO(144, 201, 172, 1),
    backgroundColor:
        navigatorKey.currentState!.context.watch<CurrentTheme>().isNightMode
            ? const Color.fromRGBO(23, 61, 44, 1)
            : const Color.fromRGBO(144, 201, 172, 1),
    title: Text(
      title,
      style: TextStyle(fontSize: ScreenUtil().setSp(18)),
    ),
    centerTitle: true,
  );
}
