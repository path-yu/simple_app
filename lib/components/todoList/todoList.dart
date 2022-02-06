import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/utils/showDialog.dart';

import 'buildToDoListTitle.dart';

class TodoList extends StatefulWidget {
  // 接受父组件传递的listdata
  final List listData;
  final String title;
  final Function checkBoxChange;
  final Function deleteToDoListItem;
  const TodoList({
    required Key key,
    required this.listData,
    required this.title,
    required this.checkBoxChange,
    required this.deleteToDoListItem,
  }) : super(key: key);
  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList>
    with SingleTickerProviderStateMixin {
  final GlobalKey<AnimatedListState> listkey = GlobalKey<AnimatedListState>();

  // The default insert/remove animation duration.
  final Duration _kDuration = const Duration(milliseconds: 300);
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

  void handleRemveItem(index) async {
    // 弹出对话框并等待其关闭 等获取它的返回值
    bool? delete = await showConfirmDialog(context, message: '确定删除当前todo吗');
    if (delete != null) {
      removeItem(index);
    }
  }

  @override
  void initState() {
    super.initState();
  }

  Widget _buildItem(Animation<double> _animation, int index) {
    Map target = widget.listData[index];
    String value = target['value'].toString();
    bool done = target['done'];
    String time = target['time'];
    return SizeTransition(
      sizeFactor: _animation,
      child: Container(
          color: Colors.white,
          height: ScreenUtil().setHeight(40),
          margin: EdgeInsets.only(top: ScreenUtil().setSp(15)),
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: done,
                          onChanged: (value) =>
                              widget.checkBoxChange(value, target, done)),
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
                      onPressed: () => handleRemveItem(index),
                    ),
                  ),
                ]),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print(widget.listData.length);
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
