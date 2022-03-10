import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/page/calculator.dart';
import 'package:simple_app/page/count_down.dart';
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
      {
        "RouterPath": '/count_down',
        "label": S.of(context).countDown,
        "comp": const CountDownPage()
      },
      {
        "RouterPath": '/note_list_page',
        "label": S.of(context).note,
        "comp": const NotePage()
      },
      {
        "RouterPath": 'calculator',
        "label": S.of(context).calculator,
        "comp": const CalculatorPage()
      },
      {
        "RouterPath": '/todo_list_page',
        "label": S.of(context).todoList,
        "comp": const TodoListPage()
      },
    ];

    return Scaffold(
        appBar: buildBaseAppBar(title: S.of(context).toolKit),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: toolList.map((e) {
                    Color buttonTextColor;
                    String routerPath = e['RouterPath'];
                    if (routerPath.isEmpty) {
                      buttonTextColor = Colors.grey;
                    } else {
                      buttonTextColor =
                          context.watch<CurrentTheme>().isNightMode
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
                            child: NeumorphicButton(
                                style: const NeumorphicStyle(
                                    shape: NeumorphicShape.concave,
                                    depth: 4,
                                    lightSource: LightSource.bottomRight,
                                    boxShape: NeumorphicBoxShape.stadium()),
                                onPressed: () => toRouterPage(e),
                                child: Center(
                                  child: Text(
                                    "${e['label']}",
                                    style: TextStyle(color: buttonTextColor),
                                  ),
                                )),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            );
          },
        ));
  }
}
