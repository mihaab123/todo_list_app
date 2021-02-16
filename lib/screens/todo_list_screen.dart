import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/screens/todo_screen.dart';
import 'package:todo_list_app/services/category_service.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoListScreen<T> extends StatefulWidget {

  final List<Todo> _todoList;
  final Function() getTodos;
  TodoListScreen(this._todoList,this.getTodos);

  @override
  _TodoListScreenState createState() => _TodoListScreenState();
}

class _TodoListScreenState<T> extends State<TodoListScreen> {
  TodoService _todoService = TodoService();
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd HH:mm");
  var _categoryService = CategoryService();
  var _categoriesList = Map<String,int>();

  @override
  void initState() {
    super.initState();
    getAllCategories();
  }

  getAllCategories() async {
    _categoriesList.clear();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categoriesList.addAll({category["name"]: category["color"]});
      });
    });
  }

  Color getCategoryColor(String categoryId){
    Color currentColor = Colors.white;
    _categoriesList.forEach((k, v) {
      if (k==categoryId){
        currentColor = Color(v);
      }
    });
     return currentColor;
  }
  _deleteFormDialog(BuildContext context, int todoId) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              FlatButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel").tr(),
                color: Colors.red,
              ),
              FlatButton(
                onPressed: () async {
                  var result = await _todoService.deleteTodo(todoId);
                  if (result>0) {
                    Navigator.pop(context);
                    setState(() {
                      widget.getTodos();
                    });

                    //_showSuccessSnackbar(Text("Deleted"));
                  }
                },
                child: Text("button_delete").tr(),
                color: Theme.of(context).primaryColor,
              ),
            ],
            title: Text("question_deleted").tr(),
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
          itemCount: widget._todoList.length,
          itemBuilder: (BuildContext context, int index){
            return GestureDetector(
              onLongPressEnd: (LongPressEndDetails details){
                _deleteFormDialog(context,widget._todoList[index].id);
              },
              child: Padding(
                padding: EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),

                child: Card(
                  elevation: 8.0,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(0)
                  ),
                  child: ListTile(
                    leading: ConstrainedBox(
                        constraints: BoxConstraints(
                          minWidth: 2,
                          minHeight: 2,
                          maxWidth: 2,
                          maxHeight: 52,
                        ),
                       child: Text(" ", style: TextStyle(backgroundColor: getCategoryColor(widget._todoList[index].category),fontSize: 42.0),)),
                    minLeadingWidth: 0,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text("${widget._todoList[index].title??"No Title"}",
                            style: TextStyle(
                              fontSize: 18.0,
                              decoration: widget._todoList[index].isFinished == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            ))
                      ],
                    ),
                    subtitle: Row(
                      children: [
                        Text("${_dateFormat.format(DateTime.fromMillisecondsSinceEpoch(widget._todoList[index].todoDate))??"No Date"} - ",
                            style: TextStyle(
                              fontSize: 15.0,
                              decoration: widget._todoList[index].isFinished == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            )),
                        Text("${widget._todoList[index].category??"No Category"}",
                            style: TextStyle(
                              fontSize: 15.0,
                              //color: Colors.red,
                              decoration: widget._todoList[index].isFinished == 0
                                  ? TextDecoration.none
                                  : TextDecoration.lineThrough,
                            )),
                      ],
                    ),
                    trailing: Checkbox(
                      onChanged: (value) {
                        widget._todoList[index].isFinished = value ? 1 : 0;
                        _todoService.updateTodo(widget._todoList[index]);
                        widget.getTodos();
                      },
                      activeColor: Theme.of(context).primaryColor,
                      value: widget._todoList[index].isFinished==1 ? true : false,
                    ),
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) => TodoScreen(getTodos: widget.getTodos,todo: widget._todoList[index])));
                    },
                    //Text(widget._todoList[index].todoDate??"No Date"),
                  ),
                ),

              ),
            );
          }
      ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => TodoScreen(getTodos: widget.getTodos,todo: new Todo()))),
        )
    );
  }
}
