import 'dart:convert';

import 'package:date_format/date_format.dart' hide S;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_app/common/Color.dart';
import 'package:simple_app/common/Global.dart';
import 'package:simple_app/components/base/buildBaseAppBar.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/components/todoList/todoList.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/utils/index.dart';

import '../utils/showToast.dart';

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

  @override
  void initState() {
    super.initState();
    init();
    //监听输入变化
    _todoController.addListener(() {
      filedOnChange(_todoController.text);
    });
  }

  // 监听输入值值变化
  void filedOnChange(String value) {
    _inputValue = value;
  }

  void init() async {
    var data = await getLocalStorageData(ConstantKey.todoListKey);
    await Future.delayed(const Duration(microseconds: 300));
    setState(() {
      loading = false;
    });
    if (!data.isEmpty) {
      changeState(data: data);
    } else {
      changeState(data: []);
    }
  }

  void changeState({bool removeInputVal = false, required List data}) {
    setState(() {
      todoAllList = data;
    });
    if (removeInputVal) {
      // 清空输入框文本
      _todoController.text = "";
    }
  }

  // 监听键盘点击了确认按钮
  void addConfrim(String value) {
    if (value.isEmpty) {
      showToast('不能为空');
    } else {
      // 向通知栏添加一个消息
      // showNotification('您添加了一条新todo, 请尽快完成哦');
      addTodoLitItem();
    }
  }

  void addTodoLitItem() {
    DateTime now = DateTime.now();
    // 储存当前时间并格式化
    var currentTime = formatDate(
        DateTime(now.year, now.month, now.day), [yyyy, '/', mm, '/', dd]);
    todoAllList.add({"value": _inputValue, "done": false, 'time': currentTime});
    // localStorage.setString('todoList', json.encode(todoAllList));
    _prefs.then((pres) {
      pres.setString(ConstantKey.todoListKey, json.encode(todoAllList));
    });
    changeState(removeInputVal: true, data: todoAllList);
    _underWayTodoListKey.currentState?.addItem();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(S.of(context).toolKit),
      resizeToAvoidBottomInset: false, //输入框抵住键盘 内容不随键盘滚动
      body: loading
          ? const Loading()
          : Container(
              color: appBackgroundColor,
              height: double.infinity,
              child: Column(
                children: [
                  Container(
                    color: const Color(0xffEDEDED),
                    padding: EdgeInsets.all(ScreenUtil().setSp(10)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                            child: Center(
                                child: SearchBar(
                          _todoController,
                          addConfrim,
                          TextInputAction.go,
                          S.of(context).addTodo,
                          prefixIcon: const Icon(Icons.add),
                        )))
                      ],
                    ),
                  ),
                  TodoList(
                    key: _underWayTodoListKey,
                    listData: underwayList,
                    title: '正在进行',
                    checkBoxChange: () {},
                    deleteToDoListItem: () {},
                  ),
                  TodoList(
                    key: _completeToDoListKey,
                    listData: completeToDoList,
                    title: '已经完成',
                    checkBoxChange: () {},
                    deleteToDoListItem: () {},
                  )
                ],
              ),
            ),
    );
  }
}
