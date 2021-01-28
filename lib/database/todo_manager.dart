import 'package:flutter/material.dart';
import 'package:flutter_todolist/database/todo.dart';

class TodoManager {
  //フィルター用
  static const int ALL = 0;
  static const int ACTIVE = 1;
  static const int COMPLETED = 2;

  List<Todo> _list;

  TodoManager(List<Todo> list) {
    this._list = list;
  }

  List<Todo> filteredTodo(int state) =>
      _list.where((todo) {
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
    final bool allCompleted = isAllComplete;

    _list.forEach((todo) => todo.flag = !allCompleted);
    return _list;
  }

  List<Todo> get getList => _list != null ? _list : [];

  bool get isAllComplete => _list.every((todo) => todo.flag);

  bool get hasCompleted => _list.any((todo) => todo.flag);

  int get getActiveNum => _list.fold(0, (sum, todo) => !todo.flag ? ++sum : sum);

  int get getCompletedNum =>
      _list.fold(0, (sum, todo) => todo.flag ? ++sum : sum);
}
