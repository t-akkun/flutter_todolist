import 'package:flutter_todolist/view/todo_add_view.dart';
import 'package:flutter_todolist/view/todo_list_view.dart';
import 'package:flutter_todolist/view/todo_stats_view.dart';
import 'package:flutter_todolist/database/todo.dart';
import 'package:flutter/material.dart';
import 'database/todo_bloc.dart';
import 'package:provider/provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  static const LIST_VIEW = 0;
  static const STATS_VIEW = 1;
  int _index = LIST_VIEW;

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

  var _routes = [TodoListView(), TodoStatsView()];

  @override
  Widget build(BuildContext context) {
    final _bloc = Provider.of<TodoBloc>(context, listen: false);
    //フィルター用
    List<Todo> _allTodo = List();
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
            isAllComplete = true;
            isClear = false;
            if (snapshot.hasData) {
              _allTodo = snapshot.data;
              _allTodo.forEach((todo) {
                //アクションボタン用のチェック
                if (!todo.flag) isAllComplete = false;
                if (todo.flag) isClear = true;
              });
              return _index == LIST_VIEW ? TodoListView(list:snapshot.data,state:_showState) : TodoStatsView(list:snapshot.data);
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
