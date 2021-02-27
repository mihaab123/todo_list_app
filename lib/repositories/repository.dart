
import 'package:sqflite/sqflite.dart';
import 'package:todo_list_app/repositories/database_connection.dart';

class Repository{
  DatabaseConnection _databaseConnection;
  static Database _database;
  Repository(){
    _databaseConnection = DatabaseConnection();
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await _databaseConnection.setDatabase();
    }
    return _database;
  }
  // insert data to table
  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }
  // read data from table
  readData(table) async{
    var connection = await database;
    return await connection.query(table);
  }
  // read data from table by id
  readDataById(table, itemID) async {
    var connection = await database;
    return await connection.query(table, where: "id = ?", whereArgs: [itemID]);
  }

  // read data from table by column name
  readDataByColumnName(table, columnName, columnValue) async {
    var connection = await database;
    return await connection.query(table, where: "$columnName = ?", whereArgs: [columnValue]);
  }

  // update data to table
  updateData(table, data) async {
    var connection = await database;
    return await connection.update(table, data, where: "id = ?", whereArgs: [data["id"]]);
  }

  deleteData(table, itemID) async{
    var connection = await database;
    //return await connection.delete(table, where: "id = ?", whereArgs: [itemID]);
    return await connection.rawDelete("DELETE FROM $table where id = $itemID");
  }
}