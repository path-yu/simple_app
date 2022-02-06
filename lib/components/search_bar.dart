import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController _todoController;
  final void Function(String) addConfrim;
  final TextInputAction textInputAction;
  final String placeHolder;
  Color fillColor;
  Icon prefixIcon;
  int inputWidth;
  SearchBar(this._todoController, this.addConfrim, this.textInputAction,
      this.placeHolder,
      {Key? key,
      required this.prefixIcon,
      this.fillColor = Colors.white,
      this.inputWidth = 250})
      : super(key: key);

  @override
  _SearchBarState createState() => _SearchBarState();
}

class _SearchBarState extends State<SearchBar> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints(
          maxHeight: ScreenUtil().setSp(40),
          maxWidth: ScreenUtil().setSp(widget.inputWidth)),
      child: TextField(
        controller: widget._todoController,
        textInputAction: widget.textInputAction,
        onSubmitted: widget.addConfrim,
        style: const TextStyle(color: Colors.black87),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          hintText: widget.placeHolder,
          hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(15), color: Colors.black26),
          prefixIcon: widget.prefixIcon,
          // 设置右边图标
          suffixIcon: IconButton(
              icon: const Icon(Icons.clear),
              iconSize: ScreenUtil().setSp(15),
              highlightColor: Colors.white,
              onPressed: () => widget._todoController.text = ""),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
          filled: true,
          fillColor: widget.fillColor,
        ),
      ),
    );
  }
}
