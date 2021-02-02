// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_manager.dart';
import 'package:flutter_todolist/main.dart';

void main() {
  test('TodoManagerのチェック', () {
    List<Todo> list = [
      Todo(title: 'a', flag: false, note: 'a'),
      Todo(title: 'b', flag: false, note: 'b'),
      Todo(title: 'c', flag: true, note: 'c')
    ];
    TodoManager manager = TodoManager(list);
    expect(manager.hasCompleted, true);
    expect(manager.isAllComplete, false);
    expect(manager.getActiveNum, 2);
    expect(manager.getCompletedNum, 1);
  });
  test('markAllCompleteのチェック', () {
    List<Todo> list = [
      Todo(title: 'a', flag: false, note: 'a'),
      Todo(title: 'b', flag: false, note: 'b'),
      Todo(title: 'c', flag: true, note: 'c')
    ];
    TodoManager manager = TodoManager(list);
    manager.markAllComplete();
    expect(manager.hasCompleted, true);
    expect(manager.isAllComplete, true);
    expect(manager.getActiveNum, 0);
    expect(manager.getCompletedNum, 3);
  });
  test('markAllCompleteの2度目チェック', () {
    List<Todo> list = [
      Todo(title: 'a', flag: false, note: 'a'),
      Todo(title: 'b', flag: false, note: 'b'),
      Todo(title: 'c', flag: true, note: 'c')
    ];
    TodoManager manager = TodoManager(list);
    manager.markAllComplete();
    manager.markAllComplete();
    expect(manager.hasCompleted, false);
    expect(manager.isAllComplete, false);
    expect(manager.getActiveNum, 3);
    expect(manager.getCompletedNum, 0);
  });

  testWidgets('Todo追加テスト', (WidgetTester tester) async {
    final addButton = find.byKey(Key('addButton'));
    final finishButton = find.byKey(Key('finishButton'));
    final titleForm = find.byKey(Key('titleForm'));
    final noteForm = find.byKey(Key('noteForm'));

    await tester.pumpWidget(TodoApp());

    await tester.tap(addButton);
    await tester.pumpAndSettle();
    await tester.enterText(titleForm, 'titleテスト');
    await tester.enterText(noteForm, 'noteテスト');
    await tester.tap(finishButton);
    await tester.pump();
    expect(find.text('Vanilla Example'), findsOneWidget);
    expect(find.text('titleテスト'), findsOneWidget);
    expect(find.text('noteテスト'), findsOneWidget);
  });
}
