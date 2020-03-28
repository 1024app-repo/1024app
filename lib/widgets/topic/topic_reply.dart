import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../api/model.dart';
import '../../util/constants.dart';
import '../../widgets/html_factory.dart';
import '../circle_avatar.dart';

class TopicReply extends StatefulWidget {
  final Reply reply;
  final bool isAuthor;

  TopicReply(this.reply, this.isAuthor, {Key key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => TopicReplyState();
}

class TopicReplyState extends State<TopicReply> {
  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              children: <Widget>[
                // 评论item头像
                CircleAvatarWithPlaceholder(
                  imageUrl: widget.reply.avatar,
                  userName: widget.reply.author,
                  size: 32,
                ),
                Offstage(
                  offstage: !widget.isAuthor,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6.0),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 3, vertical: 1),
                      decoration: BoxDecoration(
                        color: Colors.redAccent[100],
                        borderRadius: BorderRadius.circular(2),
                      ),
                      child: Text(
                        '樓主',
                        style: TextStyle(fontSize: 9, color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 10.0,
            ),
            Expanded(
              child: Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            children: <Widget>[
                              // 评论用户ID
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.reply.author,
                                    textAlign: TextAlign.left,
                                    maxLines: 1,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .title
                                          .color,
                                      fontSize: 14,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(left: 2.0, right: 2.0),
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 3, vertical: 1),
                                      decoration: BoxDecoration(
                                        color: colourLevel[
                                            widget.reply.level.trim()],
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                      child: Text(
                                        widget.reply.level,
                                        style: TextStyle(
                                          fontSize: 9,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  )
                                ],
                              ),
                              // 评论时间
                              Row(
                                children: <Widget>[
                                  Text(
                                    widget.reply.time.trim(),
                                    style: TextStyle(
                                      color: Theme.of(context).disabledColor,
                                      fontSize: 12,
                                    ),
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
//                                    Spacer(),
                        Container(
                          alignment: Alignment.center,
                          child: new Text(
                            "#${widget.reply.floor}",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        )
                      ],
                    ),
                    HtmlWidget(
                      widget.reply.content,
                      bodyPadding: const EdgeInsets.symmetric(vertical: 15),
                      factoryBuilder: (config) => HtmlWidgetFactory(config),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
