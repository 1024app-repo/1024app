import 'package:flutter/material.dart';

class MyListTitle extends StatelessWidget {
  const MyListTitle(
      {Key key,
      this.onTap,
      this.leading,
      @required this.title,
      this.content: "",
      this.textAlign: TextAlign.start,
      this.maxLines: 1,
      this.elevation: 0.6})
      : super(key: key);

  final GestureTapCallback onTap;
  final Widget leading;
  final Widget title;
  final String content;
  final TextAlign textAlign;
  final int maxLines;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(left: 15.0),
        padding: const EdgeInsets.fromLTRB(0, 15.0, 15.0, 15.0),
        constraints:
            BoxConstraints(maxHeight: double.infinity, minHeight: 50.0),
        width: double.infinity,
        decoration: elevation > 0
            ? BoxDecoration(
                border: Border(
                  bottom: Divider.createBorderSide(context, width: elevation),
                ),
              )
            : null,
        child: Row(
          //为了数字类文字居中
          crossAxisAlignment: maxLines == 1
              ? CrossAxisAlignment.center
              : CrossAxisAlignment.start,
          children: <Widget>[
            leading == null
                ? Container()
                : Padding(
                    padding: EdgeInsets.only(right: 15),
                    child: leading,
                  ),
            title,
            const Spacer(),
            Expanded(
              flex: 4,
              child: Padding(
                padding: const EdgeInsets.only(right: 8.0, left: 16.0),
                child: Text(
                  content,
                  maxLines: maxLines,
                  textAlign: maxLines == 1 ? TextAlign.right : textAlign,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Color(0xFF999999),
                    fontSize: 14,
                  ),
                ),
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
