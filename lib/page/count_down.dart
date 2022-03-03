import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'dart:async';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:simple_app/utils/show_dialog.dart';
import 'package:simple_app/utils/show_toast.dart';
import 'package:vibration/vibration.dart';

class CountDownPage extends StatefulWidget {
  const CountDownPage({Key? key}) : super(key: key);

  @override
  State<CountDownPage> createState() => _CountDownPageState();
}

class _CountDownPageState extends State<CountDownPage> {
  // 倒计时时间
  Duration pickerTime = const Duration(seconds: 0);

  // 是否显示倒计时看板
  bool show = false;
  // 圆形大小背景
  double size = ScreenUtil().setHeight(350);
  // 进度条宽高度
  double progressSize = ScreenUtil().setHeight(350);
  // 进度条大小
  double strokeWidth = ScreenUtil().setHeight(12);
  // 进度条进度
  double progressValue = 0;
  // 倒计时是否结束
  bool success = false;
  // 当前时间
  int? hour;
  int? minutes;
  num? second;
  // 定时器id
  Timer? timerId;
  // 计数器过渡动画
  final Duration _duration = const Duration(milliseconds: 250);
  void handleStartClick() {
    if (pickerTime.inSeconds < 6) return;
    setState(() => show = true);
    const timeout = Duration(seconds: 1);
    // progressValue = 0;
    int startSecond = 0;
    int totalSecond = pickerTime.inSeconds;
    int h = pickerTime.inHours;
    int m = (pickerTime.inMinutes % 60).toInt();
    int s = pickerTime.inSeconds - (m * 60) - (h * 60 * 60);
    setState(() {
      minutes = m == 0
          ? h == 0
              ? null
              : 0
          : m;
      second = s;
      hour = h == 0 ? null : h;
    });
    Timer.periodic(timeout, (timer) async {
      startSecond++;
      int diffSecond = totalSecond - startSecond;
      timerId = timer;
      success = false;
      var time = Duration(seconds: diffSecond);
      // 更新时间
      setState(() {
        int timeH = time.inHours;
        int timeM = (time.inMinutes % 60).toInt();
        int timeS = time.inSeconds - (timeM * 60) - (timeH * 60 * 60);
        minutes = timeM == 0
            ? timeH == 0
                ? null
                : 0
            : timeM;
        second = timeS;
        hour = timeH == 0 ? null : timeH;
        progressValue = startSecond / totalSecond;
      });
      // 倒计时完成
      if (diffSecond == 0) {
        timer.cancel();
        await Future.delayed(const Duration(milliseconds: 300));
        setState(() {
          show = false;
          hour = null;
          minutes = null;
          second = null;
          pickerTime = const Duration(seconds: 0);
          progressValue = 0;
        });
        success = true;
        if (await Vibration.hasCustomVibrationsSupport() != null) {
         Vibration.vibrate(duration: 2500, amplitude: 128);
        }
        showToast(S.of(context).timeOut);
      }
    });
  }

  Future<bool> handleOnWillPop() async {
    // 判断是否结束
    if (success) {
      return true;
    }
    // 判断是否退出
    if (await showConfirmDialog(context,
            message: S.of(context).cancelCountDownMessage) !=
        null) {
      return true;
    }
    return false;
  }

  TextStyle textStyle = TextStyle(
      height: 1.5,
      fontSize: ScreenUtil().setSp(35),
      textBaseline: TextBaseline.alphabetic);

  @override
  void dispose() {
    super.dispose();
    // 页面卸载 取消定时器
    timerId?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          appBar: buildBaseAppBar(title: S.of(context).countDown),
          body: Center(
            child: AnimatedSwitcher(
              duration: const Duration(milliseconds: 350),
              transitionBuilder: (child, animation) {
                return ScaleTransition(
                  scale: animation,
                  child: child,
                );
              },
              child: Container(
                key: ValueKey<bool>(show),
                child: show
                    ? ClipOval(
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 100),
                          width: size,
                          height: size,
                          child: Stack(
                            children: [
                              Positioned(
                                child: SizedBox(
                                  height: progressSize,
                                  width: progressSize,
                                  child: CircularPercentIndicator(
                                    lineWidth: strokeWidth,
                                    animateFromLastPercent: true,
                                    backgroundColor: Colors.grey,
                                    circularStrokeCap: CircularStrokeCap.butt,
                                    linearGradient: const LinearGradient(
                                        colors: [
                                          Color.fromRGBO(179, 217, 200, 0.7),
                                          themeColor
                                        ]),
                                    percent: progressValue,
                                    radius: (progressSize),
                                    animation: true,
                                  ),
                                ),
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Visibility(
                                      visible: hour != null,
                                      child: Center(
                                        child: AnimatedFlipCounter(
                                          value: hour ??= 0,
                                          duration: _duration,
                                          textStyle: textStyle,
                                        ),
                                      )),
                                  Visibility(
                                    visible: hour != 0,
                                    child: Text(
                                      ':',
                                      style: textStyle,
                                    ),
                                  ),
                                  Visibility(
                                      visible: minutes != null,
                                      child: Center(
                                        child: AnimatedFlipCounter(
                                          value: minutes ??= 0,
                                          duration: _duration,
                                          textStyle: textStyle,
                                        ),
                                      )),
                                  Visibility(
                                    visible: minutes != 0,
                                    child: Text(
                                      ':',
                                      style: textStyle,
                                    ),
                                  ),
                                  Visibility(
                                      visible: second != null,
                                      child: Center(
                                        child: AnimatedFlipCounter(
                                          value: second ??= 0,
                                          duration: _duration,
                                          textStyle: textStyle,
                                        ),
                                      ))
                                ],
                              )
                            ],
                          ),
                          decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [Colors.white, themeColor])),
                        ),
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(85),
                            child: CupertinoTimerPicker(
                                onTimerDurationChanged: (time) =>
                                    setState(() => pickerTime = time)),
                          ),
                          SizedBox(
                            height: ScreenUtil().setHeight(50),
                          ),
                          SizedBox(
                            width: 200,
                            child: NeumorphicButton(
                              style: const NeumorphicStyle(
                                  boxShape: NeumorphicBoxShape.stadium()),
                              onPressed: handleStartClick,
                              child: Text(
                                S.of(context).startTiming,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    color: pickerTime.inSeconds > 6
                                        ? context
                                                .read<CurrentTheme>()
                                                .isNightMode
                                            ? Colors.white
                                            : Colors.black
                                        : Colors.grey),
                              ),
                            ),
                          )
                        ],
                      ),
              ),
            ),
          ),
        ),
        onWillPop: show ? handleOnWillPop : null);
  }
}
