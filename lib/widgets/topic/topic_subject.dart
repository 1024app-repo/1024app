import 'dart:ui';

import 'package:flutter/material.dart';

import '../../api/model.dart';
import '../../util/constants.dart';
import '../circle_avatar.dart';
import '../colorful_tag.dart';
import 'topic_content.dart';

class TopicSubject extends StatelessWidget {
  final Topic topic;

  const TopicSubject({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // topic title
          Text(
            topic.title,
            softWrap: true,
            style: Theme.of(context).textTheme.title,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                // 头像
                CircleAvatarWithPlaceholder(
                  imageUrl: topic.subject.avatar,
                  userName: topic.author,
                  size: 40,
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          // 用户ID
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new Text(
                              topic.author,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ColorfulTag(
                            title: topic.subject.level,
                            color: colourLevel[topic.subject.level.trim()],
                            fontSize: 10,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              topic.subject.time,
                              style: TextStyle(
                                color: Theme.of(context).disabledColor,
                                fontSize: 13,
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          TopicContent(content: topic.subject.content),
        ],
      ),
    );
  }
}
