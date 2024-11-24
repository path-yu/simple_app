import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/main.dart';

import 'request_notice_permission.dart';

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
// const IOSInitializationSettings initializationSettingsIOS =
//     IOSInitializationSettings();
// const MacOSInitializationSettings initializationSettingsMacOS =
//     MacOSInitializationSettings();
const InitializationSettings initializationSettings = InitializationSettings(
  android: initializationSettingsAndroid,
);
// 显示通知栏
Future<void> showNotification(
    {required String message, String? payload, String? title}) async {
  title ??= S.of(navigatorKey.currentState!.context).todoNoticeTitle;
  // 判断是否有通知权限
  if (await requestNoticePermission()) {
    AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id',
            S.of(navigatorKey.currentState!.context).notificationName,
            channelDescription: S
                .of(navigatorKey.currentState!.context)
                .notificationDescription,
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin
        .show(0, title, message, platformChannelSpecifics, payload: payload);
  }
}

// 点击通知栏触发的事件 跳转到todoListPage 页面
void selectNotification(NotificationResponse? response) async {
  debugPrint('notification payload: $response.payload');
  if (response?.payload != null) {
    navigatorKey.currentState?.pushNamed(response?.payload as String);
  }
}

//  初始化本地通知插件
Future<bool?> flutterLocalNotificationsPluginInit() {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  return flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveBackgroundNotificationResponse: selectNotification);
}
