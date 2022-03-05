import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/components/base/base_icon.dart';

Widget buildTodoListTitle(String title, int count,
    {void Function()? onTap,
    required bool isSpread,
    required Color backgroundColor}) {
  return Container(
      color: backgroundColor,
      padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
      child: InkWell(
        onTap: onTap,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      fontSize: ScreenUtil().setSp(20)),
                ),
                AnimatedRotation(
                  turns: isSpread ? 0.5 : 0,
                  curve: Curves.easeInExpo,
                  duration: const Duration(milliseconds: 250),
                  child: baseIcon(Icons.keyboard_arrow_up_sharp,color: Colors.white),
                )
              ],
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
        ),
      ),
    );
}
