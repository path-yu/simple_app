import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/components/base/base_icon.dart';

Widget buildTodoListTitle(String title, int count,
    {void Function()? onTap, required bool isSpread}) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      GestureDetector(
        onTap: onTap,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(20)),
            ),
            baseIcon(isSpread ? Icons.arrow_drop_down : Icons.arrow_drop_up),
          ],
        ),
      ),
      ClipOval(
          child: Container(
              width: ScreenUtil().setHeight(20),
              height: ScreenUtil().setHeight(20),
              color: const Color(0xffE6E6FA),
              child: Center(
                child: Text(
                  count.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: ScreenUtil().setSp(10),
                      color: const Color(0xFF666666)),
                ),
              ))),
    ],
  );
}
