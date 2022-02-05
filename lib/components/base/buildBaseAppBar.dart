import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/common/Color.dart';

// 基础Appbar
AppBar buildBaseAppBar(String title) {
  return AppBar(
    toolbarHeight: ScreenUtil().setSp(55),
    backgroundColor: themeColor,
    title: Text(
      title,
      style: TextStyle(fontSize: ScreenUtil().setSp(18)),
    ),
    centerTitle: true,
  );
}
