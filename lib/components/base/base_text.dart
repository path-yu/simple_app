import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 16号字体
Text baseText(String data, {Color? color}) {
  return Text(
    data,
    style: TextStyle(fontSize: ScreenUtil().setSp(16), color: color),
  );
}
