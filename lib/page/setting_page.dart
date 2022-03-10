import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/base/base_icon.dart';
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
      context.read<CurrentTheme>().changeMode(ThemeMode.dark);
    } else {
      context.read<CurrentTheme>().changeMode(ThemeMode.light);
    }
  }

  final NeumorphicStyle _neumorphicStyle = NeumorphicStyle(
      depth: -4,
      boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(20)));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(title: S.of(context).setting,backgroundColor: context.watch<CurrentTheme>().themeOrDarkColor),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return SizedBox(
              height: constraints.maxHeight,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                child: Column(
                  children: [
                    Neumorphic(
                      style: _neumorphicStyle,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                baseIcon(Icons.language_rounded,
                                    color: themeColor),
                                SizedBox(
                                  width: ScreenUtil().setWidth(10),
                                ),
                                baseText(
                                  S.of(context).switchLanguage,
                                )
                              ],
                            ),
                            NeumorphicSwitch(
                              height: ScreenUtil().setHeight(30),
                              style: const NeumorphicSwitchStyle(
                                  activeTrackColor: themeColor),
                              value: context
                                  .watch<CurrentLocale>()
                                  .languageIsEnglishMode,
                              onChanged: changeLanguage,
                            )
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Neumorphic(
                      style: _neumorphicStyle,
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                baseIcon(Icons.mode_night_rounded,
                                    color: themeColor),
                                SizedBox(
                                  width: ScreenUtil().setWidth(10),
                                ),
                                baseText(
                                  S.of(context).nightMode,
                                )
                              ],
                            ),
                            NeumorphicSwitch(
                              height: ScreenUtil().setHeight(30),
                              style: const NeumorphicSwitchStyle(
                                  activeTrackColor: themeColor),
                              value: context.watch<CurrentTheme>().isNightMode,
                              onChanged: changeNightMode,
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
