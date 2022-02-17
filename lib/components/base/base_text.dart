import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 16号字体
Text baseText(String data, {Color? color, num fontSize = 16}) {
  return Text(
    data,
    style: TextStyle(
        fontSize: ScreenUtil().setSp(fontSize), color: color, height: 1.5),
  );
}
