import 'package:flutter/material.dart';

import '../../../api/model.dart';
import '../widgets/topic_detail.dart';

class TopicDetailPage extends StatelessWidget {
  final Topic topic;

  TopicDetailPage(this.topic);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopicDetailView(topic),
    );
  }
}
