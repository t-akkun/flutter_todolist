import 'package:flutter_todolist/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todolist/database/todo_bloc.dart';

void main() => runApp(TodoApp());

class TodoApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Vanilla Example',
      home: Provider<TodoBloc>(
          create: (context) => new TodoBloc(),
          dispose: (context, bloc) => bloc.dispose(),
          child: HomeScreen()),
    );
  }
}
