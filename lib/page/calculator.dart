import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/main.dart';
import 'package:simple_app/provider/current_theme.dart';

class CalculatorPage extends StatefulWidget {
  const CalculatorPage({Key? key}) : super(key: key);

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  @override
  void initState() {
    super.initState();
  }

  final Color textColor =
      navigatorKey.currentState!.context.watch<CurrentTheme>().isNightMode
          ? Colors.white
          : const Color(0xff999999);
  final primary = navigatorKey.currentState!.context
      .watch<CurrentTheme>()
      .themeBackgroundColor;
  List operatorList = [
    'AC',
    '±',
    '％',
    '÷',
    '7',
    '8',
    '9',
    '×',
    '4',
    '5',
    '6',
    '-',
    '1',
    '2',
    '3',
    '+',
    '0',
    '.',
    '='
  ];

  void handleOperator() {}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildBaseAppBar(S.of(context).calculator),
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setHeight(20)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  // answer
                  Text(
                    '6',
                    style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                    textAlign: TextAlign.right,
                  ),
                  // 运算表达式
                  Text(
                    '1x6',
                    style: TextStyle(
                        color: const Color(0xff666666),
                        fontSize: ScreenUtil().setSp(30)),
                    textAlign: TextAlign.right,
                  ),
                ],
              ),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                    spacing: 15,
                    runSpacing: 15,
                    alignment: WrapAlignment.spaceBetween,
                    children: operatorList.map((e) {
                      if (e == '0') {}
                      return ElevatedButton(
                          onPressed: () {},
                          style: ElevatedButton.styleFrom(
                              minimumSize: e == '0'
                                  ? const Size(160, 75)
                                  : const Size(75, 75),
                              shape: e == '0'
                                  ? const RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(35)),
                                    )
                                  : const CircleBorder(),
                              primary: primary),
                          child: Text(e,
                              style: TextStyle(
                                  color: textColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(24))));
                    }).toList()),
              )
            ],
          ),
        ));
  }
}
