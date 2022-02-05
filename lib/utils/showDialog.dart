import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:simple_app/generated/l10n.dart';

// 弹出对话框
Future<bool?> showConfirmDialog(BuildContext context,
    {String? tips, String? message, String? cancelText, String? confirmText}) {
  tips ??= S.of(context).hint;
  message ??= S.of(context).dialogDeleteMessage;
  cancelText ??= S.of(context).cancel;
  confirmText ??= S.of(context).confirm;
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return CupertinoAlertDialog(
        title: Text(tips!),
        content: Text(message!),
        actions: <Widget>[
          TextButton(
            child: Text(cancelText!),
            onPressed: () => Navigator.of(context).pop(), // 关闭对话框
          ),
          TextButton(
            child: Text(confirmText!),
            onPressed: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
            },
          ),
        ],
      );
    },
  );
}
