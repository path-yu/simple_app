import 'package:flutter/material.dart';

// ignore: must_be_immutable
class DragAbleFloatingActionButton extends StatefulWidget {
  //子控件
  Widget child;
  DragAbleFloatingActionButton({Key? key, required this.child})
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
  void handleDragEnd(DraggableDetails details) {
    double dx = details.offset.dx;
    double dy = details.offset.dy;
    // 边界限定
    if (dx <= 0 || dy <= 0 || dx >= maxWidth! - 60 || dy >= maxHeight! - 60) {
      return;
    }
    setState(() {
      position = details.offset;
    });
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
            child: Draggable(
                feedback: widget.child,
                child: widget.child,
                childWhenDragging: Container(),
                onDragEnd: handleDragEnd))
      ],
    );
  }
}
