import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_theme.dart';

// 弹出对话框
Future<bool?> showConfirmDialog(BuildContext context,
    {String? tips,
    String? message,
    String? cancelText,
    String? confirmText,
    // 是否显示不在提示框
    bool showTips = true,
    void Function(bool?)? onChange}) {
  tips ??= S.of(context).hint;
  message ??= S.of(context).dialogDeleteMessage;
  cancelText ??= S.of(context).cancel;
  confirmText ??= S.of(context).confirm;
  TextStyle textStyle = TextStyle(
      color: context.read<CurrentTheme>().mainThemeOrSecondThemeColor);
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(tips!),
        content: WrapMaterialCheckBox(
          message: message!,
          label: S.of(context).noLongerTips,
          onChange: onChange,
          showTips: showTips,
        ),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText!, style: textStyle),
            onPressed: () => Navigator.of(context).pop(), // 关闭对话框
          ),
          TextButton(
            child: Text(
              confirmText!,
              style: textStyle,
            ),
            onPressed: () {
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}

// 封装checkbox
class WrapMaterialCheckBox extends StatefulWidget {
  // 提示信息
  final String message;
  // checkBox 左边文字
  final String label;
  final void Function(bool?)? onChange;
  final bool showTips;
  const WrapMaterialCheckBox(
      {Key? key, required this.message, required this.label, this.onChange, required this.showTips})
      : super(key: key);

  @override
  State<WrapMaterialCheckBox> createState() => WrapMaterialCheckBoxState();
}

class WrapMaterialCheckBoxState extends State<WrapMaterialCheckBox> {
  bool checkBoxValue = false;

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: Padding(
          padding: EdgeInsets.only(top: ScreenUtil().setHeight(10)),
          child: Column(
            children: [
              Text(widget.message),
             widget.showTips ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 30,
                    height: 30,
                    child: Checkbox(
                      shape: const CircleBorder(),
                      activeColor: context
                          .read<CurrentTheme>()
                          .mainThemeOrSecondThemeColor,
                      value: checkBoxValue,
                      onChanged: (bool? value) {
                        setState(() => checkBoxValue = value!);
                        if (widget.onChange != null) {
                          widget.onChange!(value);
                        }
                      },
                    ),
                  ),
                  Text(widget.label)
                ],
              ) :Container()
            ],
          ),
        ));
  }
}
