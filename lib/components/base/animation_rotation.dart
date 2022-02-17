import 'package:flutter/material.dart';

class AnimatedToggleRotation extends StatefulWidget {
  // 子控件
  final Widget child;
  //是否切换
  final bool toggleValue;
  //过渡时间
  final Duration? duration;
  const AnimatedToggleRotation(
      {Key? key,
      required this.child,
      required this.toggleValue,
      this.duration = const Duration(milliseconds: 200)})
      : super(key: key);

  @override
  _AnimatedToggleRotationState createState() => _AnimatedToggleRotationState();
}

class _AnimatedToggleRotationState extends State<AnimatedToggleRotation>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: widget.duration);
    forward();
    print("i");
  }

  forward() {
    if (widget.toggleValue) {
      _animation = Tween(begin: .0, end: .5).animate(_animationController);
      //开始动画
    } else {
      _animation = Tween(begin: .5, end: .0).animate(_animationController);
    }
    _animationController.forward();
  }

  @override
  void dispose() {
    super.dispose();
    _animationController.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("object");
    forward();
  }

  @override
  Widget build(BuildContext context) {
    return RotationTransition(
      turns: _animation,
      child: widget.child,
    );
  }
}
