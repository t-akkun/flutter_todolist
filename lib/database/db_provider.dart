import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DBProvider {
  DBProvider._();
  static final DBProvider db = DBProvider._();

  static Database _database;
  static final String _tableName = "TodoList";


  Future<Database> get database async {
    if (_database != null)
      return _database;

    // DBがなかったら作る
    _database = await initDB();
    return _database;
  }

  Future<Database> initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, "TodoDB.db");

    return await openDatabase(path, version: 2, onCreate: _createTable);
  }

  Future<void> _createTable(Database db, int version) async {
    return await db.execute(
      "CREATE TABLE $_tableName ("
      "id TEXT PRIMARY KEY,"
      "title TEXT,"
      "flag INTEGER,"
      "note TEXT"
      ")"
    );
  }

  Future<int> createTodo(Todo todo) async {
    final db = await database;
    var res = await db.insert(_tableName, todo.toMap());
    return res;
  }

  Future<List<Todo>> getAllTodos() async {
    final db = await database;
    var res = await db.query(_tableName);
    List<Todo> list =
        res.isNotEmpty ? res.map((c) => Todo.fromMap(c)).toList() : [];
    return list;
  }

  Future<int> updateTodo(Todo todo) async {
    final db = await database;
    var res  = await db.update(
      _tableName, 
      todo.toMap(),
      where: "id = ?",
      whereArgs: [todo.id]  
    );
    return res;
  }

  Future<int> deleteTodo(String id) async {
    final db = await database;
    var res = db.delete(
      _tableName,
      where: "id = ?",
      whereArgs: [id]
    );
    return res;
  }

}