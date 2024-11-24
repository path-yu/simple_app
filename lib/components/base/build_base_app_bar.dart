import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import "package:provider/provider.dart";
import 'package:simple_app/main.dart';
import 'package:simple_app/provider/current_theme.dart';

// 基础Appbar
AppBar buildBaseAppBar(
    {String? title,
    Widget? leading,
    List<Widget>? action,
    Widget? titleWidget,
    Color? backgroundColor}) {
  return AppBar(
    toolbarHeight: ScreenUtil().setSp(55),
    leading: leading,
    actions: action,
    systemOverlayStyle: SystemUiOverlayStyle(
      // Status bar color
      statusBarColor: Colors.transparent,
    ),
    title: titleWidget ??
        Text(
          title!,
          style: TextStyle(fontSize: ScreenUtil().setSp(18)),
        ),
    centerTitle: true,
  );
}
