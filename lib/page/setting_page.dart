import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/components/base/base_text.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_locale.dart';
import 'package:simple_app/provider/current_theme.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  // 切换当前语言环境
  void changeLanguage(bool value) {
    if (value) {
      context.read<CurrentLocale>().setLocale(const Locale('en', 'US'));
    } else {
      context.read<CurrentLocale>().setLocale(const Locale('zh', 'CN'));
    }
  }

  // 切换夜间模式
  void changeNightMode(value) {
    if (value) {
      context.read<CurrentTheme>().changeMode(Brightness.dark);
    } else {
      context.read<CurrentTheme>().changeMode(Brightness.light);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(title: S.of(context).setting),
      body: ListView(
        physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics()),
        children: [
          SwitchListTile(
            title: Row(
              children: [
                const Icon(Icons.language_outlined),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                baseText(S.of(context).switchLanguage,
                    color: context.watch<CurrentTheme>().dartOrWhiteColor)
              ],
            ),
            value: context.watch<CurrentLocale>().languageIsEnglishMode,
            onChanged: changeLanguage,
          ),
          SwitchListTile(
            title: Row(
              children: [
                const Icon(Icons.mode_night_rounded),
                SizedBox(
                  width: ScreenUtil().setWidth(10),
                ),
                baseText(S.of(context).nightMode,
                    color: context.watch<CurrentTheme>().dartOrWhiteColor)
              ],
            ),
            value: context.watch<CurrentTheme>().isNightMode,
            onChanged: changeNightMode,
          )
        ],
      ),
    );
  }
}
