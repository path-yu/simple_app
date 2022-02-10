import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:zefyr/zefyr.dart';

class NoteEditorPage extends StatefulWidget {
  const NoteEditorPage({Key? key}) : super(key: key);

  @override
  _NoteEditorPageState createState() => _NoteEditorPageState();
}

class _NoteEditorPageState extends State<NoteEditorPage>
    with WidgetsBindingObserver {
  /// Allows to control the editor and the document.
  final ZefyrController _ZefyrController = ZefyrController();

  /// Zefyr editor like any other input field requires a focus node.
  final FocusNode _focusNode = FocusNode();

  //定义一个controller
  final TextEditingController _TitleController = TextEditingController();

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

  void _saveDocument() {}

  @override
  void initState() {
    super.initState();

    /// 初始化
    WidgetsBinding.instance?.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      bool ?_visible;
      // 键盘收回
      if (MediaQuery.of(context).viewInsets.bottom == 0) {
        _visible = false;
      } else {// 键盘弹出
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
          title: Text(appbarTitle!),
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
        future: null,
        builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
          return isLoading
              ? const Loading()
              : Column(
                  children: [
                    TextField(
                        controller: _TitleController,
                        decoration: InputDecoration(
                            hintText: '标题',
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
                      controller: _ZefyrController,
                      focusNode: _focusNode,
                    )),
                    Visibility(
                      visible: visible,
                      child: ZefyrToolbar.basic(controller: _ZefyrController),
                    )
                  ],
                );
        },
      ),
    );
  }
}
