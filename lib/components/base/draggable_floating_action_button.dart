import 'package:flutter/material.dart';

class DrageAbleFloatingActionButton extends StatefulWidget {
  //子控件
  Widget child;
  DrageAbleFloatingActionButton({Key? key, required this.child})
      : super(key: key);

  @override
  State<DrageAbleFloatingActionButton> createState() =>
      _DrageAbleFloatingActionButtonState();
}

class _DrageAbleFloatingActionButtonState
    extends State<DrageAbleFloatingActionButton> {
  Offset position = const Offset(0, 0);
  @override
  Widget build(BuildContext context) {
    if (position.dx == 0 && position.dx == 0) {
      position = Offset(MediaQuery.of(context).size.width - 60,
          MediaQuery.of(context).size.height - 60);
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
                onDragEnd: (details) {
                  setState(() {
                    position = details.offset;
                  });
                }))
      ],
    );
  }
}
