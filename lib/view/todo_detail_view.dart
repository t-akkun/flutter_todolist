import 'package:flutter/material.dart';
import 'package:flutter_todolist/view/todo_add_view.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_bloc.dart';

class TodoDetailView extends StatefulWidget {
  //詳細画面
  final Todo todo;
  final TodoBloc bloc;

  const TodoDetailView({this.todo, this.bloc});

  @override
  _TodoDetailViewState createState() => _TodoDetailViewState();
}

class _TodoDetailViewState extends State<TodoDetailView> {
  Todo todo;
  TodoBloc bloc;

  @override
  Widget build(BuildContext context) {
    //初回のみ初期化
    if (todo == null) {
      todo = widget.todo;
      bloc = widget.bloc;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo Details'),
        actions: [
          IconButton(
            key: Key('deleteButton'),
            icon: Icon(Icons.delete),
            onPressed: () {
              bloc.delete(todo.id);
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: [
            //詳細画面の表示
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 8.0),
                  child: Checkbox(
                    value: todo.flag,
                    onChanged: (flag) {
                      setState(() {
                        todo.flag = flag;
                        print(flag);
                        bloc.update(todo);
                      });
                    },
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(
                          top: 8.0,
                          bottom: 16.0,
                        ),
                        child: Text(
                          todo.title,
                          style: Theme.of(context).textTheme.headline5,
                        ),
                      ),
                      Text(
                        todo.note,
                        style: Theme.of(context).textTheme.subtitle1,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      //編集ボタン
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.edit),
        onPressed: () async {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return TodoAddView(
                  todo: todo,
                  bloc: bloc,
                );
              },
            ),
            //編集後に引数で更新
          ).then((newTodo) {
            setState(() {
              if (newTodo != null) {
                todo = newTodo;
              }
            });
          });
        },
      ),
    );
  }
}
