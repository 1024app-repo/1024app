import 'package:flutter/material.dart';
import 'package:identicon/identicon.dart';

import '../../api/model.dart';
import '../../pages/detail/page/topic_detail_page.dart';
import '../../util/db_helper.dart';

class TopicItemView extends StatefulWidget {
  final Topic topic;

  TopicItemView(this.topic);

  @override
  _TopicItemViewState createState() => _TopicItemViewState();
}

class _TopicItemViewState extends State<TopicItemView> {
  final dbHelper = DbHelper.instance;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          widget.topic.readTime = new DateTime.now().toString();
        });

        dbHelper.insertOrUpdate(widget.topic);

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new TopicDetailPage(widget.topic),
            maintainState: false,
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: widget.topic.readTime != null
            ? Brightness.dark == Theme.of(context).brightness
                ? Color(0xFF222222)
                : Color(0xFFFFFFE0)
            : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              widget.topic.title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.title.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: <Widget>[
                ClipOval(
                  child: Image.memory(
                    Identicon().generate(widget.topic.author),
                    width: 15,
                    height: 15,
                    gaplessPlayback: true,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  widget.topic.author,
                  textAlign: TextAlign.left,
                  maxLines: 1,
                  style: new TextStyle(
                    fontSize: 13.0,
                    color: Theme.of(context).textTheme.title.color,
                  ),
                ),
                SizedBox(width: 5),
                Text(
                  "${widget.topic.replyTime}",
                  style: TextStyle(
                    color: Theme.of(context).disabledColor,
                    fontSize: 13,
                  ),
                ),
                SizedBox(width: 5),
                Offstage(
                  offstage: !widget.topic.hot,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.0, right: 2.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.redAccent[200],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '熱門',
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: !widget.topic.prime,
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.0, right: 2.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.purpleAccent[200],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '精華',
                        style: TextStyle(fontSize: 8, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Offstage(
                  offstage: widget.topic.publishTime != 'Top-marks',
                  child: Padding(
                    padding: EdgeInsets.only(left: 2.0, right: 2.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.greenAccent[700],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '置頂',
                        style: TextStyle(fontSize: 8.0, color: Colors.white),
                      ),
                    ),
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(left: 4.0),
                  child: new Text(
                    widget.topic.replyCount,
                    style: TextStyle(
                      color: Theme.of(context).disabledColor,
                      fontSize: 13,
                    ),
                  ),
                ),
                Icon(
                  Icons.chat_bubble_outline,
                  size: 13.0,
                  color: Colors.grey,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
