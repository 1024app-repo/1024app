import 'package:flutter/material.dart';

import '../../api/model.dart';
import '../../util/constants.dart';
import '../circle_avatar.dart';
import '../colorful_tag.dart';
import 'topic_content.dart';

class TopicReply extends StatelessWidget {
  final Reply reply;
  final bool isAuthor;

  const TopicReply({
    Key key,
    this.reply,
    this.isAuthor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // 头像和楼主标签
          Column(
            children: <Widget>[
              // 评论item头像
              CircleAvatarWithPlaceholder(
                imageUrl: reply.avatar,
                userName: reply.author,
                size: 32,
              ),
              Offstage(
                offstage: !isAuthor,
                child: Padding(
                  padding: const EdgeInsets.only(top: 6.0),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
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
                              style: TextStyle(
                                color: Theme.of(context).textTheme.title.color,
                                fontSize: 14,
                              ),
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
                                color: Theme.of(context).disabledColor,
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
                TopicContent(content: reply.content),
              ],
            ),
          )
        ],
      ),
    );
  }
}
