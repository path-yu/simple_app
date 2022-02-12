import "package:flutter/material.dart";
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/common/color.dart';

class SearchBar extends StatefulWidget {
  final TextEditingController _todoController;
  final void Function(String) addConfirm;
  final TextInputAction textInputAction;
  final String placeHolder;
  final Color fillColor;
  final Icon prefixIcon;
  final int inputWidth;
  const SearchBar(this._todoController, this.addConfirm, this.textInputAction,
      this.placeHolder,
      {Key? key,
      required this.prefixIcon,
      this.fillColor = Colors.white,
      this.inputWidth = 250})
      : super(key: key);

  @override
  SearchBarState createState() => SearchBarState();
}

class SearchBarState extends State<SearchBar> {
  final FocusNode textFieldFocusNode = FocusNode();
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
        onSubmitted: widget.addConfirm,
        focusNode: textFieldFocusNode,
        style:
            TextStyle(color: Colors.black87, fontSize: ScreenUtil().setSp(15)),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.symmetric(vertical: 4.0),
          hintText: widget.placeHolder,

          hintStyle: TextStyle(
              fontSize: ScreenUtil().setSp(15), color: Colors.black26),
          prefixIcon: widget.prefixIcon,
          // 设置右边图标
          suffixIcon: IconButton(
              enableFeedback: false,
              icon: const Icon(Icons.clear),
              iconSize: ScreenUtil().setSp(18),
              splashColor: Colors.transparent,
              color: themeColor,
              onPressed: () {
                widget._todoController.text = "";
                textFieldFocusNode.unfocus();
              }),
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
