
import 'package:flutter/material.dart';
import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/services/category_service.dart';

class CategoryProvider with ChangeNotifier{
  CategoryService _categoryService = CategoryService();
  List<Category> _categoriesList = [];


  CategoryProvider.initialize(){
    loadCategories();
  }

  get categoriesList => _categoriesList;

  loadCategories() async{
    _categoriesList.clear();
    var categories = await _categoryService.readCategories();
    categories.forEach((category) {
        var categoryModel = Category();
        categoryModel.name = category["name"];
        categoryModel.description = category["description"];
        categoryModel.id = category["id"];
        categoryModel.color = category["color"];
        _categoriesList.add(categoryModel);
    });
    notifyListeners();
  }
  updateCategory(Category category) async{
    _categoryService.updateCategory(category);
    _categoriesList[_categoriesList.indexWhere((element) => element.id == category.id)] = category;
    notifyListeners();
  }
  saveCategory(Category category) async{
    _categoryService.saveCategory(category);
    //_categoriesList.add(category);
    loadCategories();
    notifyListeners();
  }
  deleteCategory(Category category) async{
    _categoryService.deleteCategory(category);
    _categoriesList.remove(category);
    notifyListeners();
  }

}