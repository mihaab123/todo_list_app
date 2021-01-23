import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/repositories/repository.dart';

class TodoService{
  Repository _repository;

  TodoService(){
    _repository = Repository();
  }
  saveTodo(Todo todo) async{
    return await _repository.insertData("todos", todo.todoMap());
  }
  readTodos() async{
    return await _repository.readData("todos");
  }
  readTodoById(todoID) async{
    return await _repository.readDataById("todos",todoID);
  }

  updateTodo(Todo todo) async {
    return await _repository.updateData("todos", todo.todoMap());
  }

  deleteTodo(todoID) async{
    return await _repository.deleteData("todos",todoID);
  }
  readTodoByCategory(category) async{
    return await _repository.readDataByColumnName("todos","category",category);
  }
}