import 'package:flutter_todolist/view/todo_add_view.dart';
import 'package:flutter_todolist/view/todo_list_view.dart';
import 'package:flutter_todolist/view/todo_stats_view.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter_todolist/database/todo_manager.dart';
import 'package:flutter/material.dart';
import 'database/todo_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const int LIST_VIEW = 0;

  // static const int STATS_VIEW = 1;
  int _index = LIST_VIEW;

  //フィルター用
  int _showState = 0;
  static const int ALL = 0;
  static const int ACTIVE = 1;
  static const int COMPLETED = 2;

  //追加アクション用
  static const int MARK_ALL = 0;
  static const int CLEAR = 1;

  @override
  Widget build(BuildContext context) {
    final TodoBloc _bloc = Provider.of<TodoBloc>(context, listen: false);
    TodoManager _manager;

    return Scaffold(
      appBar: AppBar(title: Text("Vanilla Example"), actions: [
        //フィルターのアクションボタン
        if (_index == LIST_VIEW)
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
                          color:
                              _showState == ALL ? Colors.blue : Colors.black)),
                  value: ALL),
              PopupMenuItem(
                  child: Text("Show Active",
                      style: TextStyle(
                          color: _showState == ACTIVE
                              ? Colors.blue
                              : Colors.black)),
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
              if (state == MARK_ALL)
                _manager.markAllComplete().forEach((todo) {
                  _bloc.update(todo);
                });
              if (state == CLEAR)
                _manager.getList.forEach((todo) {
                  if (todo.flag) _bloc.delete(todo.id);
                });
              ;
            });
          },
          itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
            PopupMenuItem(
                child: _manager.isAllComplete
                    ? Text("Mark all incomplete")
                    : Text("Mark all complete"),
                value: MARK_ALL),
            if (_manager.hasCompleted)
              PopupMenuItem(child: Text("Clear Completed"), value: CLEAR),
          ],
          icon: Icon(Icons.keyboard_control),
        ),
      ]),
      body: StreamBuilder<List<Todo>>(
          stream: _bloc.todoStream,
          builder: (BuildContext context, AsyncSnapshot<List<Todo>> snapshot) {
            if (snapshot.hasData) {
              _manager = TodoManager(snapshot.data);
              return _index == LIST_VIEW
                  ? TodoListView(list: _manager.filteredTodo(_showState))
                  : TodoStatsView(list: _manager);
            }
            return Center(child: CircularProgressIndicator());
          }),
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
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
              color: Colors.black87,
            ),
            label: 'Todos',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.show_chart,
              color: Colors.black87,
            ),
            label: 'Stats',
          ),
        ],
        currentIndex: _index,
        onTap: (index) {
          setState(() {
            _index = index;
          });
        },
      ),
    );
  }
}
