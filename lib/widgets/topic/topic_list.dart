import 'package:communityfor1024/blocs/list/bloc.dart';
import 'package:communityfor1024/util/event_bus.dart';
import 'package:communityfor1024/widgets/topic/topic_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../api/model.dart';
import '../../widgets/error/error.dart';
import '../refresh_indicator.dart';

class TopicListView extends StatefulWidget {
  final String nodeId;

  TopicListView({this.nodeId});

  @override
  State<StatefulWidget> createState() => new TopicListViewState();
}

class TopicListViewState extends State<TopicListView> {
  EasyRefreshController _refreshController;
  ScrollController _scrollController;

  TopicListBloc _bloc;

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    eventBus.on('RefreshTopicsEvent', (_) => _refreshController.callRefresh());
    _bloc = BlocProvider.of<TopicListBloc>(context)
      ..add(RefreshEvent(
        nodeId: widget.nodeId,
        controller: _refreshController,
      ));
  }

  @override
  void dispose() {
    super.dispose();
    _refreshController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TopicListBloc, TopicListState>(
      // ignore: missing_return
      builder: (context, state) {
        if (state is TopicListUninitialized) {
          return SpinKitWave(
            color: Color(0xFF808080),
            type: SpinKitWaveType.start,
            size: 20,
          );
        } else if (state is TopicListError) {
          return NetworkError(
            onPress: () async {
              _bloc.add(RefreshEvent(
                nodeId: widget.nodeId,
                controller: _refreshController,
              ));
            },
          );
        } else if (state is TopicListLoaded) {
          return Scrollbar(
            child: TopicList(
              refreshController: _refreshController,
              scrollController: _scrollController,
              onRefresh: () async {
                _bloc.add(RefreshEvent(
                  nodeId: widget.nodeId,
                  controller: _refreshController,
                ));
              },
              onLoad: () async {
                _bloc.add(LoadMoreEvent(
                  nodeId: widget.nodeId,
                  controller: _refreshController,
                ));
              },
              items: state.topics,
            ),
          );
        }
      },
    );
  }
}

class TopicList extends StatelessWidget {
  final EasyRefreshController refreshController;
  final ScrollController scrollController;
  final OnRefreshCallback onRefresh;
  final OnLoadCallback onLoad;
  final List<Topic> items;

  const TopicList({
    Key key,
    this.refreshController,
    this.scrollController,
    this.onRefresh,
    this.onLoad,
    this.items,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return EasyRefresh(
      header: RefreshHeader(
        color: Color(0xFF808080),
      ),
      footer: RefreshFooter(
        color: Color(0xFF808080),
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
          return const Divider(
            height: 0,
            indent: 20,
            endIndent: 20,
          );
        },
        itemCount: items.length,
        cacheExtent: 250,
      ),
      onRefresh: onRefresh,
      onLoad: onLoad,
      controller: refreshController,
      scrollController: scrollController,
    );
  }
}
