import 'dart:convert';

import 'package:date_format/date_format.dart' hide S;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_sticky_header/flutter_sticky_header.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/common/global.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/components/base/hide_key_bord.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/components/todoList/build_todo_list_title.dart';
import 'package:simple_app/components/todoList/todo_list.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/Notification.dart';
import 'package:simple_app/utils/index.dart';
import 'package:simple_app/utils/show_toast.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //定义一个controller
  final TextEditingController _todoController = TextEditingController();

  final Future<SharedPreferences> _prefs = SharedPreferences.getInstance();

  final GlobalKey<TodoListState> _underWayTodoListKey =
      GlobalKey<TodoListState>();
  final GlobalKey<TodoListState> _completeToDoListKey =
      GlobalKey<TodoListState>();
  final GlobalKey<SearchBarState> _searchBarKey = GlobalKey<SearchBarState>();

  // 输入框输入值
  String _inputValue = "";

  //全部的任务列表
  List todoAllList = [];

  // 正在进行的任务列表
  List get underwayList => filterListData(todoAllList, false);

  // 已经完成的任务列表
  List get completeToDoList => filterListData(todoAllList, true);

  // 是否正在加载数据
  bool loading = true;

  // 是否展开正在进行的todo
  bool underwayListIsSpread = true;

  bool completeIsSpread = true;

  @override
  void initState() {
    super.initState();
    init();
    //监听输入变化
    _todoController.addListener(filedOnChange);
  }

  @override
  void dispose() {
    super.dispose();
    _todoController.removeListener(filedOnChange);
  }

  // 监听输入值值变化
  void filedOnChange() {
    _inputValue = _todoController.text;
  }

  void init() async {
    var data = await getLocalStorageData(ConstantKey.todoListKey);
    setState(() {
      loading = false;
    });
    if (!data.isEmpty) {
      changeState(data: data);
    } else {
      changeState(data: []);
    }
  }

  void changeState({bool removeInputVal = false, List? data}) {
    setState(() {
      setStorageData();
      data ??= todoAllList;
      todoAllList = data!;
    });
    if (removeInputVal) {
      // 清空输入框文本
      _todoController.text = "";
    }
  }

  // 监听键盘点击了确认按钮
  void addConfirm(String value) {
    if (value.isEmpty) {
      showToast(S.of(context).notEmpty);
    } else {
      // 向通知栏添加一个消息
      showNotification(
          message: S.of(context).addTodoMessage, payload: '/todo_list_page');
      addTodoLitItem();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Row(
          children: <Widget>[
            const Icon(
              Icons.check,
              color: themeColor,
            ),
            Text(S.of(context).addTodoMessage)
          ],
        ),
        duration: const Duration(seconds: 2),
      ));
    }
  }

  // 添加todo
  void addTodoLitItem() {
    DateTime now = DateTime.now();
    // 储存当前时间并格式化
    var currentTime = formatDate(
        DateTime(now.year, now.month, now.day), [yyyy, '/', mm, '/', dd]);
    todoAllList.add({
      "value": _inputValue,
      "id": DateTime.now().millisecondsSinceEpoch,
      "done": false,
      'time': currentTime,
      "isTop": false, //是否置顶
      "oldTopIndex": null, // 置顶前的位置
      "newTopIndex": null, // 置顶后的位置
    });
    changeState(removeInputVal: true, data: todoAllList);
    _underWayTodoListKey.currentState?.addItem();
    setState(() => underwayListIsSpread = true);
  }

  // 删除todo
  void deleteToDoListItem(target) {
    todoAllList.remove(target);
    changeState();
  }

  void setStorageData() {
    _prefs.then((pres) {
      pres.setString(ConstantKey.todoListKey, json.encode(todoAllList));
    });
  }

  // 点击切换 todo状态触发
  void checkBoxChange(
      bool value, Map target, bool done, Function? doneSuccess) async {
    int index = todoAllList.indexOf(target);
    // 如果是done false 说明当前点击的是正在进行的todo项, 则将其删除,并将其添加到已经完成中 反之类似
    if (done == false) {
      int removeIndex =
          underwayList.indexWhere((val) => val['id'] == target['id']);
      _underWayTodoListKey.currentState!.animatedRemoveItem(removeIndex);
      await Future.delayed(const Duration(milliseconds: 350), () {
        _completeToDoListKey.currentState?.addItem();
        doneSuccess!();
        // 展开已经完成的todo
        setState(() => completeIsSpread = true);
      });
    } else {
      int removeIndex =
          completeToDoList.indexWhere((val) => val['id'] == target['id']);
      _completeToDoListKey.currentState?.animatedRemoveItem(removeIndex);
      await Future.delayed(const Duration(milliseconds: 350), () {
        _underWayTodoListKey.currentState?.addItem();
        doneSuccess!();
        // 展开正在进行的todo
        setState(() => underwayListIsSpread = true);
      });
    }
    todoAllList[index]['done'] = value;
    updateTodoIndex(index, done);
    // 如果underwayList 为空则 任务全部完成, 则向通知栏添加一条消息
    if (underwayList.isEmpty) {
      showNotification(
          message: S.of(context).todoCompleteMessage,
          payload: '/todo_list_page');
    }
  }

  //点击checkBox 更新todo项,对应的oldTopIndex和 newTopIndex
  void updateTodoIndex(int index, bool done) {
    if (done == false) {
      // 如果长度为0 则 设置下标为0
      todoAllList[index]['newTopIndex'] = completeToDoList.isEmpty ? 0 : null;
      todoAllList[index]['oldTopIndex'] = null;
      todoAllList[index]['isTop'] = false;
    } else {
      todoAllList[index]['newTopIndex'] = underwayList.isEmpty ? 0 : null;
      todoAllList[index]['oldTopIndex'] = null;
      todoAllList[index]['isTop'] = false;
    }
  }

  // 更新置顶状态
  void updateTodoTopping(Map oldTarget, Map newTarget, bool isTopping,
      {required int newTopIndex, required int oldTopIndex}) {
    int oldIndex =
        todoAllList.indexWhere((element) => element['id'] == oldTarget['id']);

    int newIndex =
        todoAllList.indexWhere((element) => element['id'] == newTarget['id']);

    // 如果为第一项 则只更新置顶状态
    if (oldTopIndex == 0 && newTopIndex == 0) {
      // 判断是否为正在进行的todo项
      if (oldTarget['done'] == true) {
        todoAllList[oldIndex]['isTop'] = isTopping;
      } else {
        todoAllList[0]['isTop'] = isTopping;
      }
    } else {
      if (isTopping) {
        todoAllList[oldIndex]['oldTopIndex'] = oldTopIndex;
        todoAllList[oldIndex]['newTopIndex'] = newTopIndex;
        todoAllList[oldIndex]['isTop'] = isTopping;
      } else {
        // 取消置顶则,重置状态
        todoAllList[oldIndex]['oldTopIndex'] = null;
        todoAllList[oldIndex]['newTopIndex'] = null;
        todoAllList[oldIndex]['isTop'] = false;
      }
      var temp = todoAllList[oldIndex];
      todoAllList[oldIndex] = todoAllList[newIndex];
      todoAllList[newIndex] = temp;
    }
    changeState();
  }

  void updateUnderwaySpread() {
    setState(() => underwayListIsSpread = !underwayListIsSpread);
  }

  void updateCompleteSpread() {
    setState(() => completeIsSpread = !completeIsSpread);
  }

  // 拖拽切换调用
  void swapTodo(oldTarget, newTarget) {
    int oldIndex =
        todoAllList.indexWhere((element) => element['id'] == oldTarget['id']);

    int newIndex =
        todoAllList.indexWhere((element) => element['id'] == newTarget['id']);
    // 重置状态
    todoAllList[oldIndex]['isTop'] = false;
    todoAllList[oldIndex]['newTopIndex'] = null;
    todoAllList[oldIndex]['newTopIndex'] = null;
    todoAllList[newIndex]['isTop'] = false;
    todoAllList[newIndex]['newTopIndex'] = null;
    todoAllList[newIndex]['newTopIndex'] = null;
    // 交换下标
    var temp = todoAllList[oldIndex];
    todoAllList[oldIndex] = todoAllList[newIndex];
    todoAllList[newIndex] = temp;
    changeState();
  }

  @override
  Widget build(BuildContext context) {
    Color stickyTopColor = context.watch<CurrentTheme>().isNightMode
        ? const Color.fromRGBO(45, 45, 45, 1)
        : const Color.fromRGBO(144, 201, 172, 0.7);
    return HideKeyboard(
        child: Scaffold(
            appBar: buildBaseAppBar(title: S.of(context).todoList),
            resizeToAvoidBottomInset: false, //输入框抵住键盘 内容不随键盘滚动
            body: loading
                ? const Loading()
                : Scrollbar(
                    radius: const Radius.circular(30),
                    child: CustomScrollView(
                      shrinkWrap: false,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      slivers: [
                        SliverStickyHeader(
                          header: const SizedBox(
                            height: 0,
                          ),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => Container(
                                // color: stickyTopColor,
                                padding: EdgeInsets.all(ScreenUtil().setSp(20)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                        child: Center(
                                            child: SearchBar(
                                      _todoController,
                                      addConfirm,
                                      TextInputAction.done,
                                      S.of(context).addTodo,
                                      key: _searchBarKey,
                                      prefixIcon: Icon(
                                        Icons.add,
                                        color: themeColor,
                                        size: ScreenUtil().setSp(20),
                                      ),
                                    )))
                                  ],
                                ),
                              ),
                              childCount: 1,
                            ),
                          ),
                        ),
                        SliverStickyHeader(
                          header: buildTodoListTitle(
                              S.of(context).underway, underwayList.length,
                              isSpread: underwayListIsSpread,
                              onTap: updateUnderwaySpread,
                              backgroundColor: stickyTopColor),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => TodoList(
                                key: _underWayTodoListKey,
                                listData: underwayList,
                                checkBoxChange: checkBoxChange,
                                deleteToDoListItem: deleteToDoListItem,
                                searchBarKey: _searchBarKey,
                                updateTodoTopping: updateTodoTopping,
                                isSpread: underwayListIsSpread,
                                updateSpread: updateCompleteSpread,
                                swapTodo: swapTodo,
                              ),
                              childCount: 1,
                            ),
                          ),
                        ),
                        SliverStickyHeader(
                          header: buildTodoListTitle(
                              S.of(context).complete, completeToDoList.length,
                              isSpread: completeIsSpread,
                              onTap: updateCompleteSpread,
                              backgroundColor: stickyTopColor),
                          sliver: SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, i) => TodoList(
                                key: _completeToDoListKey,
                                listData: completeToDoList,
                                checkBoxChange: checkBoxChange,
                                deleteToDoListItem: deleteToDoListItem,
                                searchBarKey: _searchBarKey,
                                updateTodoTopping: updateTodoTopping,
                                isSpread: completeIsSpread,
                                updateSpread: updateCompleteSpread,
                                swapTodo: swapTodo,
                              ),
                              childCount: 1,
                            ),
                          ),
                        ),
                      ],
                    ),
                  )));
  }
}
