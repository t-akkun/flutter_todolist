import 'package:flutter/material.dart';
import 'package:flutter_todolist/database/todo_manager.dart';

class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected onSelected;
  bool _isAllComplete;
  bool _hasCompleted;
  //追加アクション用
  static const int MARK_ALL = 0;
  static const int CLEAR = 1;

  ExtraActionsButton({@required this.onSelected});

  void setFlag(TodoManager manager) {
    _isAllComplete = manager.isAllComplete;
    _hasCompleted = manager.hasCompleted;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem(
            child: _isAllComplete
                ? Text("Mark all incomplete")
                : Text("Mark all complete"),
            value: MARK_ALL),
        if (_hasCompleted)
          PopupMenuItem(child: Text("Clear Completed"), value: CLEAR),
      ],
      icon: Icon(Icons.keyboard_control),
    );
  }
}
