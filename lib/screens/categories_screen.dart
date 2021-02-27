import 'package:flutter/material.dart';
import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/services/category_service.dart';
import 'package:easy_localization/easy_localization.dart';

import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _category = Category();
  var _categoryService = CategoryService();
  List<Category> _categoriesList = List<Category>();
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  var category;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var _categoryColors = List<DropdownMenuItem>();
  var _selectedColor;

  @override
  void initState() {
    super.initState();
    getAllCategories();
    getColors();
  }

  getAllCategories() async {
    _categoriesList.clear();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
      setState(() {
        var categoryModel = Category();
        categoryModel.name = category["name"];
        categoryModel.description = category["description"];
        categoryModel.id = category["id"];
        categoryModel.color = category["color"];
        _categoriesList.add(categoryModel);
      });
    });
  }
  getColors(){
    _categoryColors.add(DropdownMenuItem(child: Text("blue"), value: Color(Colors.blue.value)),);
    _categoryColors.add(DropdownMenuItem(child: Text("red"), value: Color(Colors.red.value)),);
    _categoryColors.add(DropdownMenuItem(child: Text("green"), value: Color(Colors.green.value)),);
    _categoryColors.add(DropdownMenuItem(child: Text("yellow"), value: Color(Colors.yellow.value)),);
    _categoryColors.add(DropdownMenuItem(child: Text("orange"), value: Color(Colors.orange.value)),);
    _categoryColors.add(DropdownMenuItem(child: Text("purple"), value: Color(Colors.purple.value)),);
    if (_selectedColor == null){
      _selectedColor = Color(Colors.red.value);
    }
  }
  Color getCategoryColor(int catColor){
    if(catColor != null){
      return Color(catColor);
    } else {
      return Colors.black;
    }
  }
  _editCategory(BuildContext context, categoryID) async{
    category = await _categoryService.readCategoryById(categoryID);
    setState(() {
        _editCategoryNameController.text = category[0]["name"]??"No name"  ;
        _editCategoryDescriptionController.text = category[0]["description"]??"No description"  ;
        _selectedColor = Color(category[0]["color"]);
    });
    _editFormDialog(context);
  }

  _showFormDialog(BuildContext context) {
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
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  _category.color = _selectedColor.value;
                  var result = await _categoryService.saveCategory(_category);
                  if (result>0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackbar(Text("snackbar_saved").tr());
                  }
                },
                child: Text("button_save").tr(),
                color: Theme.of(context).primaryColor,
              ),
            ],
            title: Text("categories_add").tr(),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: "category_hint".tr(), labelText: "category_name".tr()),
                  ),
                  TextField(
                    controller: _categoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: "description_hint".tr(),
                        labelText: "description_name".tr()),
                  ),
                  DropdownButtonFormField(
                    items: _categoryColors,
                    value: _selectedColor,
                    hint: Text("color_name").tr(),
                    onChanged: (value) {
                      setState(() {
                        _selectedColor = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _editFormDialog(BuildContext context) {
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
                  _category.id = category[0]["id"];
                  _category.name = _editCategoryNameController.text;
                  _category.description = _editCategoryDescriptionController.text;
                  _category.color = _selectedColor.value;
                  var result = await _categoryService.updateCategory(_category);
                  if (result>0) {
                    Navigator.pop(context);
                    getAllCategories();
                    _showSuccessSnackbar(Text("snackbar_updated").tr());
                  }
                },
                child: Text("button_update").tr(),
                color: Theme.of(context).primaryColor,
              ),
            ],
            title: Text("categories_edit").tr(),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryNameController,
                    decoration: InputDecoration(
                        hintText: "category_hint".tr(), labelText: "category_name".tr()),
                  ),
                  TextField(
                    controller: _editCategoryDescriptionController,
                    decoration: InputDecoration(
                        hintText: "description_hint".tr(),
                        labelText: "description_name".tr()),
                  ),
                  DropdownButtonFormField(
                    items: _categoryColors,
                    value: _selectedColor,
                    hint: Text("color_name").tr(),
                    onChanged: (value) {
                      setState(() {
                        _selectedColor = value;
                      });
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  _deleteFormDialog(BuildContext context, int categoryId) {
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
                  var result = await _categoryService.deleteCategory(categoryId);
                  if (result>0) {
                    Navigator.pop(context);
                    setState(() {
                      getAllCategories();
                    });

                    _showSuccessSnackbar(Text("snackbar_deleted").tr());
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

  _showSuccessSnackbar(message){
    var _snackBar = SnackBar(content: message);
    _globalKey.currentState.showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _globalKey,
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
        title: Text("categories").tr(),
      ),
      body: ListView.builder(
        itemCount: _categoriesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Card(
              elevation: 8.0,
              child: ListTile(
                leading: IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    _editCategory(context, _categoriesList[index].id);
                  },
                ),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(_categoriesList[index].name, style: TextStyle(fontSize:20.0,color: getCategoryColor(_categoriesList[index].color)),),
                    IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _deleteFormDialog(context,_categoriesList[index].id);
                      },
                      color: Colors.red,
                    )
                  ],
                ),
                subtitle: Text(_categoriesList[index].description),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showFormDialog(context),
      ),
    );
  }

}
