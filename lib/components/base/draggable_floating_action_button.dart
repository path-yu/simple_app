import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DragAbleFloatingActionButton extends StatefulWidget {
  //子控件
  Widget child;
  GlobalKey parentKey;
  DragAbleFloatingActionButton(
      {Key? key, required this.child, required this.parentKey})
      : super(key: key);

  @override
  State<DragAbleFloatingActionButton> createState() =>
      _DragAbleFloatingActionButtonState();
}

class _DragAbleFloatingActionButtonState
    extends State<DragAbleFloatingActionButton> {
  Offset position = const Offset(0, 0);
  double? maxHeight;
  double? maxWidth;
  final GlobalKey _key = GlobalKey();

  Offset? _minOffset;
  Offset? _maxOffset;
  void _updatePosition(PointerMoveEvent pointerMoveEvent) {
    double newOffsetX = position.dx + pointerMoveEvent.delta.dx;
    double newOffsetY = position.dy + pointerMoveEvent.delta.dy;
    //  边界限定
    if (newOffsetX < _minOffset!.dx) {
      newOffsetX = _minOffset!.dx;
    } else if (newOffsetX > _maxOffset!.dx) {
      newOffsetX = _maxOffset!.dx;
    }

    if (newOffsetY < _minOffset!.dy) {
      newOffsetY = _minOffset!.dy;
    } else if (newOffsetY > _maxOffset!.dy) {
      newOffsetY = _maxOffset!.dy;
    }
    setState(() {
      position = Offset(newOffsetX, newOffsetY);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback(_setBoundary);
  }

  void _setBoundary(_) {
    final RenderBox renderBox =
        _key.currentContext?.findRenderObject() as RenderBox;
    try {
      final Size size = renderBox.size;
      setState(() {
        _minOffset = const Offset(30, 30);
        _maxOffset = Offset(maxWidth! - size.width, maxHeight! - size.height);
      });
    } catch (e) {
      if (kDebugMode) {
        print('catch: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (position.dx == 0 && position.dy == 0) {
      maxHeight = MediaQuery.of(context).size.height;
      maxWidth = MediaQuery.of(context).size.width;
      position = Offset(maxWidth! - 56, maxHeight! - 56);
    }

    return Stack(
      children: [
        Positioned(
          top: position.dy,
          left: position.dx,
          child: Listener(
            onPointerMove: (PointerMoveEvent pointerMoveEvent) {
              _updatePosition(pointerMoveEvent);
            },
            child: Container(
              child: widget.child,
              key: _key,
            ),
          ),
        )
      ],
    );
  }
}
