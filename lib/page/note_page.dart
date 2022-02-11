import 'dart:convert';

import 'package:date_format/date_format.dart' hide S;
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/base/base_animated_opacity.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/data/index.dart';
import 'package:simple_app/model/note.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/provider/current_locale.dart';
import 'package:simple_app/provider/current_theme.dart';
import 'package:simple_app/utils/show_dialog.dart';
import 'package:simple_app/utils/show_toast.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //定义一个controller
  final TextEditingController _noteController = TextEditingController();

  //滚动监听器
  final ScrollController _scrollController = ScrollController(); //listview的控制器
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

  @override
  void initState() {
    super.initState();
    // _scrollController.addListener(() {
    //   if (_scrollController.position.pixels ==
    //       _scrollController.position.maxScrollExtent) {
    //     print('滑动到了最底部');
    //     _getMore();
    //   }
    // });
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
    return null;
  }

  // 开始搜索
  handleSearch(String value) {
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
  void toCreateOrEditorNotePage({int? id, int? time}) {
    // 如果开启了长按选择则不进行跳转
    if (isShowCheckBox) {
      return;
    }
    if (id != null) {
      // 打开新页面 并等待返回结果
      Navigator.pushNamed(context, '/create_note_or_editor_page', arguments: {
        'appbarTitle': S.of(context).editorNote,
        'isEditor': true,
        "id": id,
        'time': time
      }).then((value) {
        // 然后返回了数据则更新页面
        if (value != null) {
          getData(DBProvider().findAll);
        }
      });
    } else {
      Navigator.pushNamed(context, '/create_note_or_editor_page', arguments: {
        'appbarTitle': S.of(context).createNote,
        'isEditor': false
      }).then((value) {
        getData(DBProvider().findAll);
      });
    }
  }

  // 长按选择
  void handLongPress(int index, BuildContext context) {
    if (isShowCheckBox) return;
    setState(() {
      isShowCheckBox = true;
      noteList[index].isSelect = true;
      selectIndexList.add(noteList[index].id);
    });
    Scaffold.of(context).showBottomSheet<void>(
      (BuildContext context) {
        return Container(
          height: ScreenUtil().setHeight(60),
          color: context.watch<CurrentTheme>().isNightMode
              ? Colors.black12
              : Colors.white60,
          child: Center(
            child: InkWell(
              onTap: handleDelete,
              child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [Icon(Icons.delete), Text('删除')]),
            ),
          ),
        );
      },
    );
  }

  // 点击底部删除按钮
  void handleDelete() async {
    // 提示是否删除
    if (await showConfirmDialog(context,
            message: S.of(context).deleteMessage) != null) {
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
    }

  }

  // 重置数据
  void resetData() {
    isShowCheckBox = false;
    selectIndexList.clear();
    for (NewNote note in noteList) {
      note.isSelect = false;
    }
  }

  // 选择checkbox回调
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

  showAppBarTitle() {
    return isShowCheckBox
        ? S.of(context).selected +
            ' ' +
            selectIndexList.length.toString() +
            " " +
            S.of(context).item
        : S.of(context).note;
  }

  Widget noteItemBuild(BuildContext context, int index) {
    NewNote target = noteList[index];
    var date = DateTime.fromMicrosecondsSinceEpoch(target.time);
    String content = getNoteContent(target);
    final title = target.title == null
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
        DateTime(
          date.year,
          date.month,
          date.day,
        ),
        context.watch<CurrentLocale>().languageIsEnglishMode
            ? [yyyy, '-', mm, '-', dd]
            : [yyyy, '年', mm, '月', dd, '日']);
    var padding = ScreenUtil().setSp(20);
    return InkWell(
      onTap: () => toCreateOrEditorNotePage(id: target.id, time: target.time),
      onLongPress: () => handLongPress(index, context),
      child: DecoratedBox(
          decoration: BoxDecoration(
              border: Border.all(color: Colors.white12, width: 1),
              color: context.watch<CurrentTheme>().isNightMode
                  ? easyDarkColor
                  : Colors.white,
              borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))),
          child: Padding(
            padding: EdgeInsets.fromLTRB(padding, padding, padding, 0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                title,
                SizedBox(
                  height: ScreenUtil().setHeight(15),
                ),
                Text(
                  content,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 3,
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
              child: ListView.builder(
                itemCount: 15,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                itemBuilder: (BuildContext context, int index) {
                  if (index == 0) {
                    return Center(
                      child: Text(messageText!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey)),
                    );
                  } else {
                    return const SizedBox(
                      width: 40,
                      height: 40,
                    );
                  }
                },
              ),
            ))
          : Expanded(
              child: MasonryGridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 10,
                crossAxisSpacing: 10,
                physics: const AlwaysScrollableScrollPhysics(),
                controller: _scrollController,
                itemCount: noteList.length,
                itemBuilder: noteItemBuild,
                shrinkWrap: true,
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(showAppBarTitle(),
          action: [
            baseAnimatedOpacity(
                value: isShowCheckBox,
                child: IconButton(
                    onPressed: handleSelectMenu,
                    icon: const Icon(Icons.menu_open_sharp)))
          ],
          leading: isShowCheckBox
              ? IconButton(
                  onPressed: handleClose, icon: const Icon(Icons.close))
              : IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.arrow_back))),
      body: WillPopScope(
        // 判断是否添加对应的回调 如果需要拦截则添加 不需要则 为null ,避免拦截ios下的 右滑返回
        onWillPop: isShowCheckBox ? handleWillPop : null,
        child: Container(
          padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
          child: RefreshIndicator(
            child: Column(
              children: [
                Center(
                  child: SearchBar(
                    _noteController,
                    handleSearch,
                    TextInputAction.search,
                    S.of(context).searchNote,
                    fillColor: searchBarFillColor,
                    prefixIcon: Icon(
                      Icons.search,
                      size: ScreenUtil().setSp(15),
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
            color: const Color(0xFF4483f6),
          ),
        ),
      ),
      floatingActionButton: baseAnimatedOpacity(
          value: !isShowCheckBox,
          child: FloatingActionButton(
            onPressed: () => toCreateOrEditorNotePage(),
            child: const Icon(Icons.add),
          )),
    );
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
