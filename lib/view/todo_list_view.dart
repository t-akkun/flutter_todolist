import 'package:flutter_todolist/view/todo_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_bloc.dart';

class TodoListView extends StatefulWidget {
  final List<Todo> list;
  final int state;

  const TodoListView({@required this.list,@required this.state});

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  //フィルター用
  static const int ALL = 0;
  static const int ACTIVE = 1;
  static const int COMPLETED = 2;
  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    int _showState = widget.state;
    List<Todo> _list = widget.list;
    List<Todo> _filteredList=List();

    //フィルター
    _list.forEach((todo) {
      switch (_showState) {
        case ALL:
          _filteredList.add(todo);
          break;
        case ACTIVE:
          if (!todo.flag) _filteredList.add(todo);
          break;
        case COMPLETED:
          if (todo.flag) _filteredList.add(todo);
          break;
      }
    });
    //Todoリストの一覧表示
    return ListView.builder(
      itemCount: _filteredList.length,
      itemBuilder: (BuildContext context, int index) {
        Todo todo = _filteredList[index];
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
