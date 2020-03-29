import 'package:extended_nested_scroll_view/extended_nested_scroll_view.dart'
    as extended;
import 'package:flutter/material.dart';

import '../../api/model.dart';
import 'topic_list.dart';

class TopicsView extends StatefulWidget {
  final Node node;

  TopicsView(this.node);

  @override
  State<StatefulWidget> createState() => new TopicsViewState();
}

class TopicsViewState extends State<TopicsView>
    with SingleTickerProviderStateMixin {
  TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController =
        TabController(length: widget.node.categories.length, vsync: this);
  }

  @override
  void dispose() {
    super.dispose();
    _tabController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: extended.NestedScrollView(
        pinnedHeaderSliverHeightBuilder: () {
          return MediaQuery.of(context).padding.top + kToolbarHeight;
        },
        innerScrollPositionKeyBuilder: () {
          return Key('Tab${_tabController.index}');
        },
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              title: Text(
                widget.node.name,
                style: TextStyle(fontSize: 18),
              ),
              centerTitle: true,
              floating: true,
              pinned: true,
//              snap: true,
              bottom: new PreferredSize(
                child: new TabBar(
                  isScrollable: true,
                  controller: _tabController,
                  tabs: widget.node.categories.map((Category v) {
                    return new Tab(
                      text: v.name,
                    );
                  }).toList(),
                ),
                preferredSize: new Size(double.infinity, 46.0),
              ),
              forceElevated: true,
              elevation: 1.0,
            )
          ];
        },
        body: TabBarView(
          controller: _tabController,
          children: widget.node.categories
              .asMap()
              .map((int k, Category v) {
                return new MapEntry(
                  k,
                  extended.NestedScrollViewInnerScrollPositionKeyWidget(
                    Key("Key$k"),
                    TopicListView(
                      Node(
                        id: v.id,
                        name: v.name,
                        url: v.url,
                        desc: '',
                        categories: [],
                      ),
                    ),
                  ),
                );
              })
              .values
              .toList(),
        ),
      ),
    );
  }
}
