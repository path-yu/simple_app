import 'package:permission_handler/permission_handler.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/main.dart';

import 'show_dialog.dart';

// 获取app 是否具有通知权限 如果没有则弹出对话框 跳转到设置界面
Future requesNoticetPermission() async {
  // 判断是否没有通知权限 如果没有则弹出对话框 打开设置界面提示用户添加权限
  if (await Permission.notification.isDenied) {
    // 打开对话框 提示用户是否前往设置界面设置权限
    bool? result = await showConfirmDialog(navigatorKey.currentState!.context,
        message:
            S.of(navigatorKey.currentState!.context).noNotificationPermission);
    //判断result是否为空, 不为空说明点击了确定按钮
    if (result != null) {
      openAppSettings();
    }
    return false;
  } else {
    return true;
  }
}
