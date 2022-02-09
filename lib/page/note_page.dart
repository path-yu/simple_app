import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:simple_app/common/color.dart';
import 'package:simple_app/components/base/build_base_app_bar.dart';
import 'package:simple_app/components/base/loading.dart';
import 'package:simple_app/components/search_bar.dart';
import 'package:simple_app/data/index.dart';
import 'package:simple_app/model/note.dart';
import 'package:simple_app/generated/l10n.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';
import 'package:simple_app/provider/current_theme.dart';

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
  List<Note> noteList = [Note(id: 34, title: '43', time: 11000)];
  // 数据是否正在加载
  bool isLoading = false;
  // t提示文字
  String messageText = "你还未添加添加便签,请点击按钮添加便签吧!";
  @override
  void initState() {
    super.initState();
    DBProvider().findAll().then((value) {
      print(value);
    });
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getMore();
      }
    });
  }

  Future _pullRefresh() async {
    await Future.delayed(const Duration(seconds: 2));
    return null;
  }

  // 加载更多
  _getMore() {}
  toCreateOrEditorNotePage() {}
  void addConfrim(String value) {}

  Widget noteItemBuild(BuildContext context, int index) {
    return InkWell(
      onTap: () {
        print('34');
      },
      child: SizedBox(
        height: ScreenUtil().setHeight(100),
        child: DecoratedBox(
            decoration: BoxDecoration(
                border: Border.all(color: Colors.white12, width: 1),
                color: context.watch<CurrentTheme>().isNightMode
                    ? easyDarkColor
                    : Colors.white,
                borderRadius: BorderRadius.circular(ScreenUtil().setSp(10))),
            child: Padding(
              padding: EdgeInsets.all(ScreenUtil().setSp(10)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'target.title',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    'content',
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(color: Color(0xff636363)),
                  ),
                  Text(
                    'currentTime',
                    style: TextStyle(
                        fontSize: ScreenUtil().setSp(12),
                        color: const Color(0xff969696)),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Widget buildNoteListCard() {
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
                      child: Text(messageText,
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
                mainAxisSpacing: 4,
                crossAxisSpacing: 4,
                physics: const BouncingScrollPhysics(),
                controller: _scrollController,
                itemCount: 20,
                itemBuilder: noteItemBuild,
              ),
            );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildBaseAppBar(S.of(context).note),
      body: Container(
        padding: EdgeInsets.all(ScreenUtil().setWidth(10)),
        child: RefreshIndicator(
          child: Column(
            children: [
              Center(
                child: SearchBar(
                  _noteController,
                  addConfrim,
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
      floatingActionButton: FloatingActionButton(
        onPressed: () => toCreateOrEditorNotePage(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
