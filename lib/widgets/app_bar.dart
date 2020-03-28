import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({Key key, @required String title, List<Widget> actions})
      : super(
          key: key,
          title: Text(
            title,
            style: TextStyle(fontSize: 18),
          ),
          actions: actions,
          elevation: 1.0,
        );
}
