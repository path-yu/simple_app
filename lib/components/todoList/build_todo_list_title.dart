import 'package:flutter/cupertino.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget buildTodoListTitle(String title, int count) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Text(
        title,
        style: TextStyle(
            fontWeight: FontWeight.bold, fontSize: ScreenUtil().setSp(20)),
      ),
      ClipOval(
          child: Container(
              width: ScreenUtil().setWidth(20),
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
