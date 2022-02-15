// 因为不需要保持状态，所以这里继承的是StatelessWidget
import 'package:flutter/material.dart';

class HideKeyboard extends StatelessWidget {
  final Widget child;

  const HideKeyboard({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: child,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          /// 取消焦点，相当于关闭键盘
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
    );
  }
}
