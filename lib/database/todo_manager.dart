import 'package:flutter/material.dart';
import 'package:flutter_todolist/database/todo.dart';

class TodoManager {
  //フィルター用
  static const int ALL = 0;
  static const int ACTIVE = 1;
  static const int COMPLETED = 2;

  final List<Todo> list;

  TodoManager({@required this.list});

  List<Todo> filteredTodo(int state) => list.where((todo) {
        switch (state) {
          case ACTIVE:
            return !todo.flag;
          case COMPLETED:
            return todo.flag;
          case ALL:
          default:
            return true;
        }
      }).toList();

  List<Todo> markAllComplete() {
    final allCompleted = isAllComplete;

    list.forEach((todo) => todo.flag = !allCompleted);
    return list;
  }

  List<Todo> get getList => list != null ? list : [];

  bool get isAllComplete => list.every((todo) => todo.flag);

  bool get hasCompleted => list.any((todo) => todo.flag);

  int get getActiveNum => list.fold(0, (sum, todo) => !todo.flag ? ++sum : sum);

  int get getCompletedNum =>
      list.fold(0, (sum, todo) => todo.flag ? ++sum : sum);
}
