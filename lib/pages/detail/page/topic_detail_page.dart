import 'package:communityfor1024/blocs/detail/bloc.dart';
import 'package:communityfor1024/pages/detail/widgets/sliver_page_delegate.dart';
import 'package:communityfor1024/widgets/app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../api/model.dart';
import '../../../widgets/error/error.dart';
import '../../../widgets/refresh_indicator.dart';
import '../../../widgets/topic/topic_reply.dart';
import '../../../widgets/topic/topic_subject.dart';

class TopicDetailPage extends StatefulWidget {
  final String topicId;

  TopicDetailPage(this.topicId);

  @override
  TopicDetailPageState createState() => TopicDetailPageState();
}

class TopicDetailPageState extends State<TopicDetailPage> {
  final GlobalKey globalKey = GlobalKey();

  ScrollController _scrollController = new ScrollController();
  EasyRefreshController _refreshController;
  TopicDetailBloc _bloc;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _refreshController = EasyRefreshController();
    _bloc = BlocProvider.of<TopicDetailBloc>(context)
      ..add(RefreshEvent(
        topicId: widget.topicId,
        controller: _refreshController,
      ));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '详情'),
      body: BlocBuilder<TopicDetailBloc, TopicDetailState>(
        // ignore: missing_return
        builder: (context, state) {
          if (state is TopicDetailUninitialized) {
            return SpinKitWave(
              color: Colors.indigo,
              type: SpinKitWaveType.start,
              size: 20,
            );
          } else if (state is TopicDetailError) {
            return NetworkError(
              onPress: () async {
                _bloc.add(RefreshEvent(
                  topicId: widget.topicId,
                  controller: _refreshController,
                ));
              },
            );
          } else if (state is TopicDetailLoaded) {
            return Scrollbar(
              child: EasyRefresh(
                enableControlFinishRefresh: true,
                enableControlFinishLoad: true,
                header: RefreshHeader(
                  color: Colors.indigo,
                ),
                footer: RefreshFooter(
                  color: Colors.indigo,
                  enableHapticFeedback: false,
                ),
                child: CustomScrollView(
                  slivers: <Widget>[
                    // 详情view
                    SliverToBoxAdapter(
                      child: TopicSubject(state.subject),
                    ),

                    SliverPersistentHeader(
                      pinned: true,
                      floating: true,
                      delegate: SliverPageDelegate(
                        maxHeight: 40,
                        minHeight: 40,
                        child: Row(children: <Widget>[
                          Container(
                            margin: const EdgeInsets.only(left: 20),
                            child: Text('全部回复'),
                          ),
                          const Spacer(),
                          Container(
                            margin: const EdgeInsets.only(right: 20),
                            child: Text('页码 ${state.current} / ${state.total}'),
                          ),
                        ]),
                      ),
                    ),

                    // 评论view
                    SliverToBoxAdapter(
                      child: Container(
                        key: globalKey,
                        color: Colors.white,
                        child: ListView.separated(
                          itemCount: state.replies.length - 1,
                          itemBuilder: (context, index) {
                            Reply comment = state.replies[index + 1];
                            return TopicReply(reply: comment);
                          },
                          separatorBuilder: (BuildContext context, int index) {
                            return const Divider(height: 0);
                          },
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                        ),
                      ),
                    ),
                  ],
                  controller: _scrollController,
                ),
                onRefresh: () async {
                  _bloc.add(RefreshEvent(
                    topicId: widget.topicId,
                    controller: _refreshController,
                  ));
                },
                onLoad: () async {
                  _bloc.add(LoadMoreEvent(
                    topicId: widget.topicId,
                    controller: _refreshController,
                  ));
                },
                controller: _refreshController,
                scrollController: _scrollController,
              ),
            );
          }
        },
      ),
    );
  }
}
