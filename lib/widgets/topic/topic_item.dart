import 'package:communityfor1024/pages/detail/page/topic_detail_page.dart';
import 'package:flutter/material.dart';
import 'package:identicon/identicon.dart';

import '../../api/model.dart';
import '../../util/db_helper.dart';
import '../colorful_tag.dart';

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
          widget.topic.readStatus = true;
        });

        dbHelper.insert(widget.topic);

        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => new TopicDetailPage(widget.topic.id),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: widget.topic.readStatus ? Color(0xFFFFFFE0) : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 标题
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
            // 头像、作者、时间、回复数
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
                // 熱門
                Offstage(
                  offstage: !widget.topic.hot,
                  child: ColorfulTag(
                    title: '熱門',
                    color: Colors.redAccent[200],
                    fontSize: 8,
                  ),
                ),
                // 精華
                Offstage(
                  offstage: !widget.topic.prime,
                  child: ColorfulTag(
                    title: '精華',
                    color: Colors.purpleAccent[200],
                    fontSize: 8,
                  ),
                ),
                // 置頂
                Offstage(
                  offstage: widget.topic.publishTime != 'Top-marks',
                  child: ColorfulTag(
                    title: '置頂',
                    color: Colors.greenAccent[200],
                    fontSize: 8,
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
                )
              ],
            ),
          ],
        ),
      ),
    );
  }
}
