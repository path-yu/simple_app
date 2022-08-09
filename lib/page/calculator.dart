import 'package:auto_size_text/auto_size_text.dart';
import 'package:decimal/decimal.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/main.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/show_toast.dart';

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

  // 按钮大小
  final int buttonSize = 68;

  // 按钮间隔
  final double space = 10;
  List operatorList = [
    'AC',
    'x',
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
    0,
    '.',
    '='
  ];

  // 运算表达式
  String expression = '';

  bool get expressionIsEmpty => expression.isEmpty;

  // 运算结果
  String answerResult = '0';

  // 是否点击计算;
  bool isScaleText = false;

  //上一次点击的运算符
  // ignore: prefer_typing_uninitialized_variables
  var prevClickOperator;

  // 当前点击的运算符
  // ignore: prefer_typing_uninitialized_variables
  var currentClickOperator;

  // 待结算的数据列表 如 23x43 即为 23,x,43
  List calcResultList = [];

  // 当前的所有数字列表
  List numOperatorList = ['0', '1', '2', '3', '4', '5', '6', '7', '8', '9'];

  // 计算运算符
  List operatorSymbolList = ['-', '+', '×', '÷'];

  // 其他运算符
  List otherOperatorList = [
    'x',
    '=',
    '.',
    'AC',
    '％',
  ];

  // 是否为计算运算符
  bool isCalcOperator(String value) => operatorSymbolList.contains(value);

  // 是否为数字运算符
  bool isNumberOperator(String value) => numOperatorList.contains(value);

  // 是否为其他操作运算符
  bool isOtherOperator(String value) => otherOperatorList.contains(value);

  // 用于过滤不正常的输入, 为true 表示过滤
  bool filterInput(String operator) {
    // 如果超过20位则不在计算, 只能进行AC 或清除
    if (expression.length >= 23) {
      showToast(S.of(context).outCalculationRange);
      if (operator == 'AC' || operator == 'x') {
        handleOtherOperatorClick(operator);
      }
      return true;
    }
    // 如果当前点击了计算运算符
    if (isCalcOperator(operator) && !expressionIsEmpty) {
      String lastExpression = expression[expression.length - 1];
      // 判断表达式前一位是否为数字而且不为运算符, 如果是则计算, 否则过滤
      if (isNumberOperator(lastExpression) &&
          !operatorSymbolList.contains(lastExpression)) {
        return false;
      } else {
        return true;
      }
    }
    // 如果当前点击了数字运算符
    if (isNumberOperator(operator)) {
      // 过滤输入0 时的数据异常边界值
      if (operator == '0') {
        if (expressionIsEmpty) return true;
        if (expression.length == 1) {
          return expression == '0';
        }
        // 判断倒数第二项是否不为为数字, 而且最后一位为0, 过滤类似 10+0 一直输入000
        var str = expression[expression.length - 2];
        var last = expression[expression.length - 1];
        if (!isNumberOperator(str) && last == '0') {
          return !(str == '.');
        } else {
          return false;
        }
      } else {
        if (expression.isNotEmpty && calcResultList.isNotEmpty) {
          String last = calcResultList.last;
          // 过滤最后一位数字为0时,输入02222类型情况
          return last.length == 1 && last == '0';
        }
        return false;
      }
    }
    // 其他运算符
    if (operator == '.' && expression.isNotEmpty) {
      String lastExpression = expression[expression.length - 1];
      // 确保计算式最后一位为数字而且不为运算符
      if (isNumberOperator(lastExpression) &&
          !operatorSymbolList.contains(lastExpression)) {
        // 判断最后一位是否只有一位小数点,如果不为一位则过滤 避免一直输入小数点
        return findStrCount(calcResultList.last, '.') != 0;
      }
      return true;
    }
    return false;
  }

  // 点击运算符
  void handleClick(dynamic operator) {
    if (filterInput(operator.toString())) return;
    // 记录当前点击的运算符和上一次的运算符 首次只能点击 数字
    if (currentClickOperator != null) {
      if (!['x', '=', 'AC', '％'].contains(operator)) {
        // 避免重复点击数据丢失
        if (prevClickOperator != currentClickOperator) {
          prevClickOperator = currentClickOperator;
        }
        currentClickOperator = operator.toString();
      }
    }
    // 确保第一次只能点击数据
    if (operator is int) {
      currentClickOperator = operator.toString();
      handleClickNum(operator);
      setState(() => isScaleText = false);
    } else {
      if (operatorSymbolList.contains(operator)) {
        handleOperatorSymbolClick(operator);
        setState(() => isScaleText = false);
      } else {
        handleOtherOperatorClick(operator);
      }
    }
  }

  void calcExpression() {
    // 第一次点击了数字
    if (isNumberOperator(currentClickOperator) && prevClickOperator == null) {
      setState(() {
        answerResult = currentClickOperator;
      });
      calcResultList.add(currentClickOperator);
    } else if (isNumberOperator(currentClickOperator) &&
        (isNumberOperator(prevClickOperator) || prevClickOperator == '.')) {
      String last = calcResultList.last;
      // 是否只有一个小数点, 并且最后一位不为运算符
      if (findStrCount(last, '.') == 0 &&
          !operatorSymbolList.contains(last) &&
          prevClickOperator == '.') {
        calcResultList.last += '.' + currentClickOperator;
      } else {
        calcResultList.last += currentClickOperator;
      }
    } else if (isCalcOperator(currentClickOperator) &&
        isNumberOperator(prevClickOperator)) {
      // 上一次为数字, 当前为运算符
      calcResultList.add(currentClickOperator);
    } else if (isNumberOperator(currentClickOperator) &&
        isCalcOperator(prevClickOperator)) {
      // 当前为数字.上一次为运算符
      calcResultList.add(currentClickOperator);
    } else if (prevClickOperator == '.' &&
        isCalcOperator(currentClickOperator)) {
      calcResultList.add(currentClickOperator);
    } else if (currentClickOperator == 'x') {
      /// 如果上一步为运算符则取上一步, 否则取最后一位运算符
      if (isCalcOperator(prevClickOperator) || prevClickOperator == '.') {
        if (calcResultList.last == 0) {
          prevClickOperator = null;
        } else {
          currentClickOperator =
              calcResultList.last[calcResultList.last.length - 1];
        }
      } else {
        currentClickOperator = prevClickOperator;
      }
    }
    calcResult();
  }

  // 计算 运算式的值
  void calcResult() {
    Decimal current = Decimal.zero;
    Decimal result = Decimal.zero;
    Decimal? next;
    String? operator;
    int currentIndex = 0;
    // 当前需要计算的次数0; 根据有多少运算符来判断
    int count = calcResultList
        .where((element) => operatorSymbolList.contains(element))
        .length;
    // 如果当前只有一项数字, 说明还没有输入运算符,则直接赋值
    if (calcResultList.length == 1) {
      result = Decimal.parse(calcResultList[0]);
    }

    for (int index = 0; index < count; index++) {
      // 第一次赋值
      if (current == Decimal.zero) {
        current = Decimal.parse(calcResultList[currentIndex]);
      }
      if (currentIndex + 2 < calcResultList.length) {
        next = Decimal.parse(calcResultList[currentIndex + 2]);
      } else {
        next = null;
      }
      if (currentIndex + 1 < calcResultList.length) {
        operator = calcResultList[currentIndex + 1];
      } else {
        operator = null;
      }
      currentIndex += 2;
      if (operator != null) {
        switch (operator) {
          case '×':
            current = result = current * (next ??= Decimal.one);
            break;
          case '+':
            current = result = current + (next ??= Decimal.zero);
            break;
          case '-':
            current = result = current - (next ??= Decimal.zero);
            break;
          case '÷':
            var answer = current.toBigInt() / (next ??= Decimal.one).toBigInt();
            result = current = Decimal.parse(answer.toString());
            break;
          default:
            break;
        }
      }
    }
    setState(() {
      answerResult = result.toString();
    });
  }

  // 处理计算运算符点击
  void handleOperatorSymbolClick(String operator) {
    if (expression.isNotEmpty) {
      setState(() {
        expression += operator;
      });
      calcExpression();
    }
  }

  // 处理其他运算符点击 'X', '=', '.', 'AC'
  void handleOtherOperatorClick(String operator) {
    //
    if (operator == 'AC') {
      setState(() {
        expression = '';
        answerResult = '0';
        calcResultList = [];
        currentClickOperator = null;
        prevClickOperator = null;
      });
    } else if (operator == '=') {
      setState(() {
        isScaleText = true;
      });
    } else if (operator == 'x') {
      if (calcResultList.isNotEmpty) {
        setState(() {
          expression = expression.substring(0, expression.length - 1);
        });
        String last = calcResultList.last;
        if (isCalcOperator(last)) {
          int index = calcResultList.lastIndexOf(last);
          calcResultList.removeAt(index);
        } else {
          if (last.length == 1) {
            int index = calcResultList.lastIndexOf(last);
            calcResultList.removeAt(index);
          } else {
            calcResultList.last = last.substring(0, last.length - 1);
          }
        }
        if (expression.isNotEmpty) {
          currentClickOperator = 'x';
          calcExpression();
        } else {
          expression = '';
          currentClickOperator = null;
          prevClickOperator = null;
          calcResultList.clear();
          answerResult = '0';
        }
      }
    } else if (operator == '.') {
      if (expression.isEmpty) {
        currentClickOperator = '.';
        prevClickOperator = '0';
        setState(() {
          expression = '0' '.';
          answerResult = '0';
        });
        calcResultList.add('0' '.');
      } else {
        setState(() {
          calcResultList.last = calcResultList.last + '.';
          expression += '.';
        });
      }
    } else {
      if (answerResult != '0' && expression.isNotEmpty) {
        setState(() {
          expression = '';
          currentClickOperator = null;
          prevClickOperator = null;
          calcResultList.clear();
          answerResult = (num.parse(answerResult) / 100).toString();
        });
      }
    }
  }

  // 点击数字
  void handleClickNum(int num) {
    setState(() {
      expression += num.toString();
    });
    calcExpression();
  }

  int findStrCount(String str, String s) {
    int i = 0;
    for (int index = 0; index < str.length; index++) {
      var element = str[index];
      if (element == s) {
        i++;
      }
    }
    return i;
  }

  @override
  Widget build(BuildContext context) {
    Color expressionColor = Colors.white10;
    Color answerColor = Colors.red;
    if (isScaleText) {
      // 是否为暗色环境
      if (context.watch<CurrentTheme>().isNightMode) {
        expressionColor = Colors.white30;
        answerColor = Colors.white;
      } else {
        expressionColor = Colors.black38;
        answerColor = Colors.black;
      }
    } else {
      // 是否为暗色环境
      if (context.watch<CurrentTheme>().isNightMode) {
        expressionColor = Colors.white;
        answerColor = Colors.white30;
      } else {
        expressionColor = Colors.black;
        answerColor = Colors.black38;
        // expressionColor =
      }
    }
    return Scaffold(
        appBar: buildBaseAppBar(title: S.of(context).calculator),
        body: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(20)),
          width: double.infinity,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // 运算表达式   ,
                    Visibility(
                        visible: expression.isNotEmpty,
                        child: AnimatedDefaultTextStyle(
                            child: AutoSizeText(
                              expression,
                              minFontSize: 16,
                              textAlign: TextAlign.right,
                              maxLines: 1,
                            ),
                            style: TextStyle(
                                color: expressionColor,
                                fontSize: isScaleText
                                    ? ScreenUtil().setSp(30)
                                    : ScreenUtil().setSp(48)),
                            duration: const Duration(milliseconds: 250))),
                    // answer
                    AnimatedDefaultTextStyle(
                        child: AutoSizeText(
                          answerResult != '0' ? '= ' + answerResult : '0',
                          minFontSize: 16,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                        ),
                        style: TextStyle(
                            color: answerColor,
                            fontSize: isScaleText
                                ? ScreenUtil().setSp(48)
                                : ScreenUtil().setSp(30)),
                        duration: const Duration(milliseconds: 250))
                  ],
                ),
              ),
              SizedBox(
                width: double.infinity,
                child: Wrap(
                    spacing: space,
                    runSpacing: space,
                    alignment: WrapAlignment.spaceBetween,
                    children: operatorList.map((e) {
                      Widget child;
                      if (e == 'x') {
                        child = Icon(
                          Icons.cleaning_services_outlined,
                          color: textColor,
                        );
                      } else {
                        child = Text(e is int ? e.toString() : e,
                            style: TextStyle(
                                color: textColor,
                                fontSize: ScreenUtil().setSp(22)));
                      }
                      return SizedBox(
                          width: e == 0
                              ? ScreenUtil().setWidth((buttonSize + space) * 2)
                              : ScreenUtil().setWidth(buttonSize),
                          height: e == 0
                              ? ScreenUtil().setWidth(buttonSize)
                              : ScreenUtil().setWidth(buttonSize),
                          child: NeumorphicButton(
                              onPressed: () => handleClick(e),
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: e == 0
                                    ? const NeumorphicBoxShape.stadium()
                                    : const NeumorphicBoxShape.stadium(),
                              ),
                              child: Center(
                                child: Transform.scale(
                                  scale: operatorSymbolList.contains(e) ||
                                          ['.', '='].contains(e)
                                      ? 1.8
                                      : 1,
                                  child: child,
                                ),
                              )));
                    }).toList()),
              )
            ],
          ),
        ));
  }
}
