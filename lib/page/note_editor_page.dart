import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/data/index.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/model/note.dart';
import 'package:simple_app/utils/show_dialog.dart';
import 'package:simple_app/utils/show_toast.dart';
import 'package:zefyr/zefyr.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({Key? key}) : super(key: key);

  @override
  _NoteEditorPageState createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage>
    with WidgetsBindingObserver {
  /// 允许控制编辑器和文档。
  ZefyrController? _zefyrController;

  // Zefyr editor和其他任何输入字段一样，需要焦点节点。
  final FocusNode _focusNode = FocusNode();

  //定义一个标题输入controller
  final TextEditingController _titleController = TextEditingController();

  //导航栏标题文字
  String? appbarTitle;

  //标题
  String? title = "";

  //编辑还是新建
  bool isEditor = false;

  // 便签id
  int? id;

  //数据是否正在加载中
  bool isLoading = false;

  // 是否需要更新数据
  bool isNeedUpdate = false;

  //便签创建事件
  int? time;

  // 是否显示工具栏
  bool visible = false;

  initData() async {
    // 获取路由参数
    Map args = ModalRoute.of(context)?.settings.arguments as Map;
    if (args['isEditor']) {
      isEditor = true;
      appbarTitle = args['appbarTitle'];
      id = args['id'];
      time = args['time'];
    } else {
      appbarTitle = args['appbarTitle'];
      isEditor = false;
    }
  }

  // 将json 转为 delta
  Delta getDelta(doc) {
    return Delta.fromJson(json.decode(doc) as List);
  }

  // 监听标题编辑 事件
  void titleChange(String value) {
    title = value;
  }

  //  读取便签内容
  Future<NotusDocument> _loadDocument({required bool isEditor}) async {
    //如果为编辑 则从数据库取出对应的数据
    if (isEditor) {
      List<Note> res = await DBProvider().findNoteListData(id!);
      _titleController.text = res[0].title!;
      titleChange(_titleController.text);
      Delta deltaData = getDelta(res[0].content);
      return NotusDocument.fromDelta(deltaData);
    } else {
      // 返回默认值
      final delta = Delta()..insert('\n');
      return NotusDocument.fromDelta(delta);
    }
  }

  // 保存便签
  _saveDocument() async {
    // 读取便签内容
    final contents = jsonEncode(_zefyrController?.document);
    // contents 默认为[{"insert":"\n"}] 长度17的字符串
    if (contents.length == 17) {
      return showToast(S.of(context).NoteNotNullMessage);
    }
    // 如果isEditor 则 更新数据 否者写入数据
    if (isEditor) {
      // 写入文本内容
      Note note = Note(title: title!, content: contents, id: id, time: time!);
      int res = await DBProvider().update(note);
      if (res > 0) {
        isNeedUpdate = true;
        showToast(S.of(context).updateSuccess);
      } else {
        showToast(S.of(context).updateFail);
      }
    } else {
      // 写入文本内容
      Note note = Note(
          title: title!,
          content: contents,
          time: DateTime.now().microsecondsSinceEpoch);
      int res = await DBProvider().saveData(note);
      if (res > 0) {
        isNeedUpdate = true;
        showToast(S.of(context).saveSuccess);
      } else {
        showToast(S.of(context).saveFail);
      }
    }
  }

  //删除便签
  void _deleteDocument() async {
    isNeedUpdate = true;
    // 弹出对话框判断用户是否真的需要删除
    var res = await showConfirmDialog(context,
        message: S.of(context).deleteTodoMessage);
    if (res != null) {
      int res = await DBProvider().deleteData(id!);
      if (res > 0) {
        showToast(S.of(context).deleteSuccess);
        // 跳转到上一个页面
        Navigator.pop(context, true);
      } else {
        showToast(S.of(context).deleteFail);
      }
    }
  }

  // 加载需要编辑写入的文本内容
  _loadData() async {
    final document = await _loadDocument(isEditor: isEditor);
    if (_zefyrController == null) {
      setState(() {
        _zefyrController = ZefyrController(document);
        // 更新光标光标位置到最后
        _zefyrController?.updateSelection(TextSelection.fromPosition(
            TextPosition(
                affinity: TextAffinity.downstream, offset: document.length)));
      });
    }
  }

  //应用尺寸改变时回调，例如旋转
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    // 添加渲染结束的回调，只会被调用一次
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      bool? _visible;
      // 键盘收回
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        _visible = false;
      } else {
        // 键盘弹出
        _visible = true;
      }
      setState(() => visible = _visible!);
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance?.removeObserver(this);
  }

  @override
  void initState() {
    super.initState();

    /// 监听页面生命周期 ,添加观察者
    WidgetsBinding.instance?.addObserver(this);
    //监听输入变化
    _titleController.addListener(() => titleChange(_titleController.text));
  }

  @override
  Widget build(BuildContext context) {
    initData();
    // 判断是否显示删除按钮
    final removeIcon = isEditor
        ? Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _deleteDocument,
                ))
        : const SizedBox(height: 0.0, width: 0.0);
    // 计算显示保存按钮还是更新按钮
    final saveOrUpdateIcon =
        isEditor ? Icons.update_rounded : Icons.save_rounded;
    return Scaffold(
      appBar: buildBaseAppBar(S.of(context).editorNote,
          action: [
            Builder(
              builder: (context) => IconButton(
                icon: Icon(saveOrUpdateIcon),
                onPressed: _saveDocument,
              ),
            ),
            removeIcon
          ],
          leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                // t跳转到上一个页面
                Navigator.pop(context, isNeedUpdate);
              })),
      body: FutureBuilder(
        future: _loadData(),
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return _zefyrController == null
              ? const Loading()
              : Column(
                  children: [
                    TextField(
                        controller: _titleController,
                        decoration: InputDecoration(
                            hintText: S.of(context).title,
                            border: InputBorder.none,
                            hintStyle: const TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.grey),
                            contentPadding:
                                EdgeInsets.all(ScreenUtil().setSp(16)))),
                    Expanded(
                        child: ZefyrEditor(
                      padding: EdgeInsets.fromLTRB(ScreenUtil().setSp(16), 0,
                          ScreenUtil().setSp(16), ScreenUtil().setSp(16)),
                      controller: _zefyrController!,
                      focusNode: _focusNode,
                      autofocus: true,
                    )),
                    Visibility(
                      visible: visible,
                      child: ZefyrToolbar.basic(controller: _zefyrController!),
                    )
                  ],
                );
        },
      ),
    );
  }
}
