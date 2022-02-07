import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 基础Appbar
AppBar buildBaseAppBar(String title) {
  return AppBar(
    toolbarHeight: ScreenUtil().setSp(55),
    title: Text(
      title,
      style: TextStyle(fontSize: ScreenUtil().setSp(18)),
    ),
    centerTitle: true,
  );
}
