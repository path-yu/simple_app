import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/data/index.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/model/note.dart';
import 'package:simple_app/utils/show_toast.dart';
import 'package:zefyr/zefyr.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({Key? key}) : super(key: key);

  @override
  _NoteEditorPageState createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage>
    with WidgetsBindingObserver {
  /// Allows to control the editor and the document.
   ZefyrController? _zefyrController;

  /// Zefyr editor like any other input field requires a focus node.
  final FocusNode _focusNode = FocusNode();

  //定义一个controller
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

  void _deleteDocument() {}

  // 将json 转为 delta
  Delta getDelta(doc) {
    return Delta.fromJson(json.decode(doc) as List);
  }

  // 监听标题编辑 事件
  void titleChange(String value) {
    title = value;
  }

  @override
  void initState() {
    super.initState();
    /// 初始化
    WidgetsBinding.instance?.addObserver(this);
    //监听输入变化
    _titleController.addListener(() => titleChange(_titleController.text));
    // 自动聚焦
    // _focusNode.
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

  _saveDocument() async {
    // 读取便签内容
    final contents = jsonEncode(_zefyrController?.document);
    // contents 默认为[{"insert":"\n"}] 长度17的字符串
    if (title!.isEmpty || contents.length == 17 ) {
      return showToast(S.of(context).titleAndNoteNotNullMessage);
    }
    // 如果isEditor 则 更新数据 否者写入数据
    if (isEditor) {
      // 写入文本内容
      Note note = Note(title: title, content: contents, id: id, time: time!);
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
          title: title,
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
   Future<dynamic> _loadData() async {
    // 加载写入的文本内容
    final document = await _loadDocument(isEditor: isEditor);
    _zefyrController =  ZefyrController(document);
    setState(() {
      isLoading = false;
    });
    return true;
  }
  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
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
      appBar: AppBar(
          title: Text(
            appbarTitle!,
            style: TextStyle(fontSize: ScreenUtil().setSp(18)),
          ),
          toolbarHeight: ScreenUtil().setSp(55),
          actions: [
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
