//记录便列表数据类
class Note {
  int? id;
  // 便签标题
  String? title;
  // 便签内
  late String content;
  // 创建时间
  late int time;
  // 更新时间
  late int updateTime;

  Note(
      {this.id,
      this.title,
      required this.content,
      required this.time,
      required this.updateTime});

  //将json 序列化为model对象
  Note.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    content = json['content'];
    time = json['time'];
    updateTime = json['updateTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['time'] = time;
    data['updateTime'] = updateTime;
    return data;
  }
}
