import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/db_provider.dart';
import 'package:rxdart/rxdart.dart';

class TodoBloc {

  final BehaviorSubject<List<Todo>> _todoController = BehaviorSubject<List<Todo>>();
  Stream<List<Todo>> get todoStream => _todoController.stream;

  getTodos() async {
    _todoController.sink.add(await DBProvider.db.getAllTodos());
  }

  TodoBloc() {
    getTodos();
  }

  dispose() {
    _todoController.close();
  }

  create(Todo todo) {
    todo.assignUUID();
    DBProvider.db.createTodo(todo);
    getTodos();
  }

  update(Todo todo) {
    DBProvider.db.updateTodo(todo);
    getTodos();
  }

  delete(String id) {
    DBProvider.db.deleteTodo(id);
    getTodos();
  }
}