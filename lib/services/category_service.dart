import 'package:todo_list_app/models/category.dart';
import 'package:todo_list_app/repositories/repository.dart';

class CategoryService {
  Repository _repository;

  CategoryService() {
    _repository = Repository();
  }
  saveCategory(Category category) async {
    return await _repository.insertData("categories", category.toMap());
  }

  readCategories() async {
    return await _repository.readData("categories");
  }

  readCategoryById(categoryID) async {
    return await _repository.readDataById("categories", categoryID);
  }

  updateCategory(Category category) async {
    return await _repository.updateData("categories", category.toMap());
  }

  deleteCategory(categoryID) async {
    return await _repository.deleteData("categories", categoryID);
  }
}
