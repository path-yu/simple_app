import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

// 16号字体
Text baseText(String data) {
  return Text(
    data,
    style: TextStyle(fontSize: ScreenUtil().setSp(16)),
  );
}
