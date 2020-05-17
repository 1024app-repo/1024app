import 'package:flutter/material.dart';

import '../../api/model.dart';
import '../../util/constants.dart';
import '../avatar_letter.dart';
import '../colorful_tag.dart';
import 'topic_content.dart';

class TopicReply extends StatelessWidget {
  final Reply reply;

  const TopicReply({Key key, this.reply}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      color: Theme.of(context).cardColor,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 头像和楼主标签
          Column(
            children: <Widget>[
              // 评论item头像
              AvatarLetter(
                size: 35,
                fontSize: 12,
                upperCase: true,
                numberLetters: 1,
                letterType: LetterType.Circular,
                text: reply.author,
              ),
            ],
          ),
          const SizedBox(
            width: 10.0,
          ),
          // 回复主体
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        // 评论用户ID
                        Row(
                          children: <Widget>[
                            Text(
                              reply.author,
                              textAlign: TextAlign.left,
                              maxLines: 1,
                              style: Theme.of(context).textTheme.subtitle2,
                            ),
                            const SizedBox(
                              width: 5,
                            ),
                            ColorfulTag(
                              title: reply.level,
                              color: colourLevel[reply.level.trim()],
                              fontSize: 9,
                            ),
                          ],
                        ),
                        // 评论时间
                        Row(
                          children: <Widget>[
                            Text(
                              reply.time.trim(),
                              style: TextStyle(
                                color: Theme.of(context).hintColor,
                                fontSize: 12,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                    const Spacer(),
                    // 楼层
                    Container(
                      alignment: Alignment.center,
                      child: Text(
                        "#${reply.floor}",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    )
                  ],
                ),
                // 回复内容
                TopicContent(
                  content: reply.content,
                  viewImage: false,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
