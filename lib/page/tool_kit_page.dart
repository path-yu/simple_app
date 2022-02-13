import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/page/note_page.dart';
import 'package:simple_app/page/todo_list_page.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/show_toast.dart';

class ToolKitPage extends StatefulWidget {
  const ToolKitPage({Key? key}) : super(key: key);

  @override
  _ToolKitPageState createState() => _ToolKitPageState();
}

class _ToolKitPageState extends State<ToolKitPage> {
  void toRouterPage(Map map) {
    if (map['RouterPath'].isEmpty) {
      showToast(S.of(context).noDevelopment);
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
    final ButtonStyle raisedButtonStyle = ElevatedButton.styleFrom(
      onPrimary: Colors.black38,
      primary: context.watch<CurrentTheme>().isNightMode
          ? easyDarkColor
          : const Color.fromRGBO(248, 248, 248, 1.0),
      // minimumSize: const Size(88, 36),
      padding: const EdgeInsets.symmetric(horizontal: 16),
      maximumSize: const Size(100, 100),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(30)),
      ),
    );
    return Scaffold(
        appBar: buildBaseAppBar(S.of(context).toolKit),
        body: ListView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          children: toolList.map((e) {
            Color buttonTextColor;
            String routerPath = e['RouterPath'];
            if (routerPath.isEmpty) {
              buttonTextColor = Colors.grey;
            } else {
              buttonTextColor = context.watch<CurrentTheme>().isNightMode
                  ? Colors.white
                  : Colors.black;
            }
            return Container(
              height: ScreenUtil().setHeight(50),
              margin: EdgeInsets.only(top: ScreenUtil().setHeight(35)),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: ScreenUtil().setWidth(250),
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
                                fontSize: ScreenUtil().setSp(18),
                                color: buttonTextColor),
                          ),
                        )),
                  )
                ],
              ),
            );
          }).toList(),
        ));
  }
}
