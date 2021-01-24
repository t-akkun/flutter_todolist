import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';

class Todo {
  String id;
  String title;
  bool flag;
  String note;

  Todo(
      {this.id, @required this.title, @required this.flag, @required this.note});

  Todo.newTodo() {
    title = "";
    flag = false;
    note = "";
  }

  assignUUID() {
    id = Uuid().v4();
  }

  factory Todo.fromMap(Map<String, dynamic> json) =>
      Todo(
          id: json["id"],
          title: json["title"],
          //SQLiteではboolがないからintを変換
          flag: json["flag"] == 0 ? true : false,
          note: json["note"]
      );

  Map<String, dynamic> toMap() =>
      {
        "id": id,
        "title": title,
        "flag": flag ? 0 : 1,
        "note": note
      };
}