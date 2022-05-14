import 'dart:convert';

import 'package:date_format/date_format.dart' hide S;
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:quill_delta/quill_delta.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/data/index.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/model/note.dart';
import 'package:simple_app/provider/current_locale.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/show_dialog.dart';
import 'package:simple_app/utils/show_toast.dart';
import 'package:zefyr/zefyr.dart';

class NoteEditorPage extends StatefulWidget {
  //编辑还是新建
  final bool isEditor;

  // 便签id
  final int? id;

  //便签创建时间
  final int? time;

  const NoteEditorPage({Key? key, this.id, this.time, this.isEditor = false})
      : super(key: key);

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

  //数据是否正在加载中
  bool isLoading = false;

  // 是否需要更新数据
  bool isNeedUpdate = false;

  // 是否显示工具栏
  bool visible = false;

  //是否保存?
  bool isSave = false;

  //更新时间
  int? updateTime;

  // 滚动控制器
  final ScrollController _scrollController = ScrollController();

  // 是否显示更新时间
  bool showDate = true;
  // 将json 转为 delta
  Delta getDelta(doc) {
    return Delta.fromJson(json.decode(doc) as List);
  }

  // 是否添加拦截导航返回操作回调
  bool isAddWillPopScopeCallback = false;

  // 记录上一次当前的编辑内容
  String? rawNoteDeltaData;
  // 记录标题
  String? rawTitle;

  bool hide = false;
  //  读取便签内容
  Future<NotusDocument> _loadDocument({required bool isEditor}) async {
    //如果为编辑 则从数据库取出对应的数据
    if (isEditor) {
      List<Note> res = await DBProvider().findNoteListData(widget.id!);
      _titleController.text = res[0].title!;
      Delta deltaData = getDelta(res[0].content);
      rawNoteDeltaData = jsonEncode(deltaData);
      updateTime = res[0].updateTime;
      rawTitle = res[0].title!;
      return NotusDocument.fromDelta(deltaData);
    } else {
      // 返回默认值
      final delta = Delta()..insert('\n');
      rawTitle = '';
      rawNoteDeltaData = jsonEncode(delta);
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
    int now = DateTime.now().millisecondsSinceEpoch;
    // 如果isEditor 则 更新数据 否者写入数据
    if (widget.isEditor) {
      // 更新
      Note note = Note(
          title: _titleController.text,
          content: contents,
          id: widget.id,
          updateTime: now,
          time: widget.time!);
      int res = await DBProvider().update(note);
      if (res > 0) {
        isNeedUpdate = true;
        showToast(S.of(context).updateSuccess);
      } else {
        showToast(S.of(context).updateFail);
      }
    } else {
      // 保存文本内容
      Note note = Note(
          title: _titleController.text,
          content: contents,
          updateTime: now,
          time: now);

      int res = await DBProvider().saveData(note);
      if (res > 0) {
        isNeedUpdate = true;
        showToast(S.of(context).saveSuccess);
      } else {
        showToast(S.of(context).saveFail);
      }
    }
    // 更新保存状态
    rawNoteDeltaData = contents;
    rawTitle = _titleController.text;
    isSave = true;
  }

  //删除便签
  void _deleteDocument() async {
    isNeedUpdate = true;
    // 弹出对话框判断用户是否真的需要删除
    var res = await showConfirmDialog(context,
        message: S.of(context).deleteTodoMessage,showTips: false);
    if (res != null) {
      int res = await DBProvider().deleteData(widget.id!);
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
    if (_zefyrController == null) {
      final document = await _loadDocument(isEditor: widget.isEditor);
      setState(() => {_zefyrController = ZefyrController(document)});
      // 更新光标光标位置到最后
      _zefyrController?.updateSelection(TextSelection.fromPosition(TextPosition(
          affinity: TextAffinity.downstream, offset: document.length)));
      // 监听编辑器
      _zefyrController?.addListener(_listenerZefyrChang);
      //监听输入变化
      _titleController.addListener(_listenerTitleChange);
    }
  }

  // 监听内容输入变化
  void _listenerZefyrChang() {
    // 读取便签内容
    final contents = jsonEncode(_zefyrController?.document);
    if (contents != rawNoteDeltaData) {
      setState(() => isAddWillPopScopeCallback = true);
      isSave = false;
    } else {
      setState(() => isAddWillPopScopeCallback = false);
    }
  }

  void _listenerTitleChange() {
    // 读取便签内容
    final value = _titleController.text;
    if (value != rawTitle) {
      setState(() => isAddWillPopScopeCallback = true);
      isSave = false;
    } else {
      setState(() => isAddWillPopScopeCallback = false);
    }
  }

  // 监听滚动 上拉隐藏时间显示, 下拉显示
  void _listenScroll() {
    if (_scrollController.offset < -30) {
      if (hide != false) {
        setState(() {
          hide = false;
        });
      }
    }
    if (_scrollController.offset > 30) {
      if (hide != true) {
        setState(() {
          hide = true;
        });
      }
    }
  }

  // 路由返回拦截用回调
  Future<bool> handleWillPop() async {
    if (isSave) {
      return true;
    }
    if (await showConfirmDialog(context,
            message: S.of(context).tipSaveMessage,showTips: false) !=
        null) {
      await _saveDocument();
      // 返回下一页, 更新数据
      Navigator.pop(context, isNeedUpdate);
    }
    return true;
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
    _zefyrController?.removeListener(_listenerZefyrChang);
    _titleController.removeListener(_listenerTitleChange);
    _scrollController.removeListener(_listenScroll);
  }

  @override
  void initState() {
    super.initState();

    /// 监听页面生命周期 ,添加观察者
    WidgetsBinding.instance?.addObserver(this);
    // 滚动监听
    _scrollController.addListener(_listenScroll);
  }

  // 根据不同的时间段格式化处理时间
  String formateTime(DateTime time) {
    String hourStr = time.hour.toString();
    int hour = time.hour;
    String minute = time.minute < 10
        ? '0' + time.minute.toString()
        : time.minute.toString();
    String timeSlot = '';
    if (hour >= 1 && hour <= 5) {
      timeSlot = S.of(context).beforeDawn; // 凌晨
    } else if (hour >= 5 && hour <= 8) {
      timeSlot = S.of(context).morning; // 早上
    } else if (hour >= 8 && hour <= 11) {
      timeSlot = S.of(context).forenoon; // 上午
    } else if (hour >= 11 && hour <= 13) {
      timeSlot = S.of(context).noon; // 中午
    } else if (hour >= 13 && hour <= 17) {
      timeSlot = S.of(context).afternoon; //下午
    } else if (hour >= 17 && hour <= 19) {
      timeSlot = S.of(context).evening; //傍晚
    } else if (hour >= 19 && hour <= 23) {
      timeSlot = S.of(context).night; //晚上
    } else {
      timeSlot = S.of(context).lateNight; //深页
    }
    if (hour >= 13) {
      hourStr = (hour - 12).toString();
    }
    return timeSlot + ': ' + hourStr + ':' + minute;
  }

  TextStyle greyTextStyle = TextStyle(
      color: Colors.grey.shade500,
      fontSize: ScreenUtil().setSp(14),
      textBaseline: TextBaseline.ideographic,
      height: 1.5);
  @override
  Widget build(BuildContext context) {
    var fontEndTime = '';
    var endTime = '';
    if (widget.time != null && updateTime != null) {
      var date = DateTime.fromMillisecondsSinceEpoch(updateTime!);
      fontEndTime = formatDate(
          date,
          context.watch<CurrentLocale>().languageIsEnglishMode
              ? [
                  yyyy,
                  '-',
                  mm,
                  '-',
                  dd,
                ]
              : [yyyy, '年', mm, '月', dd, '日']);
      endTime = formateTime(date);
    }
    // 判断是否显示删除按钮
    final removeIcon = widget.isEditor
        ? Builder(
            builder: (context) => IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: _deleteDocument,
                ))
        : const SizedBox(height: 0.0, width: 0.0);
    // 计算显示保存按钮还是更新按钮
    final saveOrUpdateIcon =
        widget.isEditor ? Icons.update_rounded : Icons.save_rounded;
    return WillPopScope(
        child: Scaffold(
          appBar: buildBaseAppBar(
            title: widget.isEditor
                ? S.of(context).editorNote
                : S.of(context).createNote,
            action: [
              Builder(
                builder: (context) => IconButton(
                  icon: Icon(saveOrUpdateIcon),
                  onPressed: _saveDocument,
                ),
              ),
              removeIcon
            ],
          ),
          body: FutureBuilder(
            future: _loadData(),
            builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
              return _zefyrController == null
                  ? const Loading()
                  : Padding(
                      padding: EdgeInsets.all(ScreenUtil().setHeight(10)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Transform.scale(
                            scale: 0.8,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                  depth: -5,
                                  boxShape: NeumorphicBoxShape.roundRect(
                                      BorderRadius.circular(50))),
                              child: TextField(
                                  controller: _titleController,
                                  style: TextStyle(
                                      color: context
                                          .read<CurrentTheme>()
                                          .darkOrWhiteColor,
                                      fontSize: ScreenUtil().setSp(14)),
                                  decoration: InputDecoration(
                                      hintText: S.of(context).title,
                                      border: InputBorder.none,
                                      hintStyle: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.grey),
                                      contentPadding: EdgeInsets.only(
                                          left: ScreenUtil().setWidth(16)))),
                            ),
                          ),
                          Visibility(
                              visible: widget.time != null,
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 300),
                                curve: Curves.decelerate,
                                height: hide ? 0 : ScreenUtil().setHeight(40),
                                padding:
                                    EdgeInsets.all(ScreenUtil().setHeight(10)),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(S.of(context).lastUpdateTime + ':',
                                        style: greyTextStyle),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(10),
                                    ),
                                    Text(fontEndTime, style: greyTextStyle),
                                    SizedBox(
                                      width: ScreenUtil().setWidth(8),
                                    ),
                                    Text(endTime, style: greyTextStyle)
                                  ],
                                ),
                              )),
                          Expanded(
                              child: ZefyrEditor(
                            scrollController: _scrollController,
                            scrollPhysics: const BouncingScrollPhysics(
                                parent: AlwaysScrollableScrollPhysics()),
                            padding: EdgeInsets.fromLTRB(
                                ScreenUtil().setSp(16),
                                0,
                                ScreenUtil().setSp(16),
                                ScreenUtil().setSp(16)),
                            controller: _zefyrController!,
                            focusNode: _focusNode,
                            autofocus: true,
                          )),
                          Visibility(
                            visible: visible,
                            child: IconTheme(
                                data: IconThemeData(
                                    color: context
                                        .read<CurrentTheme>()
                                        .darkOrWhiteColor),
                                child: ZefyrToolbar.basic(
                                    controller: _zefyrController!)),
                          )
                        ],
                      ),
                    );
            },
          ),
        ),
        onWillPop: isAddWillPopScopeCallback ? handleWillPop : null);
  }
}
