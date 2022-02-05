import 'package:flutter/cupertino.dart';
import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/components/base/baseText.dart';
import 'package:simple_app/components/base/buildBaseAppBar.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar('设置'),
      body: Column(
        children: [
          SwitchListTile(
            title: Row(
              children: [
                const Icon(Icons.language_outlined),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                baseText('切换语言为英语')
              ],
            ),
            value: false,
            onChanged: (value) {},
          ),
          SwitchListTile(
            title: Row(
              children: [
                const Icon(Icons.mode_night_rounded),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                baseText('夜间模式')
              ],
            ),
            value: false,
            onChanged: (value) {},
          )
        ],
      ),
    );
  }
}
