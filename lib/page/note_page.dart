import 'package:flutter/material.dart';
import 'package:simple_app/data/index.dart';
import 'package:simple_app/model/note.dart';

class NotePage extends StatefulWidget {
  const NotePage({Key? key}) : super(key: key);

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  //定义一个controller
  final TextEditingController _noteController = TextEditingController();
  // 所有的标签数据
  List<Note> noteList = [];
  // 数据是否正在加载
  bool isLoading = true;
  // t提示文字
  String messageText = "你还未添加添加便签,请点击按钮添加便签吧!";
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    DBProvider().findAll().then((value) {
      print(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('33'),
      ),
      body: const Center(
        child: Text('data'),
      ),
    );
  }
}
