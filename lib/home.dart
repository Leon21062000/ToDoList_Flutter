import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:todo_list/controller.dart';
import 'package:todo_list/todoItem.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    ScrollController _scrollController = new ScrollController();
    void showModal(
        context, Controller val, String type, String text, int index) {
      if (type != "add") {
        val.textController.value.text = text;
      }
      showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (BuildContext bc) {
            return StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Container(
                height: MediaQuery.of(context).size.height / 4,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15)),
                  boxShadow: [
                    BoxShadow(
                        blurRadius: 6,
                        color: Colors.black.withOpacity(0.05),
                        spreadRadius: 0,
                        offset: Offset(4, 4))
                  ],
                ),
                child: Container(
                  // alignment: Alignment.centerLeft,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 30),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            IconButton(
                                icon: Icon(Icons.close),
                                color: Colors.grey[800],
                                onPressed: () {
                                  val.textController.value =
                                      TextEditingController();
                                  Navigator.pop(context);
                                }),
                            Text(
                              (type == "add") ? 'Add To Do' : 'Edit To Do',
                              style: TextStyle(
                                  color: Colors.grey[800],
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18),
                            ),
                            IconButton(
                                icon: Icon(Icons.check),
                                color: Colors.grey[800],
                                onPressed: () {
                                  if (val.textController.value.text != "") {
                                    if (type == 'add') {
                                      print(val.textController.value.text);
                                      val.todoList.add(ToDo(
                                          id: (val.todoList.length + 1)
                                              .toString(),
                                          title: val.textController.value.text,
                                          completed: false,
                                          selected: false));

                                      _scrollController.jumpTo(
                                        _scrollController
                                                .position.maxScrollExtent +
                                            800.00,
                                      );
                                    } else {
                                      val.todoList[index].title =
                                          val.textController.value.text;
                                      val.todoList[index] = val.todoList[index];
                                    }
                                  }

                                  val.textController.value =
                                      TextEditingController();
                                  Navigator.pop(context);
                                }),
                          ],
                        ),
                      ),
                      Container(
                        child: TextField(
                          controller: val.textController.value,
                          decoration: InputDecoration(
                              focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red[300]),
                              ),
                              hintText: 'Type here'),
                        ),
                      ),
                      /////
                    ],
                  ),
                ),
              );
            });
          });
    }

    return GetX<Controller>(
        init: Controller(),
        builder: (val) => WillPopScope(
            child: MaterialApp(
                home: Scaffold(
                    backgroundColor: Colors.white,
                    floatingActionButton: FloatingActionButton(
                      onPressed: () {
                        if (val.selectMode[0] == true) {
                          val.selectMode[0] = false;
                        }
                        showModal(context, val, 'add', null, null);
                      },
                      child: const Icon(Icons.add),
                      backgroundColor: Colors.red[300],
                    ),
                    appBar: AppBar(
                        backgroundColor: Colors.white,
                        brightness: Brightness.light,
                        shadowColor: Colors.transparent,
                        actions: [
                          (val.selectMode[0] == false)
                              ? Container()
                              : (val.selectedItem.length < 1)
                                  ? IconButton(
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.grey,
                                      ),
                                      onPressed: null)
                                  : IconButton(
                                      icon: Icon(
                                        Icons.delete_outline_outlined,
                                        color: Colors.red[300],
                                      ),
                                      onPressed: () {
                                        print(val.selectedItem);
                                        for (int i = 0;
                                            i < val.selectedItem.length;
                                            i++) {
                                          // print(val.selectedItem[i]);
                                          if (val.selectedItem[i] -
                                                  val.minus.value >
                                              0) {
                                            val.todoList.removeAt(
                                                val.selectedItem[i] -
                                                    val.minus.value);
                                          } else {
                                            val.todoList.removeAt(0);
                                          }
                                          val.minus.value++;
                                        }
                                        print(val.todoList.length);
                                        val.minus.value = 0;
                                        val.selectedItem = [].obs;
                                        val.selectMode[0] = false;
                                      }),
                          GestureDetector(
                              onTap: () {
                                val.changeSelectMode();
                              },
                              child: (val.selectMode[0] == true)
                                  ? Container(
                                      height: 50,
                                      color: Colors.transparent,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Center(
                                        child: Text('Cancel',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[300])),
                                      ),
                                    )
                                  : Container(
                                      height: 50,
                                      color: Colors.transparent,
                                      padding:
                                          EdgeInsets.symmetric(horizontal: 15),
                                      child: Center(
                                        child: Text('Select',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                color: Colors.red[300])),
                                      ),
                                    ))
                        ],
                        title: GestureDetector(
                          onTap: () {
                            _scrollController.animateTo(
                              0.0,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeOut,
                            );
                          },
                          child: Text(
                            'To Do List',
                            style: TextStyle(
                              color: Colors.red[300],
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        )),
                    body: ReorderableListView(
                      scrollController: _scrollController,
                      children: <Widget>[
                        for (int i = 0; i < val.todoList.length; i++)
                          GestureDetector(
                            onTap: (val.selectMode[0] == true)
                                ? () {
                                    if (val.selectedItem.contains(i) == false) {
                                      val.selectedItem.add(i);
                                    }
                                  }
                                : null,
                            key: UniqueKey(),
                            child: Container(
                              color: (val.selectedItem.contains(i) == true)
                                  ? Colors.red[50]
                                  : Colors.white,
                              child: Dismissible(
                                background: (Container(
                                  color: Colors.red[300],
                                  child: Center(
                                    child: ListTile(
                                        tileColor: Colors.red[300],
                                        leading: Icon(
                                          Icons.delete,
                                          color: Colors.white,
                                        )),
                                  ),
                                )),
                                key: Key('$i'),
                                direction: DismissDirection.startToEnd,
                                onDismissed: (direction) {
                                  val.todoList.removeAt(i);
                                },
                                child: ListTile(
                                  leading: IconButton(
                                    onPressed: () {
                                      if (val.todoList[i].completed == false) {
                                        if (val.selectMode[0] == false) {
                                          val.todoList[i].completed = true;
                                          val.todoList[i] = val.todoList[i];
                                        }
                                      }
                                    },
                                    icon: (val.todoList[i].completed == true)
                                        ? Icon(Icons.check_box,
                                            color: Colors.red[300])
                                        : Icon(Icons.check_box_outline_blank,
                                            color: Colors.grey),
                                  ),
                                  trailing: (val.todoList[i].completed == false)
                                      ? IconButton(
                                          onPressed: () {
                                            if (val.selectMode[0] == false) {
                                              showModal(context, val, 'edit',
                                                  val.todoList[i].title, i);
                                            }
                                          },
                                          icon: Icon(
                                            Icons.edit,
                                            color: Colors.grey[800],
                                          ))
                                      : IconButton(
                                          onPressed: null,
                                          icon: Icon(Icons.edit,
                                              color: Colors.transparent),
                                        ),
                                  title: Container(
                                    padding: EdgeInsets.symmetric(vertical: 15),
                                    child: Text(
                                      '${val.todoList[i].title}',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: (val.todoList[i].completed ==
                                                  false)
                                              ? Colors.grey[800]
                                              : Colors.grey),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                      ],
                      onReorder: (int oldIndex, int newIndex) {
                        if (oldIndex < newIndex) {
                          newIndex -= 1;
                        }
                        final ToDo item = val.todoList.removeAt(oldIndex);
                        val.todoList.insert(newIndex, item);
                      },
                    ))),
            onWillPop: () async {
              if (val.selectMode[0] == true) {
                val.changeSelectMode();
              } else {
                Navigator.pop(context);
              }
              return false;
            }));
  }
}
