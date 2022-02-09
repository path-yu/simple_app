//记录便列表数据类
class Note {
  late int id;
  late String title;
  late var content;
  late int time;

  Note(
      {required this.id,
      required this.title,
      this.content,
      required this.time});
  //将json 序列化为model对象
  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['time'] = time;
    return data;
  }
}
