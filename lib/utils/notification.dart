import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:simple_app/main.dart';

import './requesNoticetPermission.dart';

void init() async {}
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');
const IOSInitializationSettings initializationSettingsIOS =
    IOSInitializationSettings();
const MacOSInitializationSettings initializationSettingsMacOS =
    MacOSInitializationSettings();
const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
    iOS: initializationSettingsIOS,
    macOS: initializationSettingsMacOS);
// 显示通知栏
Future<void> showNotification(String message) async {
  // 判断是否有通知权限
  if (await requesNoticetPermission()) {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('your channel id', 'your channel name',
            channelDescription: 'your channel description',
            importance: Importance.max,
            priority: Priority.high,
            ticker: 'ticker');
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
        0, 'plain titl555e', 'plain body', platformChannelSpecifics,
        payload: 'item x');
  }
}

// 点击通知栏触发的事件 跳转到todoListpage 页面
void selectNotification(String? payload) async {
  debugPrint('notification payload: $payload');
  navigatorKey.currentState?.pushNamed(payload!);
}

Future<bool?> flutterLocalNotificationsPluginInit() {
// initialise the plugin. app_icon needs to be a added as a drawable resource to the Android head project
  return flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onSelectNotification: selectNotification);
}
