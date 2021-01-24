import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_bloc.dart';
import 'package:flutter_todolist/view/todo_add_view.dart';

class TodoStatsView extends StatelessWidget {
  //作業状況ページ
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Vanilla Example"),
      ),
      body: StreamBuilder<List<Todo>>(
        stream: _bloc.todoStream,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          if (snapshot.hasData) {
            //作業状況の確認
            int _numActive = 0;
            int _numCompleted = 0;
            snapshot.data.forEach((todo) {
              if (todo.flag) {
                _numCompleted++;
              } else {
                _numActive++;
              }
            });
            return Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                //完了済みリスト数
                Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Completed Todos",
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "$_numCompleted",
                      style: Theme.of(context).textTheme.subtitle1,
                    )),
                //作業中リスト数
                Padding(
                    padding: EdgeInsets.only(bottom: 8.0),
                    child: Text(
                      "Active Todos",
                      style: Theme.of(context).textTheme.headline6,
                    )),
                Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      "$_numActive",
                      style: Theme.of(context).textTheme.subtitle1,
                    )),
              ],
            ));
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
      //Todoリストの追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) =>
                      TodoAddView(todo: Todo.newTodo(), bloc: _bloc)));
        },
        child: Icon(Icons.add, size: 40),
      ),
    );
  }
}