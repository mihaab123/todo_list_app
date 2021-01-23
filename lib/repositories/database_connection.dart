import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseConnection{
  Future<Database> setDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, "db_todolist_sqflite.db");
    var database = await openDatabase(path, version: 1, onCreate: _createDB);
    return database;
  }
  void _createDB(Database database, int version) async {
    await database.execute(
        "CREATE TABLE categories(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, description TEXT)");
    await database.execute(
        "CREATE TABLE todos(id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT, description TEXT, category TEXT, todoDate TEXT, isFinished INTEGER)");
  }
}