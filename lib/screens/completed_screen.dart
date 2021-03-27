import 'package:flutter/material.dart';
import 'package:todo_list_app/helpers/drawer_navigation.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/screens/todo_list_screen.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';


class CompletedScreen extends StatefulWidget {
  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  TodoService _todoService = TodoService();
  List<Todo> _todoList = List<Todo>();


  @override
  void initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoList.clear();
    var todos = await _todoService.readTodosCompleted();
    todos.forEach((todo) {
      setState(() {
        var todoModel = Todo();
        todoModel.title = todo["title"];
        todoModel.description = todo["description"];
        todoModel.todoDate = todo["todoDate"];
        todoModel.category = todo["category"];
        todoModel.isFinished = todo["isFinished"];
        todoModel.id = todo["id"];
        todoModel.repeat = todo["repeat"];
        _todoList.add(todoModel);
      });
    });
    _todoList.sort((taskA, taskB) => taskA.todoDate.compareTo(taskB.todoDate));
    setState(() {

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("completed").tr(),
      ),
      drawer: DrawerNavigation(),
      body: TodoListScreen(_todoList,getAllTodos),
    );
  }
}
