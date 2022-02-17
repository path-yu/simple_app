import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/components/base/animation_rotation.dart';
import 'package:simple_app/components/base/base_icon.dart';

Widget buildTodoListTitle(String title, int count,
    {void Function()? onTap, required bool isSpread}) {
  print("build");
  print(isSpread);
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
            AnimatedToggleRotation(
              child: baseIcon(Icons.arrow_drop_up),
              toggleValue: isSpread,
            )
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

// class TodoListTitle extends StatefulWidget {
//   String title;
//   int count;
//   bool isSpread;
//   void Function()? onTap;
//   TodoListTitle({
//     Key? key,
//     required this.title,
//     required this.count,
//     required this.isSpread,
//     void Function()? onTap,
//   }) : super(key: key);

//   @override
//   _TodoListTitleState createState() => _TodoListTitleState();
// }

// class _TodoListTitleState extends State<TodoListTitle> {
//   @override
//   Widget build(BuildContext context) {
//     print(object)
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         GestureDetector(
//           onTap: widget.onTap,
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               Text(
//                 widget.title,
//                 style: TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: ScreenUtil().setSp(20)),
//               ),
//               AnimatedToggleRotation(
//                 child: baseIcon(Icons.arrow_drop_up),
//                 toggleValue: widget.isSpread,
//               )
//             ],
//           ),
//         ),
//         ClipOval(
//             child: Container(
//                 width: ScreenUtil().setHeight(20),
//                 height: ScreenUtil().setHeight(20),
//                 color: const Color(0xffE6E6FA),
//                 child: Center(
//                   child: Text(
//                     widget.count.toString(),
//                     textAlign: TextAlign.center,
//                     style: TextStyle(
//                         fontSize: ScreenUtil().setSp(10),
//                         color: const Color(0xFF666666)),
//                   ),
//                 ))),
//       ],
//     );
//   }
// }
