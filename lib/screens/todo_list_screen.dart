import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sticky_grouped_list/sticky_grouped_list.dart';
import 'package:todo_list_app/components/page_wrapper.dart';
import 'package:todo_list_app/helpers/notificationHelper.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/providers/category_provider.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/screens/todo_screen.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';

import '../main.dart';

class TodoListScreen<T> extends StatefulWidget {
  final TodoType todoType;
  TodoListScreen(this.todoType);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState<T> extends State<TodoListScreen> {
  TodoService _todoService = TodoService();
  final DateFormat _dateFormat = DateFormat("yy-MM-dd HH:mm");
  //var _categoryService = CategoryService();
  //var _categoriesList = Map<String, int>();
  List<String> separatorList = [
    "separator_past".tr(),
    "separator_today".tr(),
    "separator_tomorrow".tr(),
    "separator_next_week".tr(),
    "separator_future".tr()
  ];

  @override
  void initState() {
    super.initState();
  }

  Color getCategoryColor(String categoryId, CategoryProvider categoryProvider) {
    Color currentColor = Colors.white;
    final category = categoryProvider.categoriesList
        .firstWhere((element) => element.name == categoryId, orElse: () {
      return null;
    });

    if (category == null) {
      return currentColor;
    } else {
      return Color(category.color);
    }
  }

  _deleteFormDialog(
      BuildContext context, Todo todo, ToDoProvider toDoProvider) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel").tr(),
                //color: Colors.red,
              ),
              TextButton(
                onPressed: () async {
                  await toDoProvider.deleteTodo(todo);
                  Navigator.pop(context);
                },
                child: Text("button_delete").tr(),
              ),
            ],
            title: Text("question_deleted").tr(),
          );
        });
  }

  int getSeparatorDate(Todo value) {
    int index = 0;
    DateTime curDate = DateTime.now();
    DateTime curDateBeginning =
        new DateTime(curDate.year, curDate.month, curDate.day);
    DateTime todoDate = DateTime.fromMillisecondsSinceEpoch(value.todoDate);
    DateTime todoDateBeginning =
        new DateTime(todoDate.year, todoDate.month, todoDate.day);
    Duration dur = curDateBeginning.difference(todoDateBeginning);
    if (dur.inDays > 0) {
      index = 0;
    } else if (dur.inDays == 0) {
      index = 1;
    } else if (dur.inDays == -1) {
      index = 2;
    } else if (dur.inDays >= -7) {
      index = 3;
    } else if (dur.inDays < -7) {
      index = 4;
    }
    return index;
  }

  @override
  Widget build(BuildContext context) {
    final _categoryProvider = Provider.of<CategoryProvider>(context);
    final _todoProvider = Provider.of<ToDoProvider>(context);
    return Scaffold(
        backgroundColor: Theme.of(context).primaryColor,
        body: PageWrapper(
          body: StickyGroupedListView<Todo, int>(
            elements: _todoProvider.getCurrentList(widget.todoType),
            groupBy: (element) => getSeparatorDate(element),
            //groupComparator: (value1, value2) => value2.compareTo(value1),
            itemComparator: (item1, item2) =>
                item1.todoDate.compareTo(item2.todoDate),
            order: StickyGroupedListOrder.ASC,
            groupSeparatorBuilder: (Todo element) => Padding(
              padding: const EdgeInsets.only(left: 15.0, top: 5.0),
              child: Text(
                separatorList[getSeparatorDate(element)],
                textAlign: TextAlign.left,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
            ),
            itemBuilder: (context, element) {
              return todoCard(
                  context, element, _categoryProvider, _todoProvider);
            },
          ),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  TodoScreen(todoType: widget.todoType, todo: new Todo()))),
        ));
  }

  Widget getCircleIcon(Todo currentTodo) {
    if (currentTodo.repeat != null && currentTodo.repeat.isNotEmpty) {
      return Icon(
        Icons.autorenew,
        color: Colors.white,
      );
    } else if (currentTodo.isFinished == 1) {
      return Icon(Icons.check, color: Colors.white);
    } else {
      return Container();
    }
  }

  void completeTodo(Todo todo, int value, ToDoProvider toDoProvider) {
    if (value == 0) {
      if (todo.repeat.isEmpty) {
        todo.isFinished = 1;
      } else {
        todo.todoDate = repeatTodo(todo.todoDate, todo.repeat);
      }
    } else {
      todo.isFinished = 0;
    }
    toDoProvider.updateToDo(todo);
    if (todo.isFinished == 0) {
      if (todo.id != null) {
        turnOffNotificationById(flutterLocalNotificationsPlugin, todo.id);
      }
      scheduleNotification(flutterLocalNotificationsPlugin, todo.id.toString(),
          todo.title, DateTime(todo.todoDate));
    } else {
      if (todo.id != null) {
        turnOffNotificationById(flutterLocalNotificationsPlugin, todo.id);
      }
    }
    if (todo.repeat.isEmpty) {
      // toDoProvider.deleteTodo(todo);
      // widget._todoList.remove(todo);
      //_list.removeAt(index);
    }
    setState(() {});
  }

  int repeatTodo(int todoDate, String repeat) {
    DateTime _dateTimeBegin = DateTime.fromMillisecondsSinceEpoch(todoDate);
    int count = int.parse(repeat.substring(0, repeat.length - 1));
    String type = repeat.substring(repeat.length - 1, repeat.length);
    switch (type) {
      case "h":
        _dateTimeBegin = DateTime(
            _dateTimeBegin.year,
            _dateTimeBegin.month,
            _dateTimeBegin.day,
            _dateTimeBegin.hour + count,
            _dateTimeBegin.minute,
            _dateTimeBegin.second);
        break;
      case "d":
        _dateTimeBegin = DateTime(
            _dateTimeBegin.year,
            _dateTimeBegin.month,
            _dateTimeBegin.day + count,
            _dateTimeBegin.hour,
            _dateTimeBegin.minute,
            _dateTimeBegin.second);
        break;
      case "w":
        _dateTimeBegin = DateTime(
            _dateTimeBegin.year,
            _dateTimeBegin.month,
            _dateTimeBegin.day + (count * 7),
            _dateTimeBegin.hour,
            _dateTimeBegin.minute,
            _dateTimeBegin.second);
        break;
      case "m":
        _dateTimeBegin = DateTime(
            _dateTimeBegin.year,
            _dateTimeBegin.month + count,
            _dateTimeBegin.day,
            _dateTimeBegin.hour,
            _dateTimeBegin.minute,
            _dateTimeBegin.second);
        break;
      case "y":
        _dateTimeBegin = DateTime(
            _dateTimeBegin.year + count,
            _dateTimeBegin.month,
            _dateTimeBegin.day,
            _dateTimeBegin.hour,
            _dateTimeBegin.minute,
            _dateTimeBegin.second);
        break;
    }
    return _dateTimeBegin.millisecondsSinceEpoch;
  }

  Widget todoCard(
    BuildContext context,
    Todo todo,
    CategoryProvider categoryProvider,
    ToDoProvider todoProvider,
  ) {
    return GestureDetector(
      onLongPressEnd: (LongPressEndDetails details) {
        _deleteFormDialog(context, todo, todoProvider);
      },
      child: Padding(
        padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Card(
          elevation: 8.0,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: ListTile(
            leading: GestureDetector(
              onTap: () {
                completeTodo(todo, todo.isFinished, todoProvider);
              },
              child: CircleAvatar(
                backgroundColor:
                    getCategoryColor(todo.category, categoryProvider),
                child: getCircleIcon(todo),
              ),
            ),
            minLeadingWidth: 0,
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                  child: Text("${todo.title ?? "No Title"}",
                      overflow: TextOverflow.clip,
                      style: TextStyle(
                        fontSize: 18.0,
                        decoration: todo.isFinished == 0
                            ? TextDecoration.none
                            : TextDecoration.lineThrough,
                      )),
                )
              ],
            ),
            subtitle: Text("${todo.category ?? "No Category"}",
                style: TextStyle(
                  fontSize: 15.0,
                  decoration: todo.isFinished == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                )),
            trailing: Text(
                "${_dateFormat.format(DateTime.fromMillisecondsSinceEpoch(todo.todoDate)) ?? "No Date"}",
                style: TextStyle(
                  fontSize: 12.0,
                  decoration: todo.isFinished == 0
                      ? TextDecoration.none
                      : TextDecoration.lineThrough,
                )),
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) =>
                      TodoScreen(todoType: widget.todoType, todo: todo)));
            },
          ),
        ),
      ),
    );
  }
}
