import 'package:flutter/material.dart';

import '../../../api/model.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/topic/topic_list.dart';

class HomePage extends StatefulWidget {
  @override
  HomePageState createState() {
    return HomePageState();
  }
}

class HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();

    _tabController = TabController(vsync: this, initialIndex: 0, length: 3);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      appBar: MyAppBar(title: "草榴社区"),
      body: TopicListView(
        Node(
          id: '7',
          name: "技術討論區",
          url: "thread0806.php?fid=7",
          desc: "所有",
          categories: [],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
