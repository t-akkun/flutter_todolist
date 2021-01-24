import 'package:flutter_todolist/view/todo_detail_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_todolist/view/todo_add_view.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_bloc.dart';

class TodoListView extends StatefulWidget {
  const TodoListView();

  @override
  _TodoListViewState createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  //フィルター用
  int _showState = 0;
  static const int ALL = 0;
  static const int ACTIVE = 1;
  static const int COMPLETED = 2;

  //追加アクション用
  static const int MARK_ALL = 0;
  static const int CLEAR = 1;

  bool isAllComplete = true;
  bool isClear = false;

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    //フィルター用
    List<Todo> _allTodo = List();
    List<Todo> _todoFilter = List();
    //一括チェック、解除
    void _markALL() {
      if (_allTodo != null) {
        setState(() {
          _allTodo.forEach((todo) {
            isAllComplete ? todo.flag = false : todo.flag = true;
            _bloc.update(todo);
          });
        });
      }
    }
    //終了したタスクの削除
    void _markClear() {
      if (_allTodo != null) {
        setState(() {
          _allTodo.forEach((todo) {
            if (todo.flag) _bloc.delete(todo.id);
          });
        });
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text("Vanilla Example"), actions: [
        //フィルターのアクションボタン
        PopupMenuButton(
          onSelected: (state) {
            setState(() {
              _showState = state;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem(
                child: Text("Show All",
                    style: TextStyle(
                        color: _showState == ALL ? Colors.blue : Colors.black)),
                value: ALL),
            PopupMenuItem(
                child: Text("Show Active",
                    style: TextStyle(
                        color:
                            _showState == ACTIVE ? Colors.blue : Colors.black)),
                value: ACTIVE),
            PopupMenuItem(
                child: Text("Show Completed",
                    style: TextStyle(
                        color: _showState == COMPLETED
                            ? Colors.blue
                            : Colors.black)),
                value: COMPLETED),
          ],
          icon: Icon(Icons.filter_list),
        ),
        //追加アクションのアクションボタン
        PopupMenuButton(
          onSelected: (state) {
            setState(() {
              if (state == MARK_ALL) _markALL();
              if (state == CLEAR) _markClear();
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem(
                child: isAllComplete
                    ? Text("Mark all incomplete")
                    : Text("Mark all complete"),
                value: MARK_ALL),
            if (isClear)
              PopupMenuItem(child: Text("Clear Completed"), value: CLEAR),
          ],
          icon: Icon(Icons.keyboard_control),
        ),
      ]),
      body: StreamBuilder<List<Todo>>(
        stream: _bloc.todoStream,
        builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
          _todoFilter = List();
          isAllComplete = true;
          isClear = false;
          if (snapshot.hasData) {
            _allTodo = snapshot.data;
            _allTodo.forEach((todo) {
              //アクションボタン用のチェック
              if (!todo.flag) isAllComplete = false;
              if (todo.flag) isClear = true;
              //フィルター
              switch (_showState) {
                case ALL:
                  _todoFilter.add(todo);
                  break;
                case ACTIVE:
                  if (!todo.flag) _todoFilter.add(todo);
                  break;
                case COMPLETED:
                  if (todo.flag) _todoFilter.add(todo);
                  break;
              }
            });
            //Todoリストの一覧表示
            return ListView.builder(
              itemCount: _todoFilter.length,
              itemBuilder: (BuildContext context, int index) {
                Todo todo = _todoFilter[index];
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
