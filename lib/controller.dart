import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:todo_list/toDoList.dart';

class Controller extends GetxController {
  void onInit() {
    ToDoList.getData();
    super.onInit();
  }

  void changeSelectMode() {
    if (selectMode[0] == false) {
      selectMode[0] = true;
    } else {
      selectMode[0] = false;
      selectedItem = [].obs;
    }
  }

  var todoList = [].obs;

  var minus = 0.obs;
  var selectMode = [false].obs;
  var selectedItem = [].obs;
  var textController = TextEditingController().obs;
}
