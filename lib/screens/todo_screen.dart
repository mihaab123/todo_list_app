import 'package:flutter/material.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';

class TodoScreen extends StatefulWidget {
  final Function() getTodos;
  final Todo todo;
  TodoScreen({this.getTodos,this.todo});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();
  DateTime _dateTime = DateTime.now();
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(DropdownMenuItem(
            child: Text(
                category["name"]),
            value: category["name"]),

        );
      if (_selectedValue == null){
        _selectedValue = category["name"];
      }
      });
    });
  }
  _selectedTodoDate(BuildContext context) async {
    final DateTime _pickerDate = await showDatePicker(
        context: context,
        initialDate: _dateTime,
        firstDate: DateTime(2000),
        lastDate: DateTime(2100));
    if (_pickerDate != null && _pickerDate != _dateTime) {
      setState(() {
        _dateTime = _pickerDate;
      });
    }
    _todoDateController.text = _dateFormat.format(_dateTime);
  }
  _showSuccessSnackbar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if(widget.todo.id!=null){
      _todoTitleController.text = widget.todo.title;
      _todoDescriptionController.text = widget.todo.description;
      _todoDateController.text = widget.todo.todoDate;
      _selectedValue = widget.todo.category;
    }
    else{

      _todoDateController.text = _dateFormat.format(_dateTime);
    }
  }
  @override
  void dispose(){
    _todoDateController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(widget.todo.id == null ? "create_todo".tr() : "update_todo".tr()),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _todoTitleController,
              decoration: InputDecoration(
                  labelText: "title_name".tr(), hintText: "title_hint".tr()),
            ),
            TextField(
              controller: _todoDescriptionController,
              decoration: InputDecoration(
                  labelText: "description_name".tr(), hintText: "description_hint".tr()),
            ),
            TextField(
              controller: _todoDateController,
              readOnly: true,
              decoration: InputDecoration(
                  labelText: "date_name".tr(),
                  hintText: "date_hint".tr(),
                  prefixIcon: InkWell(
                    onTap: () {_selectedTodoDate(context);},
                    child: Icon(Icons.calendar_today),
                  )),
            ),
            DropdownButtonFormField(
              items: _categories,
              value: _selectedValue,
              hint: Text("category_name").tr(),
              onChanged: (value) {
                setState(() {
                  _selectedValue = value;
                });
              },
            ),
            SizedBox(
              height: 20.0,
            ),
            RaisedButton(
                onPressed: () async {
                  var _todoService = TodoService();
                  widget.todo.title = _todoTitleController.text;
                  widget.todo.description = _todoDescriptionController.text;
                  widget.todo.todoDate = _todoDateController.text;
                  widget.todo.category = _selectedValue.toString();
                  var result = 0;
                  if (widget.todo.id == null){
                    widget.todo.isFinished = 0;
                    result = await _todoService.saveTodo(widget.todo);
                  } else {
                    result = await _todoService.updateTodo(widget.todo);
                  };

                  if (result>0) {
                    _showSuccessSnackbar(Text("snackbar_created").tr());
                    Navigator.pop(context);
                    widget.getTodos();
                  }
                },
              color: Theme
                  .of(context)
                  .primaryColor,
              child: Text("button_save", style: TextStyle(color: Colors.white),).tr(),
            )
          ],
        ),
      ),
    );
  }
}