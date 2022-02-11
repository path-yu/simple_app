import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 基础Appbar
AppBar buildBaseAppBar(String title,{ Widget? leading,List<Widget> ? action}) {
  return AppBar(
    toolbarHeight: ScreenUtil().setSp(55),
    leading: leading ,
    actions:action,
    title: Text(
      title,
      style: TextStyle(fontSize: ScreenUtil().setSp(18)),
    ),
    centerTitle: true,
  );
}
