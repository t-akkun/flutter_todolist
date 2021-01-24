import 'package:flutter_todolist/view/todo_list_view.dart';
import 'package:flutter_todolist/view/todo_stats_view.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen();

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

var _routes = [TodoListView(),TodoStatsView()];

class _HomeScreenState extends State<HomeScreen> {
  static const LIST_VIEW=0;
  static const STATS_VIEW=1;
  int _index = LIST_VIEW;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _routes.elementAt(_index),
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
