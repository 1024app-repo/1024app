import 'package:flutter/material.dart';

class ColorfulTag extends StatelessWidget {
  final String title;
  final Color color;
  final double fontSize;

  const ColorfulTag({Key key, this.title, this.color, this.fontSize})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 2.0, right: 2.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(color: color),
        child: Text(
          title,
          style: TextStyle(
            fontSize: fontSize,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
