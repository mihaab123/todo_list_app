import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_picker/Picker.dart';
import 'package:provider/provider.dart';
import 'package:todo_list_app/helpers/notificationHelper.dart';
import 'package:todo_list_app/models/todo.dart';
import 'package:todo_list_app/providers/todo_provider.dart';
import 'package:todo_list_app/services/category_service.dart';
import 'package:intl/intl.dart';
import 'package:todo_list_app/services/todo_service.dart';
import 'package:easy_localization/easy_localization.dart';

import '../main.dart';

class TodoScreen extends StatefulWidget {
  final TodoType todoType;
  final Todo todo;
  TodoScreen({this.todoType, this.todo});

  @override
  _TodoScreenState createState() => _TodoScreenState();
}

class _TodoScreenState extends State<TodoScreen> {
  var _todoTitleController = TextEditingController();
  var _todoDescriptionController = TextEditingController();
  var _todoDateController = TextEditingController();
  var _todoTimeController = TextEditingController();
  var _todoRepeatController = TextEditingController();
  var _selectedValue;
  var _categories = List<DropdownMenuItem>();
  DateTime _dateTime = DateTime.now();
  final DateFormat _dateFormat = DateFormat("yyyy-MM-dd");
  final DateFormat _timeFormat = DateFormat("HH:mm");
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  //int _currentRepeatInteger = 0;
  static const PickerData2 = '''
      [
          [1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 
          11, 12, 13, 14, 15, 16, 17, 18, 19, 
          20, 21, 22, 23, 24, 25, 26, 27, 28, 29,
          30, 31, 32, 33, 34, 35, 36, 37, 38, 39,
          40, 41, 42, 43, 44, 45, 46, 47, 48, 49,
          50, 51, 52, 53, 54, 55, 56, 57, 58, 59 ],      
          ["Hour","Day","Week","Month","Year"]
      ]''';

  _loadCategories() async {
    var _categoryService = CategoryService();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        _categories.add(
          DropdownMenuItem(
              child: Text(category["name"]), value: category["name"]),
        );
        if (_selectedValue == null) {
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
    DateTime curDate = DateTime(_pickerDate.year, _pickerDate.month,
        _pickerDate.day, _dateTime.hour, _dateTime.minute);
    if (_pickerDate != null && curDate != _dateTime) {
      setState(() {
        _dateTime = curDate;
      });
    }
    _todoDateController.text = _dateFormat.format(_dateTime);
  }

  _selectedTodoTime(BuildContext context) async {
    final TimeOfDay _pickerTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay(hour: _dateTime.hour, minute: _dateTime.minute));
    DateTime curDate = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
        _pickerTime.hour, _pickerTime.minute);
    if (_pickerTime != null && curDate != _dateTime) {
      setState(() {
        _dateTime = DateTime(_dateTime.year, _dateTime.month, _dateTime.day,
            _pickerTime.hour, _pickerTime.minute);
      });
    }
    _todoTimeController.text = _timeFormat.format(_dateTime);
  }

  _selectedTodoRepeat(BuildContext context) async {
    new Picker(
        adapter: PickerDataAdapter<String>(
            pickerdata: new JsonDecoder().convert(PickerData2), isArray: true),
        hideHeader: true,
        title: new Text("repeat_name").tr(),
        cancelText: "cancel".tr(),
        confirmText: "button_save".tr(),
        //selecteds: [],
        onConfirm: (Picker picker, List value) {
          _todoRepeatController.text =
              picker.getSelectedValues()[0].toString() +
                  picker.getSelectedValues()[1].substring(0, 1).toLowerCase();
        }).showDialog(context);
  }

  _showSuccessSnackbar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  void initState() {
    super.initState();
    _loadCategories();
    if (widget.todo.id != null) {
      _todoTitleController.text = widget.todo.title;
      _todoDescriptionController.text = widget.todo.description;
      _dateTime = DateTime.fromMillisecondsSinceEpoch(widget.todo.todoDate);
      _todoDateController.text = _dateFormat.format(_dateTime);
      _todoTimeController.text = _timeFormat.format(_dateTime);
      _todoRepeatController.text = widget.todo.repeat;
      _selectedValue = widget.todo.category;
    } else {
      _todoDateController.text = _dateFormat.format(_dateTime);
    }
  }

  @override
  void dispose() {
    _todoDateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final _todoProvider = Provider.of<ToDoProvider>(context);
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        title: Text(
            widget.todo.id == null ? "create_todo".tr() : "update_todo".tr()),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
                    labelText: "description_name".tr(),
                    hintText: "description_hint".tr()),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        onTap: () {
                          _selectedTodoDate(context);
                        },
                        controller: _todoDateController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "date_name".tr(),
                          hintText: "date_hint".tr(),
                          /*prefixIcon: InkWell(
                                  onTap: () {_selectedTodoDate(context);},
                                  child: Icon(Icons.calendar_today),
                                )*/
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: TextField(
                        onTap: () {
                          _selectedTodoTime(context);
                        },
                        controller: _todoTimeController,
                        readOnly: true,
                        decoration: InputDecoration(
                          labelText: "time_name".tr(),
                          hintText: "time_hint".tr(),
                        ),
                      ),
                    ),
                  ),
                ],
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
              TextField(
                controller: _todoRepeatController,
                readOnly: true,
                decoration: InputDecoration(
                    labelText: "repeat_name".tr(),
                    hintText: "repeat_hint".tr()),
                onTap: () {
                  _selectedTodoRepeat(context);
                },
              ),
              SizedBox(
                height: 20.0,
              ),
              ElevatedButton(
                onPressed: () async {
                  widget.todo.title = _todoTitleController.text;
                  widget.todo.description = _todoDescriptionController.text;
                  widget.todo.repeat = _todoRepeatController.text;
                  widget.todo.todoDate = _dateTime.millisecondsSinceEpoch;
                  widget.todo.category = _selectedValue.toString();

                  if (widget.todo.id == null) {
                    widget.todo.isFinished = 0;
                    _todoProvider.saveTodo(widget.todo);
                    _showSuccessSnackbar(Text("snackbar_created").tr());
                    Navigator.pop(context);
                  } else {
                    _todoProvider.updateToDo(widget.todo);
                    _showSuccessSnackbar(Text("snackbar_saved").tr());
                    Navigator.pop(context);
                  }

                  if (widget.todo.isFinished == 0) {
                    if (widget.todo.id != null) {
                      turnOffNotificationById(
                          flutterLocalNotificationsPlugin, widget.todo.id);
                    }
                    scheduleNotification(
                        flutterLocalNotificationsPlugin,
                        widget.todo.id.toString(),
                        _todoTitleController.text,
                        _dateTime);
                  }
                },
                child: Text(
                  "button_save",
                  style: TextStyle(color: Colors.white),
                ).tr(),
              )
            ],
          ),
        ),
      ),
    );
  }
}
