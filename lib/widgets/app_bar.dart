import 'package:flutter/material.dart';

class MyAppBar extends AppBar {
  MyAppBar({
    Key key,
    @required String title,
    Widget leading,
    List<Widget> actions,
    bool automaticallyImplyLeading = true,
  }) : super(
          key: key,
          title: Text(
            title,
            style: TextStyle(
              fontSize: 18,
//              color: Colors.black,
            ),
          ),
          leading: leading,
          actions: actions,
//          elevation: 0.5,
          automaticallyImplyLeading: automaticallyImplyLeading,
//          backgroundColor: ,

//          iconTheme: IconThemeData(color: Colors.black),
        );
}
