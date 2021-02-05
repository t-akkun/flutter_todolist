library integration_tests;

import 'package:flutter/material.dart';
import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:test/test.dart';

void main() {
  group('Todo List', () {
    FlutterDriver driver;
    final addButton = find.byValueKey('addButton');
    final titleForm = find.byValueKey('titleForm');
    final noteForm = find.byValueKey('noteForm');
    final finishButton = find.byValueKey('finishButton');
    final deleteButton = find.byValueKey('deleteButton');

    Future<void> setNewTodo(String title, String note) async {
      await driver.tap(addButton);
      await driver.tap(titleForm);
      await driver.enterText(title);
      await driver.tap(noteForm);
      await driver.enterText(note);
      await driver.tap(finishButton);
    }

    Future<bool> textExists(String text) async {
      try {
        await driver.waitFor(find.text(text),
            timeout: const Duration(seconds: 3));

        return true;
      } catch (_) {
        return false;
      }
    }

    // Connect to the Flutter driver before running any tests.
    setUpAll(() async {
      driver = await FlutterDriver.connect();
    });

    // Close the connection to the driver after the tests have completed.
    tearDownAll(() async {
      if (driver != null) {
        driver.close();
      }
    });
    test('add Todo', () async {
      await setNewTodo('Add Test', 'Add Note');
      await driver.tap(find.text('Add Test'));
      expect(await driver.getText(find.text('Add Test')), 'Add Test');
      expect(await driver.getText(find.text('Add Note')), 'Add Note');
      await driver.tap(deleteButton);
    });

    test('swipe and delete todo', () async {
      await setNewTodo('Swipe Test', 'Swipe Note');
      await textExists('Swipe Test').then((flag) => expect(flag, true));
      await driver.scroll(
          find.text('Swipe Test'), -500, 0, const Duration(seconds: 1));
      await textExists('Swipe Test').then((flag) => expect(flag, false));
    });
  });
}
