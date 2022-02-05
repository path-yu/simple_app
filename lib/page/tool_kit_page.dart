import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/page/note_page.dart';
import 'package:simple_app/page/todo_list_page.dart';

import '../components/base/buildBaseAppBar.dart';
import '../utils/showToast.dart';

class ToolKitPage extends StatefulWidget {
  const ToolKitPage({Key? key}) : super(key: key);

  @override
  _ToolKitPageState createState() => _ToolKitPageState();
}

class _ToolKitPageState extends State<ToolKitPage> {
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
    final List<Map> toolList = [
      {"RouterPath": '', "label": S.of(context).translate},
      {"RouterPath": '', "label": S.of(context).weatherQuery},
      {
        "RouterPath": '/note_list_page',
        "label": S.of(context).note,
        "comp": const NotePage()
      },
      {"RouterPath": '', "label": S.of(context).calculator},
      {
        "RouterPath": '/todo_list_page',
        "label": S.of(context).todoList,
        "comp": const TodoListPage()
      },
    ];
    return Scaffold(
        appBar: buildBaseAppBar(S.of(context).toolKit),
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
