import 'package:flutter/material.dart';
import 'package:flutter_todolist/database/todo_manager.dart';

class TodoStatsView extends StatelessWidget {
  final TodoManager list;

  TodoStatsView({@required this.list});

  //作業状況ページ
  @override
  Widget build(BuildContext context) {

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
              list.getCompletedNum.toString(),
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
              list.getActiveNum.toString(),
              style: Theme.of(context).textTheme.subtitle1,
            )),
      ],
    ));
  }
}
