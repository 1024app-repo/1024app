import 'package:flutter/material.dart';

import '../../api/model.dart';
import '../app_bar.dart';
import 'topic_list.dart';

class TopicsView extends StatelessWidget {
  final Node node;

  TopicsView(this.node);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: node.name),
      body: TopicListView(nodeId: node.id),
    );
  }
}
