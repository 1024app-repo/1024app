import 'package:dio/dio.dart';
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
  bool showToTopBtn = false;

  ScrollController _scrollController;

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

  @override
  void didChangeDependencies() {
    _scrollController = PrimaryScrollController.of(context);
//    _scrollController.addListener(() {
//      if (_scrollController.offset < 500 && showToTopBtn) {
//        if (mounted) {
//          setState(() {
//            showToTopBtn = false;
//          });
//        }
//      } else if (_scrollController.offset >= 500 && showToTopBtn == false) {
//        if (mounted) {
//          setState(() {
//            showToTopBtn = true;
//          });
//        }
//      }
//    });
    super.didChangeDependencies();
  }

  Future _fetchData(int page) async {
    if (!loading) {
      loading = true;
      hasError = false;

      Node node;
      try {
        node = await API.getNodeDetail(widget.node, page);
      } on DioError catch (e) {
        print(e);
        setState(() {
          loading = false;
          hasError = true;
        });
        return;
      }
      print(node.topics);

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

  Future _onRefresh() async {
    Node node = await API.getNodeDetail(widget.node, 1);
    if (mounted) {
      setState(() {
        items.clear();
        items.addAll(node.topics);
      });
    }
    _refreshController.finishRefresh(success: true);
  }

  @override
  Widget build(BuildContext context) {
    if (items.length > 0) {
      return Scaffold(
        body: Scrollbar(
          child: bodyList(),
        ),
        floatingActionButton: !showToTopBtn
            ? null
            : FloatingActionButton(
                mini: true,
                child: Icon(Icons.arrow_upward),
                onPressed: () {
                  _scrollController.animateTo(
                    .0,
                    duration: Duration(milliseconds: 200),
                    curve: Curves.ease,
                  );
                },
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

  Widget bodyList() {
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
          return TopicItemView(items[index]);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 0.0);
        },
        itemCount: items.length,
      ),
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
      controller: _refreshController,
      scrollController: _scrollController,
    );
  }
}
