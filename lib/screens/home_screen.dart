import 'package:flutter/material.dart';
import 'package:todo_list_app/components/drawer_navigation.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/screens/todo_list_screen.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("app_title").tr(),
      ),
      drawer: DrawerNavigation(),
      body: TodoListScreen(TodoType.ALL_TODO),
    );
  }
}
