import 'package:flutter/material.dart';
import 'package:todo_list_app/components/drawer_navigation.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/screens/todo_list_screen.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';

class CompletedScreen extends StatefulWidget {
  @override
  _CompletedScreenState createState() => _CompletedScreenState();
}

class _CompletedScreenState extends State<CompletedScreen> {
  TodoService _todoService = TodoService();
  List<Todo> _todoList = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("completed").tr(),
      ),
      drawer: DrawerNavigation(),
      body: TodoListScreen(TodoType.COMPLETED_TODO),
    );
  }
}
