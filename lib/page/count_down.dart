import 'dart:async';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sound/flutter_sound.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_theme.dart';
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
  double size = ScreenUtil().setHeight(326);
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
  // 音频字节
  ByteData? bytes;
  // 播放控制器
  FlutterSoundPlayer? _myPlayer = FlutterSoundPlayer();
  // 是否开启微光
  bool enable = false;
  void handleStartClick() {
    if (pickerTime.inSeconds < 6) return;
    setState(() => show = true);
    const timeout = Duration(seconds: 1);
    progressValue = 0;
    int startSecond = 0;
    int totalSecond = pickerTime.inSeconds;
    int h = pickerTime.inHours;
    int m = (pickerTime.inMinutes % 60).toInt();
    int s = pickerTime.inSeconds - (m * 60) - (h * 60 * 60);
    setState(() {
      hour = h == 0 ? null : h;
      minutes = m == 0
          ? h == 0
              ? null
              : 0
          : m;
      second = s;
    });

    final buffer = bytes!.buffer;

    Timer.periodic(timeout, (timer) async {
      startSecond++;
      int diffSecond = totalSecond - startSecond;
      timerId = timer;
      success = false;
      _myPlayer!.startPlayer(
        fromDataBuffer:
            buffer.asUint8List(bytes!.offsetInBytes, bytes!.lengthInBytes),
        codec: Codec.mp3,
      );
      var time = Duration(seconds: diffSecond);
      // 更新时间
      setState(() {
        int timeH = time.inHours;
        int timeM = (time.inMinutes % 60).toInt();
        int timeS = time.inSeconds - (timeM * 60) - (timeH * 60 * 60);
        hour = timeH == 0 ? null : timeH;
        minutes = timeM == 0
            ? timeH == 0
                ? null
                : 0
            : timeM;
        second = timeS;
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
    fontSize: ScreenUtil().setSp(50),
    foreground: Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1
      ..color = Colors.white,
  );

  @override
  void dispose() {
    super.dispose();
    // 页面卸载 取消定时器
    timerId?.cancel();
    _myPlayer?.closePlayer();
    _myPlayer = null;
  }

  @override
  void initState() {
    super.initState();
    _myPlayer?.openPlayer().then((value) async {
      bytes = await rootBundle.load("assets/15199.mp3");
    });
  }

  void handleSwitchChange(value) {
    setState(() {
      // 如果小时为0, 则不显示小时, 且如果分为0, 则也不显示分
      if (hour == 0) {
        hour = null;
        if (minutes == 0) {
          minutes = null;
        }
      }
      enable = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Color> colors = [];
    bool isNightMode = context.read<CurrentTheme>().isNightMode;
    if (isNightMode) {
      colors = [Colors.black12, Colors.black];
    } else {
      colors = [const Color.fromRGBO(152, 203, 179, 0.5), themeColor];
    }
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
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: progressSize - 70,
                            margin: EdgeInsets.only(
                                bottom: ScreenUtil().setHeight(20)),
                            child: SwitchListTile(
                              activeColor: themeColor,
                              title: Text(
                                S.of(context).enableShimmerMessage,
                                style:
                                    TextStyle(fontSize: ScreenUtil().setSp(18)),
                              ),
                              onChanged: handleSwitchChange,
                              value: enable,
                            ),
                          ),
                          Stack(
                            children: [
                              Positioned(
                                child: SizedBox(
                                  height: progressSize,
                                  width: progressSize,
                                  child: CircularPercentIndicator(
                                    lineWidth: strokeWidth,
                                    animateFromLastPercent: true,
                                    backgroundColor: isNightMode
                                        ? Colors.grey.shade800
                                        : Colors.grey.shade300,
                                    circularStrokeCap: CircularStrokeCap.round,
                                    linearGradient:
                                        LinearGradient(colors: colors),
                                    percent: progressValue,
                                    radius: (progressSize),
                                    animation: true,
                                  ),
                                ),
                              ),
                              Positioned(
                                  top: strokeWidth,
                                  left: strokeWidth,
                                  child: ClipOval(
                                    child: Shimmer.fromColors(
                                      enabled: enable,
                                      child: Container(
                                        width: size,
                                        height: size,
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                              begin: Alignment.centerLeft,
                                              end: Alignment.centerRight,
                                              colors: colors),
                                        ),
                                      ),
                                      baseColor: isNightMode
                                          ? Colors.black12
                                          : themeColor,
                                      highlightColor: isNightMode
                                          ? Colors.black
                                          : Colors.green.shade200,
                                      period: const Duration(seconds: 1),
                                    ),
                                  )),
                              Positioned(
                                top: strokeWidth,
                                left: strokeWidth,
                                child: ClipOval(
                                    child: SizedBox(
                                        width: size,
                                        height: size,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
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
                                              visible: hour == 0
                                                  ? minutes != 0
                                                  : true,
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
                                        ))),
                              )
                            ],
                          )
                        ],
                      )
                    : Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: ScreenUtil().setHeight(100),
                            child: CupertinoTheme(
                                data: CupertinoThemeData(
                                    scaffoldBackgroundColor: Colors.red,
                                    textTheme: CupertinoTextThemeData(
                                        primaryColor: Colors.red,
                                        pickerTextStyle: TextStyle(
                                            color: context
                                                    .read<CurrentTheme>()
                                                    .isNightMode
                                                ? Colors.white
                                                : themeColor,
                                            fontSize: ScreenUtil().setSp(25)))),
                                child: Builder(
                                    builder: (context) => CupertinoTimerPicker(
                                        onTimerDurationChanged: (time) =>
                                            setState(
                                                () => pickerTime = time)))),
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
