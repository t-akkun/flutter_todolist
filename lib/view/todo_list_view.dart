import 'package:flutter_todolist/view/todo_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_bloc.dart';

class TodoListView extends StatefulWidget {
  final List<Todo> list;

  const TodoListView({@required this.list});

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    final TodoBloc _bloc = Provider.of<TodoBloc>(context, listen: false);
    List<Todo> _list = widget.list;

    //Todoリストの一覧表示
    return ListView.builder(
      itemCount: _list.length,
      itemBuilder: (BuildContext context, int index) {
        Todo todo = _list[index];
        return Dismissible(
          key: Key(todo.id),
          onDismissed: (direction) {
            _bloc.delete(todo.id);
          },
          child: ListTile(
            leading: Checkbox(
                key: Key(todo.id),
                value: todo.flag,
                onChanged: (flag) {
                  todo.flag = flag;
                  _bloc.update(todo);
                }),
            title: Text(
              todo.title,
              key: Key(todo.id),
              style: Theme.of(context).textTheme.headline6,
            ),
            subtitle: Text(
              todo.note,
              key: Key(todo.id),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: Theme.of(context).textTheme.subtitle1,
            ),
            onTap: () {
              //詳細画面へ移動
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          TodoDetailView(todo: todo, bloc: _bloc)));
            },
          ),
        );
      },
    );
  }
}
