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
    7,
    8,
    9,
    '×',
    4,
    5,
    6,
    '-',
    1,
    2,
    3,
    '+',
    '0',
    '.',
    '='
  ];
  // 运算表达式
  String expression = '';
  // 运算结果
  String answerResult = '0';
  // 是否点击计算;
  bool isClickEqual = false;

  List numList = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];
  List operatrorSymbolList = ['％', '-', '+', '×', '÷'];
  void handleOperator(dynamic operator) {
    String? answer;
    // 如果为数字
    if (operator is int) {
      handleClickNum(operator);
    } else {
      // 点击归零
      if (operator == 'AC') {
        expression = '0';
      }
      if (operatrorSymbolList.contains(operator)) {
        handleOperatroSymbolClick(operator);
      }
    }
    setState(() {
      if (answer != null) {
        answerResult = answer;
      }
    });
  }

  void calcExpression() {
    //todo
  }

  // 点击操作运算符
  void handleOperatroSymbolClick(String operator) {
    if (expression.isNotEmpty) {
      String lastExpression = expression[expression.length - 1];
      // 判断表达式前一位是否为数字而且不为运算符
      if (numList.contains(lastExpression) &&
          !operatrorSymbolList.contains(lastExpression)) {
        setState(() {
          expression += operator;
        });
      }
    }
  }

  // 点击数字
  void handleClickNum(int num) {
    setState(() {
      expression += num.toString();
    });
    if (expression.isNotEmpty) {
      // 最后一位数为数字
      if (numList.contains(expression[expression.length - 1])) {
        // 计算结果
        calcExpression();
      }
    }
  }

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
                    answerResult,
                    style: TextStyle(fontSize: ScreenUtil().setSp(48)),
                    textAlign: TextAlign.right,
                  ),
                  // 运算表达式
                  Visibility(
                      visible: expression.isNotEmpty,
                      child: Text(
                        expression,
                        style: TextStyle(
                            color: const Color(0xff666666),
                            fontSize: ScreenUtil().setSp(30)),
                        textAlign: TextAlign.right,
                      ))
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
                          onPressed: () => handleOperator(e),
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
                          child: Text(e is int ? e.toString() : e,
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
