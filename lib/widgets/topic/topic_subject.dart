import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

import '../../api/model.dart';
import '../../util/constants.dart';
import '../circle_avatar.dart';
import '../colorful_tag.dart';
import '../html_factory.dart';

class TopicSubject extends StatefulWidget {
  final Topic topic;

  TopicSubject(this.topic);

  @override
  State<StatefulWidget> createState() => TopicSubjectState();
}

class TopicSubjectState extends State<TopicSubject> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // topic title
          Container(
            padding: const EdgeInsets.all(10),
            child: new Text(
              widget.topic.title,
              softWrap: true,
              style: Theme.of(context).textTheme.title,
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: new Row(
              children: <Widget>[
                // 头像
                CircleAvatarWithPlaceholder(
                  imageUrl: widget.topic.subject.avatar,
                  userName: widget.topic.author,
                  size: 40,
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          // 用户ID
                          Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: new Text(
                              widget.topic.author,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          ColorfulTag(
                            title: widget.topic.subject.level,
                            color:
                                colourLevel[widget.topic.subject.level.trim()],
                            fontSize: 10,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              widget.topic.subject.time,
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
          // topic content
          HtmlWidget(
            widget.topic.subject.content.replaceAll('ess-data', 'data-src'),
            factoryBuilder: (config) => HtmlWidgetFactory(config),
          ),
        ],
      ),
    );
  }
}
