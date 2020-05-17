import 'package:flutter/material.dart';

import '../../api/model.dart';
import 'topic_list.dart';

class TopicsView extends StatelessWidget {
  final Node node;

  TopicsView(this.node);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TopicListView(nodeId: node.id),
    );
  }
}
