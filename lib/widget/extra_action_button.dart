import 'package:flutter/material.dart';

class ExtraActionsButton extends StatelessWidget {
  final PopupMenuItemSelected onSelected;
  final bool isAllComplete;
  final bool hasCompleted;
  //追加アクション用
  static const int MARK_ALL = 0;
  static const int CLEAR = 1;

  ExtraActionsButton({
    this.onSelected,
    this.isAllComplete = false,
    this.hasCompleted = true,
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem(
            child: isAllComplete
                ? Text("Mark all incomplete")
                : Text("Mark all complete"),
            value: MARK_ALL),
        if (hasCompleted)
          PopupMenuItem(child: Text("Clear Completed"), value: CLEAR),
      ],
      icon: Icon(Icons.keyboard_control),
    );
  }
}
