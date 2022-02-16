import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/show_dialog.dart';

class TodoList extends StatefulWidget {
  // 接受父组件传递的listdata
  final List listData;
  final String title;
  final Function checkBoxChange;
  final Function deleteToDoListItem;
  final GlobalKey<SearchBarState> searchBarKey;
  final Function updateTodoTopping;
  // 是否展开
  final bool isSpread;
  const TodoList(
      {required Key key,
      required this.listData,
      required this.title,
      required this.isSpread,
      required this.checkBoxChange,
      required this.deleteToDoListItem,
      required this.searchBarKey,
      required this.updateTodoTopping})
      : super(key: key);

  @override
  TodoListState createState() => TodoListState();
}

class TodoListState extends State<TodoList>
    with SingleTickerProviderStateMixin, WidgetsBindingObserver {
  final GlobalKey<AnimatedListState> _listkey = GlobalKey<AnimatedListState>();

  // The default insert/remove animation duration.
  final Duration _kDuration = const Duration(milliseconds: 300);

  // 拷贝父组件数据
  List myList = [];
  // 是否展开
  bool isSpread = true;
  // 当前组件的高度
  double? currentHeight;
  // 每个todo 平均高度
  double? averageHeight;

  //列表总数
  int? count;
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
    _listkey.currentState?.removeItem(
        _index, (context, animation) => _buildItem(animation, _index),
        duration: _kDuration);
  }

  void addItem() {
    final _index = widget.listData.length;
    count = myList.length + 1;
    _getContainerHeight(null);
    _listkey.currentState?.insertItem(_index, duration: _kDuration);
  }

  void handleRemoveItem(index) async {
    // 失去焦点
    widget.searchBarKey.currentState!.textFieldFocusNode.unfocus();
    // 弹出对话框并等待其关闭 等获取它的返回值
    bool? delete = await showConfirmDialog(context,
        message: S.of(context).deleteTodoMessage);

    if (delete != null) {
      count = myList.length - 1;
      _getContainerHeight(null);
      removeItem(index);
    }
  }

  void handleCheckBoxChange(bool value, Map target, bool done, int index) {
    // 先更新todo done自身状态, 在调用父级方法更新列表数据
    setState(() {
      myList[index]['done'] = value;
    });

    Future.delayed(const Duration(milliseconds: 100), () {
      myList[index]['done'] = !value;
      count = myList.length - 1;
      _getContainerHeight(null);
      widget.checkBoxChange(value, target, done);
    });
  }

  // 置顶 or 取消置顶
  void handleTopping(int index, Map target) {
    // 是否置顶? 原位置, 新位置, 置顶数 ?
    int? oldIndex;
    int? newIndex;
    bool? isTopping;
    // 取消置顶
    if (target['isTop']) {
      // 如果oldTopIndex 不为null,则获取当前todo的oldTopIndex, 否则获取当前索引下标
      if (target['oldTopIndex'] != null) {
        newIndex = target['oldTopIndex'];
      } else {
        newIndex = index;
      }
      oldIndex = target['newTopIndex'];
      isTopping = false;
    } else {
      // 置顶
      isTopping = true;
      // 找到最后一个置顶的数据
      int resultIndex =
          myList.lastIndexWhere((element) => element['isTop'] == true);
      if (resultIndex != -1) {
        // 如果为第一项置顶
        if (resultIndex == 0 && index == 0) {
          newIndex = 0;
          oldIndex = 0;
        }
        //如果当前指定的元素为最后一个,则返回最后一个置顶下标, 否则置顶下标 + 1
        newIndex =
            resultIndex == myList.length - 1 ? resultIndex : resultIndex + 1;
        oldIndex = target['oldIndex'] ?? index;
      } else {
        // 如果为第一个置顶 则不需要交换
        if (index == 0) {
          newIndex = 0;
          oldIndex = 0;
        } else {
          // 如果当前 前后两次下标相等, 说明不是第一次置顶,
          if (target['oldTopIndex'] != null &&
              target['newTopIndex'] != null &&
              target['oldTopIndex'] == target['newTopIndex']) {
            oldIndex = target['oldTopIndex'];
            newIndex = 0;
          } else {
            oldIndex = target['oldTopIndex'] ?? index;
            newIndex = target['newTopIndex'] ?? 0;
          }
        }
      }
    }
    widget.updateTodoTopping(myList[oldIndex!], myList[newIndex!], isTopping,
        newTopIndex: newIndex, oldTopIndex: oldIndex);
  }

  @override
  void initState() {
    super.initState();
    myList = widget.listData;
    isSpread = widget.isSpread;
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didUpdateWidget(covariant TodoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    myList = widget.listData;
    isSpread = widget.isSpread;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback(_getContainerHeight);
  }

  _getContainerHeight(_) {
    count ??= myList.length;
    var height;
    if (averageHeight == null) {
      height =
          (_listkey.currentContext?.size!.height)! + ScreenUtil().setHeight(20);
      averageHeight = (height - ScreenUtil().setHeight(20)) / myList.length;
    } else {
      height =
          (averageHeight! * count!.toDouble()) + ScreenUtil().setHeight(20);
    }
    setState(() {
      isSpread = true;
      currentHeight = count == 0 ? 0 : height;
    });
  }

  Widget _buildItem(Animation<double> _animation, int index) {
    Map target = myList[index];
    String value = target['value'].toString();
    bool done = target['done'];
    String time = target['time'];
    bool isTop = target['isTop'];
    return SizeTransition(
      sizeFactor: _animation,
      child: Container(
          color: context.watch<CurrentTheme>().isNightMode
              ? isTop
                  ? const Color.fromRGBO(26, 26, 26, 1)
                  : Colors.black12
              : isTop
                  ? const Color.fromRGBO(244, 244, 244, 1)
                  : Colors.white,
          child: Center(
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Checkbox(
                          value: done,
                          shape: const CircleBorder(),
                          onChanged: (value) => handleCheckBoxChange(
                              value!, target, done, index)),
                      Text(value),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        time,
                        textAlign: TextAlign.right,
                      ),
                      SizedBox(
                        width: ScreenUtil().setWidth(30),
                      )
                    ],
                  ),
                ]),
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutSine,
      padding: EdgeInsets.all(ScreenUtil().setSp(10)),
      height: isSpread ? currentHeight : 0,
      child: AnimatedList(
        shrinkWrap: true,
        key: _listkey,
        physics: const NeverScrollableScrollPhysics(), // 去掉回弹效果 避免滑动冲突
        initialItemCount: widget.listData.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          Map target = myList[index];
          bool isTop = target['isTop'];
          return Slidable(
            key: const ValueKey(0),
            child: Column(
              children: [
                SizedBox(
                  height: ScreenUtil().setHeight(5),
                ),
                _buildItem(animation, index)
              ],
            ),
            endActionPane: ActionPane(
              motion: const DrawerMotion(),
              extentRatio: isTop ? 0.6 : 0.5,
              children: [
                SlidableAction(
                  spacing: 1,
                  // An action can be bigger than the others.
                  flex: 1,
                  onPressed: (BuildContext context) => handleRemoveItem(index),
                  backgroundColor: const Color(0xFF7BC043),
                  foregroundColor: Colors.white,
                  label: S.of(context).delete,
                ),
                SlidableAction(
                  flex: isTop ? 2 : 1,
                  spacing: 1,
                  onPressed: (BuildContext context) =>
                      handleTopping(index, target),
                  backgroundColor: const Color(0xFF0392CF),
                  foregroundColor: Colors.white,
                  label: isTop
                      ? S.of(context).cancelTopping
                      : S.of(context).topping,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
