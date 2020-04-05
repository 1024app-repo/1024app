import 'package:communityfor1024/blocs/detail/bloc.dart';
import 'package:communityfor1024/pages/detail/page/topic_detail_page.dart';
import 'package:communityfor1024/util/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../api/model.dart';
import '../avatar_letter.dart';
import '../colorful_tag.dart';

class TopicItem extends StatelessWidget {
  final Topic topic;

  const TopicItem({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print('TopicItem:' + topic.id);

    return InkWell(
      onTap: () {
        topic.readStatus = true;
        DbHelper.instance.insert(topic);
        final page = BlocProvider(
          create: (_) => TopicDetailBloc(),
          child: TopicDetailPage(topic.id),
        );
        Navigator.push(
          context,
          new MaterialPageRoute(
            builder: (context) => page,
          ),
        );
//        return;
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        color: topic.readStatus ? Color(0xFFEDE7F6) : Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // 标题
            Text(
              topic.title,
              style: TextStyle(
                fontSize: 16,
                color: Theme.of(context).textTheme.title.color,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            // 头像、作者、时间、回复数
            TopicItemMetadata(topic: topic),
          ],
        ),
      ),
    );
  }
}

class TopicItemMetadata extends StatelessWidget {
  final Topic topic;

  const TopicItemMetadata({Key key, this.topic});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        AvatarLetter(
          size: 15,
          fontSize: 8,
          upperCase: true,
          numberLetters: 1,
          letterType: LetterType.Circular,
          text: topic.author,
        ),
        const SizedBox(width: 5),
        Text(
          topic.author,
          textAlign: TextAlign.left,
          style: new TextStyle(
            fontSize: 13.0,
            color: Theme.of(context).textTheme.title.color,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          "${topic.replyTime}",
          style: TextStyle(
            fontSize: 13.0,
            color: Theme.of(context).disabledColor,
          ),
        ),
        const SizedBox(width: 5),
        // 熱門
        Offstage(
          offstage: !topic.hot,
          child: ColorfulTag(
            title: '热门',
            color: Colors.redAccent[200],
            fontSize: 8,
          ),
        ),
        // 精華
        Offstage(
          offstage: !topic.prime,
          child: ColorfulTag(
            title: '精华',
            color: Colors.purpleAccent[200],
            fontSize: 8,
          ),
        ),
        // 置頂
        Offstage(
          offstage: topic.publishTime != 'Top-marks',
          child: ColorfulTag(
            title: '置顶',
            color: Colors.greenAccent[400],
            fontSize: 8,
          ),
        ),
        const Spacer(),
        Padding(
          padding: const EdgeInsets.only(right: 2.0),
          child: Text(
            topic.replyCount,
            style: TextStyle(
              color: Theme.of(context).disabledColor,
              fontSize: 13,
            ),
          ),
        ),
        const Icon(
          Icons.chat_bubble_outline,
          size: 13.0,
          color: Colors.grey,
        )
      ],
    );
  }
}
