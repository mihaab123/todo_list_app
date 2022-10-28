import 'package:flutter/material.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/services/todo_service.dart';

enum TodoType { ALL_TODO, COMPLETED_TODO }

class ToDoProvider with ChangeNotifier {
  TodoService _service = TodoService();
  List<Todo> _todoList = [];
  List<Todo> _todoCompletedList = [];

  ToDoProvider.initialize() {
    loadToDos();
    loadToDosCompleted();
  }

  get todoList => _todoList;
  get todoCompletedList => _todoCompletedList;

  getCurrentList(TodoType todoType) {
    switch (todoType) {
      case TodoType.COMPLETED_TODO:
        return _todoCompletedList;
        break;
      default:
        return _todoList;
    }
  }

  loadToDos() async {
    _todoList.clear();
    var todos = await _service.readTodos();
    todos.forEach((category) {
      var todoModel = Todo.fromMap(category);
      _todoList.add(todoModel);
    });
    notifyListeners();
  }

  loadToDosCompleted() async {
    _todoCompletedList.clear();
    var todos = await _service.readTodosCompleted();
    todos.forEach((category) {
      var todoModel = Todo.fromMap(category);
      _todoCompletedList.add(todoModel);
    });
    notifyListeners();
  }

  updateToDo(Todo todo) async {
    _service.updateTodo(todo);
    _todoList[_todoList.indexWhere((element) => element.id == todo.id)] = todo;
    notifyListeners();
  }

  saveTodo(Todo todo) async {
    _service.saveTodo(todo);
    loadToDos();
    loadToDosCompleted();
    notifyListeners();
  }

  deleteTodo(Todo todo) async {
    _service.deleteTodo(todo.id);
    _todoList.remove(todo);
    notifyListeners();
  }
}
