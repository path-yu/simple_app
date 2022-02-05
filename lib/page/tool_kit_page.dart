import 'dart:ui';

import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/page/note_page.dart';
import 'package:simple_app/page/todo_list_page.dart';

import '../utils/showToast.dart';

class ToolKitPage extends StatefulWidget {
  const ToolKitPage({Key? key}) : super(key: key);

  @override
  _ToolKitPageState createState() => _ToolKitPageState();
}

class _ToolKitPageState extends State<ToolKitPage> {
  final List<Map> toolList = [
    {"RouterPath": '', "label": '备忘录'},
    {"RouterPath": '', "label": '翻译'},
    {"RouterPath": '', "label": '大字版'},
    {"RouterPath": '', "label": '天气查询'},
    {"RouterPath": '', "label": '新华字典'},
    {"RouterPath": '/note_list_page', "label": '便签', "comp": const NotePage()},
    {"RouterPath": '', "label": '计算器'},
    {
      "RouterPath": '/todo_list_page',
      "label": 'todoList',
      "comp": const TodoListPage()
    },
  ];
  final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
    onPrimary: Colors.black87,
    primary: const Color.fromRGBO(248, 248, 248, 1.0),
    minimumSize: const Size(88, 36),
    padding: const EdgeInsets.symmetric(horizontal: 16),
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(20)),
    ),
  );
  void toRouterPage(Map map) {
    if (map['RouterPath'].isEmpty) {
      showToast('暂未开发');
    } else {
      Navigator.push(
          context, CupertinoPageRoute(builder: (context) => map['comp']));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: ScreenUtil().setSp(55),
          title: Text(
            '工具箱 ',
            style: TextStyle(fontSize: ScreenUtil().setSp(18)),
          ),
          centerTitle: true,
        ),
        body: Container(
            margin: EdgeInsets.only(top: ScreenUtil().setSp(20)),
            child: SizedBox(
              width: double.infinity,
              child: Wrap(
                spacing: ScreenUtil().setSp(10),
                runSpacing: ScreenUtil().setSp(10),
                alignment: WrapAlignment.spaceAround, //沿主轴方向居中
                runAlignment: WrapAlignment.spaceAround,
                children: toolList.map((e) {
                  Color buttonTextColor;
                  String routerPath = e['RouterPath'];
                  if (routerPath.isEmpty) {
                    buttonTextColor = Colors.grey;
                  } else {
                    buttonTextColor = Colors.black;
                  }
                  return SizedBox(
                    width: ScreenUtil().setWidth(150),
                    height: ScreenUtil().setHeight(30),
                    child: ElevatedButton(
                        // color: const Color.fromRGBO(248, 248, 248, 1.0),
                        // shape: RoundedRectangleBorder(
                        //     borderRadius: BorderRadius.circular(20.0)),
                        onPressed: () => toRouterPage(e),
                        style: raisedButtonStyle,
                        child: Center(
                          child: Text(
                            "${e['label']}",
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(14),
                                color: buttonTextColor),
                          ),
                        )),
                  );
                }).toList(),
              ),
            )));
  }
}
