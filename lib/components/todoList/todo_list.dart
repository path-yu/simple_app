import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/components/todoList/build_todo_list_title.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/show_dialog.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

class TodoList extends StatefulWidget {
  // 接受父组件传递的listdata
  final List listData;
  final String title;
  final Function checkBoxChange;
  final Function deleteToDoListItem;
  final GlobalKey<SearchBarState> searchBarKey;

  const TodoList({
    required Key key,
    required this.listData,
    required this.title,
    required this.checkBoxChange,
    required this.deleteToDoListItem,
    required this.searchBarKey,
  }) : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> listkey = GlobalKey<AnimatedListState>();

  // The default insert/remove animation duration.
  final Duration _kDuration = const Duration(milliseconds: 300);


  // 拷贝父组件数据
  List myList = [];

  void removeItem(_index) {
    animatedRemoveItem(_index);
    // 因为删除动画需要时间300 毫秒 所以需要等待300ms后
    // 调用父组件的方法删除对应的原数据  因为父组件调用了setState所以会触发子组件重新build 所以需要避免发生下标异常
    // 假设原数组中两个元素, 当删除第二个即下标为1的元素时, 如果此时直接调用父组件的删除, 会触发子组件重新build
    // 由于动画是异步执行的, 所以它会等待build后在进行调用 重新数组的长度为1 ,而原生删除的下标为1, 则有可能此时会触发异常
    Future.delayed(const Duration(milliseconds: 350), () {
      widget.deleteToDoListItem(widget.listData[_index]);
    });
  }

  void animatedRemoveItem(_index) {
    listkey.currentState?.removeItem(
        _index, (context, animation) => _buildItem(animation, _index),
        duration: _kDuration);
  }

  void addItem() {
    final _index = widget.listData.length;
    listkey.currentState?.insertItem(_index, duration: _kDuration);
  }

  void handleRemoveItem(index) async {
    // 失去焦点
    widget.searchBarKey.currentState!.textFieldFocusNode.unfocus();
    // 弹出对话框并等待其关闭 等获取它的返回值
    bool? delete = await showConfirmDialog(context,
        message: S.of(context).deleteTodoMessage);

    if (delete != null) {
      removeItem(index);
    }
  }

  void handleCheckBoxChange(bool value, Map target, bool done,int index) {
    // 先更新todo done自身状态, 在调用父级方法更新列表数据
    setState(() {
      myList[index]['done'] = value;
    });
    Future.delayed(const Duration(milliseconds: 200),(){
      myList[index]['done'] = !value;
      widget.checkBoxChange(value, target, done);
    });
  }

  @override
  void initState() {
    super.initState();
    setState(() => myList = widget.listData);
  }

  @override
  void didUpdateWidget(covariant TodoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    setState(() => myList = widget.listData);
  }
  Widget _buildItem(Animation<double> _animation, int index) {
    Map target = myList[index];
    String value = target['value'].toString();
    bool done = target['done'];
    String time = target['time'];
    return SizeTransition(
      sizeFactor: _animation,
      child: Container(
          color: context.watch<CurrentTheme>().isNightMode
              ? Colors.black12
              : Colors.white,
          margin: EdgeInsets.only(top: ScreenUtil().setSp(10)),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: done,
                          shape: const CircleBorder(),
                          onChanged: (value) =>
                              handleCheckBoxChange(value!, target, done,index)),
                      Text(value),
                    ],
                  ),
                  Expanded(
                      child: Text(
                    time,
                    textAlign: TextAlign.center,
                  )),
                  SizedBox(
                    height: ScreenUtil().setHeight(40),
                    child: IconButton(
                      icon: const Icon(Icons.clear),
                      iconSize: ScreenUtil().setSp(20),
                      onPressed: () => handleRemoveItem(index),
                    ),
                  ),
                ]),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print("build");
    return Container(
      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
      child: Column(
        children: [
          buildTodoListTitle(widget.title, widget.listData.length),
          SizedBox(
            height: ScreenUtil().setHeight(10),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(350)),
            child: AnimatedList(
              shrinkWrap: true,
              key: listkey,
              physics: const BouncingScrollPhysics(),
              initialItemCount: widget.listData.length,
              itemBuilder: (BuildContext context, int index,
                  Animation<double> animation) {
                return _buildItem(animation, index);
              },
            ),
          )
        ],
      ),
    );
  }
}
