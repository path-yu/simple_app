import 'dart:convert';

import 'package:animated_flip_counter/animated_flip_counter.dart';
import 'package:date_format/date_format.dart' hide S;
import 'package:flutter/cupertino.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/base/base_animated_opacity.dart';
import 'package:simple_app/components/base/base_icon.dart';
import 'package:simple_app/components/base/base_text.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/components/base/draggable_floating_action_button.dart';
import 'package:simple_app/components/base/hide_key_bord.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/data/index.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:simple_app/model/note.dart';
import 'package:simple_app/page/note_editor_page.dart';
import 'package:simple_app/provider/current_locale.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/index.dart';
import 'package:simple_app/utils/show_toast.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //定义一个controller
  final TextEditingController _noteController = TextEditingController();

  // 所有的标签数据
  List<NewNote> noteList = [];

  // 数据是否正在加载
  bool isLoading = false;

  // 提示文字
  String? messageText;

  // 是否进行了长按
  bool isShowCheckBox = false;

  // 当前所有选择的下标
  List<int> selectIndexList = [];

  // 是否全选
  bool get isSelectAll => noteList.every((note) => note.isSelect == true);

  // 动画过渡
  final Duration _duration = const Duration(milliseconds: 350);

  // 动画控制器
  Animation<double>? animationController;

  //圆角
  BorderRadius borderRadius = BorderRadius.circular(ScreenUtil().setSp(20));
  final GlobalKey _parentKey = GlobalKey();

  @override
  void initState() {
    if (isSelectAll) {}
    super.initState();
    getData(DBProvider().findAll);
  }

  //从数据库中读取数据
  Future getData(Function action,
      [String title = "", bool isPullRefresh = false]) async {
    if (isPullRefresh == false) {
      setState(() {
        isLoading = true;
      });
    }
    List<Note> result;
    if (title.isNotEmpty) {
      result = await action(title);
      if (result.isEmpty) {
        setState(() {
          messageText = S.of(context).notSearchNoteMessage;
        });
      }
    } else {
      result = await action();
    }
    List<NewNote> list = [];
    for (var item in result) {
      list.add(NewNote(item.id!, item.title, item.content, item.time, false));
    }
    setState(() {
      noteList = list;
      isLoading = false;
    });
  }

  /// 下拉刷新,必须异步async不然会报错
  Future _pullRefresh() async {
    await getData(DBProvider().findAll, "", true);
    _noteController.text = "";
    if (noteList.isEmpty) {
      setState(() {
        messageText = S.of(context).notNoteMessage;
      });
    }
    return null;
  }

  // 开始搜索
  handleSearch(String value) async {
    if (value.isEmpty) {
      return showToast(S.of(context).placeSearchContent);
    } else {
      getData(DBProvider().findTitleNoteList, value);
      return null;
    }
  }

  // 返回便签内容数据
  String getNoteContent(target) {
    String content = json.decode(target.content)[0]['insert'];
    content = content.replaceAll('\n', '');
    return content;
  }

  // 跳转到新建便签 页面
  void toCreateOrEditorNotePage({int? id, int? time, int? index}) {
    // 如果开启了长按选择则不进行跳转
    if (isShowCheckBox) {
      // 判断是否选中
      NewNote target = noteList[index!];
      handleChangeCheckBox(!target.isSelect, index);
      return;
    }
    var params = {};
    if (id != null) {
      params = {'id': id, 'time': time, 'isEditor': true};
    } else {
      params = {'isEditor': false};
    }

    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: ((context) => NoteEditorPage(
                  id: params['id'],
                  time: params['time'] ??= null,
                  isEditor: params['isEditor'],
                )))).then((value) {
      if (!params['isEditor']) {
        getData(DBProvider().findAll);
      }
      // 然后返回了数据则更新页面
      if (value != null) {
        getData(DBProvider().findAll);
      }
    });
  }

  // 长按选择
  void handLongPress(int index, BuildContext context) {
    if (isShowCheckBox) return;
    setState(() {
      isShowCheckBox = true;
      noteList[index].isSelect = true;
      selectIndexList.add(noteList[index].id);
    });
    // 弹窗底部菜单
    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) {
        return Container(
          height: ScreenUtil().setHeight(60),
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  colors: context.read<CurrentTheme>().gradientColors)),
          child: Center(
            child: InkWell(
              onTap: handleDelete,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    baseIcon(Icons.delete, color: Colors.white),
                    Text(
                      S.of(context).delete,
                      style: const TextStyle(color: Colors.white),
                    )
                  ]),
            ),
          ),
        );
      },
    );
  }

  // 点击底部删除按钮
  handleDelete() async {
    if (selectIndexList.isEmpty) {
      return showToast(S.of(context).noSelectNoteMessage);
    }
    showBaseCupertinoModalPopup(context, () async {
      //删除数据
      int result = await DBProvider().deleteByIds(selectIndexList);
      if (result > 0) {
        showToast(S.of(context).deleteSuccess);
        setState(() {
          for (int id in selectIndexList) {
            noteList.removeWhere((item) => item.id == id);
          }
        });
      } else {
        showToast(S.of(context).deleteFail);
      }
      //关闭底部弹出
      setState(() => resetData());
      Navigator.pop(context);
    });
  }

  // 重置数据
  void resetData() {
    isShowCheckBox = false;
    selectIndexList.clear();
    for (NewNote note in noteList) {
      note.isSelect = false;
    }
  }

  // 更新checkbox
  void handleChangeCheckBox(bool value, int index) {
    setState(() {
      noteList[index].isSelect = value;
      if (value) {
        selectIndexList.add(noteList[index].id);
      } else {
        selectIndexList.remove(noteList[index].id);
      }
    });
  }

  // 点击菜单全选 or 取消 全选
  void handleSelectMenu() {
    // 判断是否全选
    bool isSelectAll = noteList.every((note) => note.isSelect == true);
    selectIndexList.clear();
    setState(() {
      for (NewNote note in noteList) {
        if (!isSelectAll) {
          note.isSelect = true;
          selectIndexList.add(note.id);
        } else {
          note.isSelect = false;
          selectIndexList.remove(note.id);
        }
      }
    });
  }

  // 拦截返回回调
  Future<bool> handleWillPop() async {
    if (isShowCheckBox) {
      setState(() => resetData());
      Navigator.pop(context);
      return false;
    }
    return true;
  }

  // 编辑 关闭按钮
  void handleClose() {
    setState(() => resetData());
    Navigator.pop(context);
  }

  Widget appBarWidget() {
    return isShowCheckBox
        ? Row(
            mainAxisAlignment: MainAxisAlignment.center,
            verticalDirection: VerticalDirection.up,
            children: [
                baseText(S.of(context).selected + ' ', fontSize: 18),
                AnimatedFlipCounter(
                  value: selectIndexList.length,
                  curve: Curves.bounceIn,
                  duration: const Duration(milliseconds: 250),
                  textStyle: TextStyle(
                      fontSize: ScreenUtil().setSp(18),
                      height: 1.5,
                      textBaseline: TextBaseline.alphabetic),
                ),
                // baseText(selectIndexList.length.toString() + ' ', fontSize: 20),
                baseText(' ' + S.of(context).item + ' ', fontSize: 18)
              ])
        : Text(
            S.of(context).note,
            style: TextStyle(fontSize: ScreenUtil().setSp(18)),
          );
  }

  Widget noteItemBuild(BuildContext context, int index) {
    NewNote target = noteList[index];
    var date = DateTime.fromMillisecondsSinceEpoch(target.time);
    String content = getNoteContent(target);
    final title = target.title!.isEmpty
        ? const SizedBox(
            height: 0,
          )
        : Text(
            '${target.title}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          );

    String currentTime = formatDate(
        date,
        context.watch<CurrentLocale>().languageIsEnglishMode
            ? [yyyy, '-', mm, '-', dd]
            : [yyyy, '年', mm, '月', dd, '日']);
    var padding = ScreenUtil().setSp(20);
    return Neumorphic(
      style: NeumorphicStyle(
          lightSource: LightSource.bottomRight,
          boxShape: NeumorphicBoxShape.roundRect(borderRadius),
          depth: 2,
          shape: NeumorphicShape.concave),
      child: InkWell(
        onTap: () => toCreateOrEditorNotePage(
            id: target.id, time: target.time, index: index),
        onLongPress: () => handLongPress(index, context),
        // 和盒子容器保持一致
        borderRadius: borderRadius,
        child: AnimatedContainer(
          duration: const Duration(seconds: 1),
          child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.white12, width: ScreenUtil().setWidth(1)),
                  color: context.watch<CurrentTheme>().isNightMode
                      ? easyDarkColor
                      : Colors.white,
                  borderRadius: borderRadius),
              child: Padding(
                padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    title,
                    SizedBox(
                      height:
                          ScreenUtil().setHeight(target.title!.isEmpty ? 0 : 8),
                    ),
                    Text(
                      content,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                      style: const TextStyle(color: Color(0xff636363)),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          currentTime,
                          style: TextStyle(
                              fontSize: ScreenUtil().setSp(12),
                              color: const Color(0xff969696)),
                        ),
                        baseAnimatedOpacity(
                            value: isShowCheckBox,
                            child: Checkbox(
                                shape: const CircleBorder(),
                                activeColor: themeColor,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                value: target.isSelect,
                                onChanged: (value) =>
                                    handleChangeCheckBox(value!, index)))
                      ],
                    ),
                  ],
                ),
              )),
        ),
      ),
    );
  }

  Widget buildNoteListCard() {
    messageText ??= S.of(context).notNoteMessage;
    if (isLoading) {
      return const Loading();
    } else {
      return noteList.isEmpty
          ? Expanded(
              child: SizedBox(
              height: ScreenUtil().setSp(20),
              child: Scrollbar(
                interactive: true,
                showTrackOnHover: true,
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    return SizedBox(
                      height: constraints.maxHeight,
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(
                            parent: AlwaysScrollableScrollPhysics()),
                        scrollDirection: Axis.vertical,
                        child: Center(
                          child: Text(messageText!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.grey)),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ))
          : Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemCount: noteList.length,
                itemBuilder: noteItemBuild,
                shrinkWrap: true,
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return HideKeyboard(
        child: Scaffold(
      appBar: buildBaseAppBar(
          titleWidget: appBarWidget(),
          action: [
            baseAnimatedOpacity(
                value: isShowCheckBox,
                child: IconButton(
                    onPressed: handleSelectMenu,
                    icon: AnimatedSwitcher(
                      duration: _duration,
                      transitionBuilder:
                          (Widget child, Animation<double> animation) {
                        //执行缩放动画
                        return ScaleTransition(child: child, scale: animation);
                      },
                      child: Icon(
                        isSelectAll
                            ? Icons.check_box_outlined
                            : Icons.check_box_outline_blank_sharp,
                        //显示指定key，不同的key会被认为是不同的Text，这样才能执行动画
                        key: ValueKey<bool>(isSelectAll),
                      ),
                    )))
          ],
          leading: IconButton(
              onPressed:
                  isShowCheckBox ? handleClose : () => Navigator.pop(context),
              icon: AnimatedSwitcher(
                duration: _duration,
                transitionBuilder: (Widget child, Animation<double> value) {
                  return ScaleTransition(
                    child: child,
                    scale: value,
                  );
                },
                child: Icon(
                  isShowCheckBox ? Icons.close : Icons.arrow_back,
                  key: ValueKey<bool>(isShowCheckBox),
                ),
              ))),
      body: WillPopScope(
        // 判断是否添加对应的回调 如果需要拦截则添加 不需要则 为null ,避免拦截ios下的 右滑返回
        onWillPop: isShowCheckBox ? handleWillPop : null,
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          key: _parentKey,
          child: RefreshIndicator(
            child: Column(
              children: [
                Center(
                  child: SearchBar(
                    _noteController,
                    handleSearch,
                    TextInputAction.search,
                    S.of(context).searchNote,
                    prefixIcon: Icon(
                      Icons.search,
                      size: ScreenUtil().setSp(20),
                      color: themeColor,
                    ),
                  ),
                ),
                SizedBox(
                  height: ScreenUtil().setHeight(20),
                ),
                buildNoteListCard(),
              ],
            ),
            onRefresh: _pullRefresh,
            color: themeColor,
          ),
        ),
      ),
      floatingActionButton: baseAnimatedOpacity(
          value: !isShowCheckBox,
          child: DragAbleFloatingActionButton(
            parentKey: _parentKey,
            child: SizedBox(
                height: 56,
                width: 56,
                child: NeumorphicButton(
                  style: const NeumorphicStyle(
                    boxShape: NeumorphicBoxShape.circle(),
                    shape: NeumorphicShape.concave,
                    depth: 4,
                  ),
                  child: Icon(
                    Icons.add,
                    color: context.read<CurrentTheme>().darkOrWhiteColor,
                  ),
                  onPressed: () => toCreateOrEditorNotePage(),
                )),
          )),
    ));
  }
}

class NewNote {
  int id;
  String? title;
  String content;
  bool isSelect;
  int time;

  NewNote(this.id, this.title, this.content, this.time, this.isSelect);
}
