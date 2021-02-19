import 'package:flutter/material.dart';

class FilterButton extends StatelessWidget {
  final PopupMenuItemSelected onSelected;

  static const int ALL = 0;
  static const int ACTIVE = 1;
  static const int COMPLETED = 2;

  int showState = ALL;

  FilterButton({this.onSelected, this.showState});

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      onSelected: onSelected,
      itemBuilder: (BuildContext context) => <PopupMenuEntry<int>>[
        PopupMenuItem(
            child: Text("Show All",
                style: TextStyle(
                    color: showState == ALL ? Colors.blue : Colors.black)),
            value: ALL),
        PopupMenuItem(
            child: Text("Show Active",
                style: TextStyle(
                    color: showState == ACTIVE ? Colors.blue : Colors.black)),
            value: ACTIVE),
        PopupMenuItem(
            child: Text("Show Completed",
                style: TextStyle(
                    color:
                        showState == COMPLETED ? Colors.blue : Colors.black)),
            value: COMPLETED),
      ],
      icon: Icon(Icons.filter_list),
    );
  }
}
