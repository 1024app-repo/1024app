import 'dart:ui';

import 'package:communityfor1024/api/model.dart';
import 'package:flutter/material.dart';

import '../../util/constants.dart';
import '../avatar_letter.dart';
import '../colorful_tag.dart';
import 'topic_content.dart';

class TopicSubject extends StatelessWidget {
  final Reply subject;

  const TopicSubject(this.subject);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // topic title
          Text(
            subject.title,
            softWrap: true,
            style: Theme.of(context).textTheme.title,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                // 头像
                AvatarLetter(
                  size: 40,
                  fontSize: 16,
                  upperCase: true,
                  numberLetters: 1,
                  letterType: LetterType.Circular,
                  text: subject.author,
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
                              subject.author,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle,
                            ),
                          ),
                          const SizedBox(
                            width: 5,
                          ),
                          ColorfulTag(
                            title: subject.level,
                            color: colourLevel[subject.level],
                            fontSize: 10,
                          ),
                        ],
                      ),
                      Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(top: 3.0),
                            child: Text(
                              subject.time,
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
          TopicContent(
            content: subject.content,
            viewImage: true,
          ),
        ],
      ),
    );
  }
}
