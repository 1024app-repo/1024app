import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../api/api.dart';
import '../../api/model.dart';
import '../../util/event_bus.dart';
import '../../widgets/error/error.dart';
import '../refresh_indicator.dart';
import 'topic_item.dart';

class TopicListView extends StatefulWidget {
  final Node node;

  TopicListView(this.node);

  @override
  State<StatefulWidget> createState() => new TopicListViewState();
}

class TopicListViewState extends State<TopicListView> {
  bool loading = false;
  bool hasError = false;

  EasyRefreshController _refreshController;
  List<Topic> items = new List();
  int current = 1;
  int total = 1;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    eventBus.on('RefreshTopicsEvent', (_) => _refreshController.callRefresh());
    _fetchData(1);
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  Future _fetchData(int page) async {
    if (!loading) {
      loading = true;
      hasError = false;

      Node node;
      try {
        node = await API.getNodeDetail(widget.node, page);
      } catch (e) {
        print(e);
        setState(() {
          loading = false;
          hasError = true;
        });
        return;
      }

      if (mounted) {
        setState(() {
          items.addAll(node.topics);
          current = node.current;
          total = node.total;
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    if (items.length > 0) {
      return Scaffold(
        body: Scrollbar(
          child: TopicList(
            controller: _refreshController,
            onRefresh: () async {
              items.clear();
              await _fetchData(1);
              _refreshController.finishRefresh(success: true);
            },
            onLoad: () async {
              var page = current + 1;
              if (page > total) {
                _refreshController.finishLoad(success: true, noMore: true);
                return;
              }
              await _fetchData(page);
              _refreshController.finishLoad(success: true, noMore: false);
            },
            items: items,
          ),
        ),
      );
    } else if (hasError) {
      return NetworkError(
        onPress: () async {
          await _fetchData(1);
        },
      );
    }

    return SpinKitWave(
      color: Color(0xFF999999),
      type: SpinKitWaveType.start,
      size: 20,
    );
  }
}

class TopicList extends StatelessWidget {
  final EasyRefreshController controller;
  final OnRefreshCallback onRefresh;
  final OnLoadCallback onLoad;
  final List<Topic> items;

  const TopicList({
    Key key,
    this.controller,
    this.onRefresh,
    this.onLoad,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: RefreshHeader(
        color: Color(0xFF999999),
      ),
      footer: RefreshFooter(
        color: Color(0xFF999999),
        enableHapticFeedback: false,
      ),
      enableControlFinishRefresh: true,
      enableControlFinishLoad: true,
      child: ListView.separated(
        padding: EdgeInsets.all(0.0),
        itemBuilder: (context, index) {
          return TopicItem(topic: items[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return const Divider(height: 0.0);
        },
        itemCount: items.length,
        cacheExtent: 250,
      ),
      onRefresh: onRefresh,
      onLoad: onLoad,
      controller: controller,
    );
  }
}
