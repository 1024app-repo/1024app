import 'package:communityfor1024/pages/drawer/page/drawer.dart';
import 'package:communityfor1024/util/event_bus.dart';
import 'package:flutter/material.dart';

import '../../../widgets/app_bar.dart';
import '../../../widgets/topic/topic_list.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: MyAppBar(title: "草榴社区"),
      drawer: MyDrawer(),
      body: TopicListView(nodeId: '7'),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.refresh),
        backgroundColor: Colors.indigo,
        onPressed: () {
          eventBus.emit('RefreshTopicsEvent');
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
