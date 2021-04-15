class ToDo {
  String id;
  String title;
  bool completed;
  bool selected;

  ToDo({this.id, this.title, this.completed, this.selected});
  factory ToDo.fromJson(Map<String, dynamic> parsedJson) {
    return ToDo(
      id: parsedJson['id'].toString(),
      title: parsedJson['title'],
      completed: parsedJson['completed'],
      selected: false,
    );
  }
  static Future<ToDo> getData(dynamic json) async {
    return ToDo.fromJson(json);
  }
}
