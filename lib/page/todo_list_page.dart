import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/common/Color.dart';
import 'package:simple_app/components/base/buildBaseAppBar.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/generated/l10n.dart';

import '../utils/showDialog.dart';
import '../utils/showToast.dart';

class TodoListPage extends StatefulWidget {
  const TodoListPage({Key? key}) : super(key: key);

  @override
  State<TodoListPage> createState() => _TodoListPageState();
}

class _TodoListPageState extends State<TodoListPage> {
  //定义一个controller
  final TextEditingController _todoController = TextEditingController();

  // 监听键盘点击了确认按钮
  void addConfrim(String value) {
    showConfirmDialog(context);
    if (value.isEmpty) {
      showToast('不能为空');
    } else {
      // 向通知栏添加一个消息
      // showNotification('您添加了一条新todo, 请尽快完成哦');
      // addTodoLitItem();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(S.of(context).toolKit),
      resizeToAvoidBottomInset: false, //输入框抵住键盘 内容不随键盘滚动
      body: Container(
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
          ],
        ),
      ),
    );
  }
}
