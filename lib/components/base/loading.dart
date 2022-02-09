import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class Loading extends StatelessWidget {
  const Loading({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: ScreenUtil().setWidth(45),
        height: ScreenUtil().setHeight(45),
        child: // 模糊进度条(会执行一个旋转动画)
            const CupertinoActivityIndicator(
          color: Colors.blue,
        ),
      ),
    );
  }
}
