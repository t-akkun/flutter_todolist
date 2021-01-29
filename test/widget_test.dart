// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_manager.dart';

void main() {
  List<Todo> list = [
    Todo(title: 'a', flag: false),
    Todo(title: 'b', flag: false),
    Todo(title: 'c', flag: true)
  ];
  TodoManager manager = TodoManager(list);

  test('TodoManagerのチェック', () {
    expect(manager.hasCompleted, true);
    expect(manager.isAllComplete, false);
    expect(manager.getActiveNum, 2);
    expect(manager.getCompletedNum, 1);
  });
  test('markAllCompleteのチェック', () {
    manager.markAllComplete();
    expect(manager.hasCompleted, true);
    expect(manager.isAllComplete, true);
    expect(manager.getActiveNum, 0);
    expect(manager.getCompletedNum, 3);
  });
  test('markAllCompleteの2度目チェック', () {
    manager.markAllComplete();
    expect(manager.hasCompleted, false);
    expect(manager.isAllComplete, false);
    expect(manager.getActiveNum, 3);
    expect(manager.getCompletedNum, 0);
  });
}
