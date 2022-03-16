import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/show_dialog.dart';

// ignore: must_be_immutable
class TodoList extends StatefulWidget {
  // 接受父组件传递的listdata
  final List listData;

  //切换todo 状态
  final Function checkBoxChange;

  //删除todo
  final Function deleteToDoListItem;

  //搜索框key
  final GlobalKey<SearchBarState> searchBarKey;

  // 更新置顶状态
  final Function updateTodoTopping;

  //更新展开状态
  final void Function()? updateSpread;

  // 是否展开
  bool isSpread;

  // 交换todo
  final void Function(Map oldTarget, Map newTarget) swapTodo;

  TodoList(
      {required Key key,
      required this.listData,
      required this.checkBoxChange,
      required this.deleteToDoListItem,
      required this.searchBarKey,
      required this.updateTodoTopping,
      this.updateSpread,
      required this.isSpread,
      required this.swapTodo})
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

  // 当前组件的高度
  double? currentHeight;

  // 边距
  double marin = ScreenUtil().setHeight(10);

// 内边距
  double padding = ScreenUtil().setHeight(10);

  // 每个todo 平均高度
  double averageHeight = 50;

  //列表总数
  int? count;

  // 是否不再提示删除弹窗
  bool isNoTips = false;

  void removeItem(_index) {
    count = myList.length - 1;
    _getContainerHeight(null);
    // 如果删完了则更新展开状态
    if (count == 0) {
      widget.updateSpread!();
    }
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

  void addItem() async {
    final _index = widget.listData.length;
    count = myList.length + 1;
    _getContainerHeight(null);
    _listkey.currentState?.insertItem(_index, duration: _kDuration);
    await Future.delayed(const Duration(milliseconds: 350));
  }

  void handleRemoveItem(index) async {
    if (isNoTips) {
      return removeItem(index);
    }
    // 失去焦点
    widget.searchBarKey.currentState!.textFieldFocusNode.unfocus();
    bool checkBoxValue = false;
    // 弹出对话框并等待其关闭 等获取它的返回值
    bool? value = await showConfirmDialog(context,
        message: S.of(context).deleteTodoMessage, onChange: (value) {
      checkBoxValue = value!;
    });

    if (value != null) {
      removeItem(index);
      isNoTips = checkBoxValue;
    }
  }

  void handleCheckBoxChange(bool value, Map target, int index) async {
    final bool done = target['done'];
    // 先更新todo done自身状态, 在调用父级方法更新列表数据
    setState(() {
      myList[index]['done'] = value;
    });
    // 等待动画播放结束
    await Future.delayed(const Duration(milliseconds: 200));
    myList[index]['done'] = !value;
    widget.checkBoxChange(value, target, done, () {
      count = myList.length - 1;
      _getContainerHeight(null);
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
      if (target['newTopIndex'] != null) {
        oldIndex = target['newTopIndex'];
      } else {
        oldIndex = index;
      }
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
        } else {
          //如果当前指定的元素为最后一个,则返回最后一个置顶下标, 否则置顶下标 + 1
          newIndex =
              resultIndex == myList.length - 1 ? resultIndex : resultIndex + 1;
          oldIndex = target['oldIndex'] ?? index;
        }
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

  _getContainerHeight(_) {
    count ??= myList.length;
    setState(() {
      double height = (averageHeight * count!) + padding * 2;
      // 补充margin 高度
      if (count != 1) {
        height += marin * (count! - 1);
      }
      currentHeight = widget.isSpread ? height : 0;
    });
  }

  Color getTodoTextColor(bool done) {
    Color color = context.read<CurrentTheme>().isNightMode
        ? done
            ? Colors.grey
            : Colors.white
        : done
            ? Colors.grey
            : Colors.black;
    return color;
  }

  Color getTodoBackgroundColor(bool isTop) {
    Color backgroundColor = context.read<CurrentTheme>().isNightMode
        ? isTop
            ? Colors.black45
            : Colors.black12
        : isTop
            ? Colors.grey.shade200
            : Colors.white;
    return backgroundColor;
  }

  @override
  void initState() {
    super.initState();
    myList = mapListAddAttr(widget.listData);
  }

  // 给列表数据添加新的状态值
  List mapListAddAttr(list) {
    return list.map((e) {
      e['isDrag'] = false; // 元素是否拖拽
      e['isShowBorder'] = false; // 是否显示边框, 在拖拽元素进入到当前元素时显示
      return e;
    }).toList();
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void didUpdateWidget(covariant TodoList oldWidget) {
    super.didUpdateWidget(oldWidget);
    myList = mapListAddAttr(widget.listData);
    _getContainerHeight(null);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    WidgetsBinding.instance?.addPostFrameCallback(_getContainerHeight);
  }

  Widget _buildItem(Animation<double> _animation, int index) {
    Map target = myList[index];
    final bool done = target['done'];
    bool isTop = target['isTop'];
    TextDecoration? decoration =
        done ? TextDecoration.lineThrough : TextDecoration.none;
    Color color = getTodoTextColor(done);
    Color backgroundColor = getTodoBackgroundColor(isTop);
    return SizeTransition(
      sizeFactor: _animation,
      child: DragTarget(
        builder: (BuildContext context, List<int?> candidateData,
            List<dynamic> rejectedData) {
          return Container(
            decoration: BoxDecoration(
              border: Border.all(
                  color: myList[index]['isShowBorder']
                      ? themeColor
                      : Colors.transparent,
                  width: 1,
                  style: BorderStyle.solid),
              borderRadius: BorderRadius.circular(5), // 设置四周圆角
            ),
            child: TodoItem(
              color: color,
              data: target,
              index: index,
              handleCheckBoxChange: handleCheckBoxChange,
              decoration: decoration,
              backgroundColor: backgroundColor,
            ),
          );
        },
        onAccept: (int? newIndex) {
          if (newIndex != null && newIndex < myList.length) {
            var newTarget = myList[newIndex];
            var oldTarget = myList[index];
            // 限定只能在相同done类型的todo 进行拖拽交换
            if (newTarget['done'] == oldTarget['done']) {
              widget.swapTodo(newTarget, oldTarget);
            }
          }
        },
        onWillAccept: (int? newIndex) {
          // 防止数组越界 error
          if (newIndex != null &&
              newIndex < myList.length &&
              newIndex != index) {
            setState(() {
              myList[index]['isShowBorder'] = true;
            });
          }
          return true;
        },
        onLeave: (int? newIndex) {
          if (newIndex != null &&
              newIndex < myList.length &&
              newIndex != index) {
            setState(() {
              myList[index]['isShowBorder'] = false;
            });
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCirc,
      padding: EdgeInsets.all(padding),
      height: currentHeight,
      child: SlidableAutoCloseBehavior(
          child: AnimatedList(
        shrinkWrap: true,
        key: _listkey,
        physics: const NeverScrollableScrollPhysics(),
        // 去掉回弹效果 避免滑动冲突
        initialItemCount: widget.listData.length,
        itemBuilder:
            (BuildContext context, int index, Animation<double> animation) {
          Map target = myList[index];
          bool isTop = target['isTop'];
          bool done = target['done'];
          TextDecoration? decoration =
              done ? TextDecoration.lineThrough : TextDecoration.none;
          Color color = getTodoTextColor(target['done']);
          Color backgroundColor = getTodoBackgroundColor(isTop);
          return Container(
            margin: EdgeInsets.only(top: index == 0 ? 0 : marin),
            child: Slidable(
              groupTag: '0',
              child: LongPressDraggable(
                  child: Opacity(
                    opacity: myList[index]['isDrag'] ? 0 : 1,
                    child: _buildItem(animation, index),
                  ),
                  delay: const Duration(milliseconds: 350),
                  onDragStarted: () {
                    setState(() => myList[index]['isDrag'] = true);
                  },
                  onDragEnd: (details) {
                    setState(() => myList[index]['isDrag'] = false);
                  },
                  data: index,
                  feedback: Material(
                    elevation: 0.3,
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width - (padding * 2),
                      height: averageHeight,
                      child: TodoItem(
                        color: color,
                        data: target,
                        index: index,
                        decoration: decoration,
                        backgroundColor: backgroundColor,
                      ),
                    ),
                  )),
              endActionPane: ActionPane(
                motion: const DrawerMotion(),
                extentRatio: isTop ? 0.6 : 0.5,
                children: [
                  SlidableAction(
                    flex: isTop ? 2 : 1,
                    spacing: 1,
                    onPressed: (BuildContext context) =>
                        handleTopping(index, target),
                    backgroundColor: themeColor,
                    foregroundColor: Colors.white,
                    label: isTop
                        ? S.of(context).cancelTopping
                        : S.of(context).topping,
                  ),
                  SlidableAction(
                    spacing: 1,
                    // An action can be bigger than the others.
                    flex: 1,
                    onPressed: (BuildContext context) =>
                        handleRemoveItem(index),
                    backgroundColor: const Color.fromRGBO(255, 88, 103, 1),
                    foregroundColor: Colors.white,
                    label: S.of(context).delete,
                  ),
                ],
              ),
            ),
          );
        },
      )),
    );
  }
}

// 当前正在拖拽的todo项widget
class TodoItem extends StatelessWidget {
  final Map data;
  final int index;
  final Function? handleCheckBoxChange;
  final TextDecoration decoration;
  final Color color;
  final Color backgroundColor;

  const TodoItem(
      {Key? key,
      required this.data,
      required this.index,
      this.handleCheckBoxChange,
      required this.decoration,
      required this.color,
      required this.backgroundColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Neumorphic(
      style: NeumorphicStyle(
          depth: 0, color: backgroundColor, shape: NeumorphicShape.convex),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Checkbox(
            value: data['done'],
            shape: const CircleBorder(),
            activeColor: themeColor,
            onChanged: handleCheckBoxChange != null
                ? (value) => handleCheckBoxChange!(value, data, index)
                : null),
        Expanded(
            child: Text(
          data['value'],
          style: TextStyle(
              decoration: decoration,
              color: color,
              overflow: TextOverflow.ellipsis),
        )),
        Padding(
          padding: EdgeInsets.only(right: ScreenUtil().setWidth(10)),
          child: Text(
            data['time'],
            textAlign: TextAlign.right,
            style: TextStyle(decoration: decoration, color: color),
          ),
        ),
      ]),
    );
  }
}
