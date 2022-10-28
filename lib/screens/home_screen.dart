import 'package:flutter/material.dart';
import 'package:todo_list_app/helpers/drawer_navigation.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/screens/todo_list_screen.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TodoService _todoService = TodoService();
  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
    getAllTodos();
  }

  getAllTodos() async {
    _todoList.clear();
    var todos = await _todoService.readTodos();
    todos.forEach((todo) {
      _todoList.add(todo);
    });
    _todoList.sort((taskA, taskB) => taskA.todoDate.compareTo(taskB.todoDate));
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app_title").tr(),
      ),
      drawer: DrawerNavigation(),
      body: TodoListScreen(_todoList, getAllTodos),
    );
  }
}
