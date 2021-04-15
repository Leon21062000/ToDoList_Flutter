import 'dart:convert';
import 'package:get/get.dart';
import 'package:todo_list/controller.dart';
import 'package:todo_list/todoItem.dart';
import 'package:http/http.dart' as http;

class ToDoList {
  ToDo toDo = ToDo();
  List<ToDo> toDoList;

  ToDoList({this.toDoList});
  factory ToDoList.fromJson(List<dynamic> parsedJson) {
    List<ToDo> todoList = [];
    Controller controller = Get.put(Controller());

    todoList = parsedJson.map((i) => ToDo.fromJson(i)).toList();
    controller.todoList.value = todoList;
    print(todoList.length);
    return ToDoList(
      toDoList: todoList,
    );
  }
  static Future<ToDoList> getData() async {
    final apiResult =
        await http.get(Uri.parse('https://jsonplaceholder.typicode.com/todos'));
    var jsonObject = json.decode(apiResult.body);
    return ToDoList.fromJson(jsonObject);
  }
}
