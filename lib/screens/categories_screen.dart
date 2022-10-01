import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/providers/category_provider.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:provider/provider.dart';

import 'home_screen.dart';

class CategoriesScreen extends StatefulWidget {
  @override
  _CategoriesScreenState createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  var _categoryNameController = TextEditingController();
  var _categoryDescriptionController = TextEditingController();
  var _category = Category();
  //var _categoryService = CategoryService();
  var _editCategoryNameController = TextEditingController();
  var _editCategoryDescriptionController = TextEditingController();
  var category;
  final GlobalKey<ScaffoldState> _globalKey = GlobalKey<ScaffoldState>();
  var _categoryColors = List<DropdownMenuItem>();
  var _selectedColor;
  SlidableController slidableController;
  Animation<double> _rotationAnimation;
  Color _fabColor = Colors.blue;

  @override
  void initState() {
    slidableController = SlidableController(
      onSlideAnimationChanged: handleSlideAnimationChanged,
      onSlideIsOpenChanged: handleSlideIsOpenChanged,
    );
    super.initState();
    //getAllCategories();
    getColors();
  }

  void handleSlideAnimationChanged(Animation<double> slideAnimation) {
    setState(() {
      _rotationAnimation = slideAnimation;
    });
  }

  void handleSlideIsOpenChanged(bool isOpen) {
    setState(() {
      _fabColor = isOpen ? Colors.green : Colors.blue;
    });
  }

  /*getAllCategories() async {
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
  }*/
  getColors() {
    _categoryColors.add(
      DropdownMenuItem(child: Text("blue"), value: Color(Colors.blue.value)),
    );
    _categoryColors.add(
      DropdownMenuItem(child: Text("red"), value: Color(Colors.red.value)),
    );
    _categoryColors.add(
      DropdownMenuItem(child: Text("green"), value: Color(Colors.green.value)),
    );
    _categoryColors.add(
      DropdownMenuItem(
          child: Text("yellow"), value: Color(Colors.yellow.value)),
    );
    _categoryColors.add(
      DropdownMenuItem(
          child: Text("orange"), value: Color(Colors.orange.value)),
    );
    _categoryColors.add(
      DropdownMenuItem(
          child: Text("purple"), value: Color(Colors.purple.value)),
    );
    if (_selectedColor == null) {
      _selectedColor = Color(Colors.red.value);
    }
  }

  Color getCategoryColor(int catColor) {
    if (catColor != null) {
      return Color(catColor);
    } else {
      return Colors.black;
    }
  }

  _editCategory(
      BuildContext context, category, CategoryProvider categoryProvider) async {
    //category = await _categoryService.readCategoryById(categoryID);
    setState(() {
      _editCategoryNameController.text = category[0]["name"] ?? "No name";
      _editCategoryDescriptionController.text =
          category[0]["description"] ?? "No description";
      _selectedColor = Color(category[0]["color"]);
    });
    _editFormDialog(context, categoryProvider);
  }

  _showFormDialog(BuildContext context, CategoryProvider categoryProvider) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel").tr(),
                //color: Colors.red,
              ),
              TextButton(
                onPressed: () async {
                  _category.name = _categoryNameController.text;
                  _category.description = _categoryDescriptionController.text;
                  _category.color = _selectedColor.value;
                  //var result = await _categoryService.saveCategory(_category);
                  categoryProvider.saveCategory(_category);
                  //if (result>0) {
                  Navigator.pop(context);
                  //getAllCategories();
                  _showSuccessSnackbar(Text("snackbar_saved").tr());
                  //}
                },
                child: Text("button_save").tr(),
                //color: Theme.of(context).primaryColor,
              ),
            ],
            title: Text("categories_add").tr(),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _categoryNameController,
                    decoration: InputDecoration(
                        hintText: "category_hint".tr(),
                        labelText: "category_name".tr()),
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

  _editFormDialog(BuildContext context, CategoryProvider categoryProvider) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel").tr(),
                //color: Colors.red,
              ),
              TextButton(
                onPressed: () async {
                  _category.id = category[0]["id"];
                  _category.name = _editCategoryNameController.text;
                  _category.description =
                      _editCategoryDescriptionController.text;
                  _category.color = _selectedColor.value;
                  categoryProvider.updateCategory(
                      _category); //await _categoryService.updateCategory(_category);
                  //if (result>0) {
                  Navigator.pop(context);
                  //getAllCategories();
                  _showSuccessSnackbar(Text("snackbar_updated").tr());
                  // }
                },
                child: Text("button_update").tr(),
                //color: Theme.of(context).primaryColor,
              ),
            ],
            title: Text("categories_edit").tr(),
            content: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  TextField(
                    controller: _editCategoryNameController,
                    decoration: InputDecoration(
                        hintText: "category_hint".tr(),
                        labelText: "category_name".tr()),
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

  _deleteFormDialog(BuildContext context, Category category,
      CategoryProvider categoryProvider) {
    return showDialog(
        context: context,
        barrierDismissible: true,
        builder: (param) {
          return AlertDialog(
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("cancel").tr(),
                //color: Colors.red,
              ),
              TextButton(
                onPressed: () async {
                  categoryProvider.deleteCategory(category);
                  //var result = await _categoryService.deleteCategory(categoryId);
                  //if (result>0) {
                  Navigator.pop(context);
                  setState(() {
                    //getAllCategories();
                  });

                  _showSuccessSnackbar(Text("snackbar_deleted").tr());
                  //}
                },
                child: Text("button_delete").tr(),
                //color: Theme.of(context).primaryColor,
              ),
            ],
            title: Text("question_deleted").tr(),
          );
        });
  }

  _showSuccessSnackbar(message) {
    var _snackBar = SnackBar(content: message);
    ScaffoldMessenger.of(context).showSnackBar(_snackBar);
  }

  @override
  Widget build(BuildContext context) {
    final categoryProvider = Provider.of<CategoryProvider>(context);
    return Scaffold(
      key: _globalKey,
      appBar: AppBar(
        leading: ElevatedButton(
          onPressed: () => Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => HomeScreen())),
          child: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
          //color: Theme.of(context).primaryColor,
          // elevation: 0.0,
        ),
        title: Text("categories").tr(),
      ),
      body: ListView.builder(
        itemCount: categoryProvider.categoriesList.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: EdgeInsets.only(top: 8.0, left: 16.0, right: 16.0),
            child: Slidable(
              key: Key(categoryProvider.categoriesList[index].id.toString()),
              controller: slidableController,
              direction: Axis.horizontal,
              /*dismissal: SlidableDismissal(
                  child: SlidableDrawerDismissal(),
                  onDismissed: (actionType) {
                    /* _showSnackBar(
                    context,
                    actionType == SlideActionType.primary
                        ? 'Dismiss Archive'
                        : 'Dimiss Delete');
                setState(() {
                  //items.removeAt(index);
                });*/
                  },
                ),*/
              actionPane: _getActionPane(index),
              // actionExtentRatio: 0.25,
              actions: [
                IconSlideAction(
                  caption: 'button_edit'.tr(),
                  color: Colors.blue,
                  icon: Icons.edit,
                  onTap: () {
                    _editCategory(
                        context,
                        categoryProvider.categoriesList[index],
                        categoryProvider);
                  },
                ),
              ],
              secondaryActions: <Widget>[
                IconSlideAction(
                  caption: 'button_delete'.tr(),
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    _deleteFormDialog(
                        context,
                        categoryProvider.categoriesList[index],
                        categoryProvider);
                  },
                ),
              ],
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.0),
                ),
                elevation: 4.0,
                child: ListTile(
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        categoryProvider.categoriesList[index].name,
                        style: TextStyle(
                            fontSize: 20.0,
                            color: getCategoryColor(
                                categoryProvider.categoriesList[index].color)),
                      ),
                    ],
                  ),
                  subtitle:
                      Text(categoryProvider.categoriesList[index].description),
                ),
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () => _showFormDialog(context, categoryProvider),
      ),
    );
  }

  static Widget _getActionPane(int index) {
    switch (index % 4) {
      case 0:
        return SlidableBehindActionPane();
      case 1:
        return SlidableStrechActionPane();
      case 2:
        return SlidableScrollActionPane();
      case 3:
        return SlidableDrawerActionPane();
      default:
        return null;
    }
  }
}
