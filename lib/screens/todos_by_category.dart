import 'package:flutter/material.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/screens/todo_list_screen.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'home_screen.dart';


class TodosByCategory extends StatefulWidget {
  final String category;
  TodosByCategory({this.category});

  @override
  _TodosByCategoryState createState() => _TodosByCategoryState();
}

class _TodosByCategoryState extends State<TodosByCategory> {
  TodoService _todoService = TodoService();
  List<Todo> _todoList = List<Todo>();


  @override
  void initState() {
    super.initState();
    getTodosByCategory();
  }

  getTodosByCategory() async {
    _todoList.clear();
    var todos = await _todoService.readTodoByCategory(this.widget.category);
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
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: RaisedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          color: Theme.of(context).primaryColor,
          elevation: 0.0,
        ),
        title: Text(this.widget.category),

      ),
      body: Column(
        children: [
          Expanded(
            child: TodoListScreen(_todoList, getTodosByCategory),
          ),
        ],
      ),
    );
  }
}
