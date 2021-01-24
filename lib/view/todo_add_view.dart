import 'package:flutter/material.dart';
import 'package:flutter_todolist/database/todo.dart';

class TodoAddView extends StatelessWidget {
//Todoリストの追加と編集
  final Todo todo;
  final Todo _newTodo = Todo.newTodo();
  final bloc;
  //validator用
  final _titleKey = GlobalKey<FormState>();

  //追加か編集かチェック
  bool get isEditing => _newTodo.id != null;

  TodoAddView({@required this.todo, this.bloc}) {
    _newTodo.id = todo.id;
    _newTodo.title = todo.title;
    _newTodo.flag = todo.flag;
    _newTodo.note = todo.note;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: isEditing
          ? AppBar(title: Text("Edit Todo"))
          : AppBar(title: Text("Add Todo")),
      body: Container(
        padding: const EdgeInsets.all(30.0),
        child: Column(
          children: <Widget>[_titleTextFormField(), _noteTextFormField()],
        ),
      ),
      //完了ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (_titleKey.currentState.validate()) {
            if (_newTodo.id == null) {
              bloc.create(_newTodo);
            } else {
              bloc.update(_newTodo);
            }
            //詳細画面用の引数
            Navigator.pop(context, _newTodo);
          }
        },
        child:
            isEditing ? Icon(Icons.check, size: 40) : Icon(Icons.add, size: 40),
      ),
    );
  }

  //タイトル入力フォーム
  Widget _titleTextFormField() => Form(
      key: _titleKey,
      child: TextFormField(
        validator: (title) {
          if (title == "") {
            return ('Todoを入力してください。');
          }
          return null;
        },
        decoration: InputDecoration(hintText: "What needs to be done?"),
        initialValue: _newTodo.title,
        onChanged: (title) {
          _newTodo.title = title;
        },
      ));

  //メモ入力フォーム
  Widget _noteTextFormField() => TextFormField(
        decoration: InputDecoration(labelText: "Additional Notes..."),
        initialValue: _newTodo.note,
        maxLines: 3,
        onChanged: (note) {
          _newTodo.note = note;
        },
      );
}
