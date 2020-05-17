import 'package:communityfor1024/api/model.dart';
import 'package:communityfor1024/blocs/detail/bloc.dart';
import 'package:communityfor1024/pages/topic_detail_page.dart';
import 'package:communityfor1024/util/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class TopicDetail extends StatelessWidget {
  final Topic topic;

  const TopicDetail({Key key, this.topic}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    DbHelper.instance.insert(topic);

    return Scaffold(
      body: BlocProvider(
        create: (_) => TopicDetailBloc(),
        child: TopicDetailPage(topic.id),
      ),
    );
  }
}
