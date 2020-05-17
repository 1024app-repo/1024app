import 'package:flutter/material.dart';

class MyListTitle extends StatelessWidget {
  const MyListTitle(
      {Key key,
      this.onTap,
      this.leading,
      @required this.title,
      this.content,
      this.textAlign: TextAlign.start,
      this.maxLines: 1,
      this.elevation: 0.6})
      : super(key: key);

  final GestureTapCallback onTap;
  final Widget leading;
  final Widget title;
  final Widget content;
  final TextAlign textAlign;
  final int maxLines;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(15),
        color: Theme.of(context).backgroundColor,
        child: Row(
          children: <Widget>[
            Offstage(
              offstage: leading == null,
              child: Padding(
                padding: EdgeInsets.only(right: 15),
                child: leading,
              ),
            ),
            title,
            const Spacer(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 0),
                child: content,
              ),
            ),
            Opacity(
              // 无点击事件时，隐藏箭头图标
              opacity: onTap == null ? 0 : 1,
              child: Padding(
                padding: EdgeInsets.only(top: maxLines == 1 ? 0.0 : 2.0),
                child: Icon(
                  Icons.navigate_next,
                  color: Color(0xFF999999),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
