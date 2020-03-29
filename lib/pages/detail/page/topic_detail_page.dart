import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../api/api.dart';
import '../../../api/model.dart';
import '../../../util/db_helper.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/error/error.dart';
import '../../../widgets/refresh_indicator.dart';
import '../../../widgets/topic/topic_reply.dart';
import '../../../widgets/topic/topic_subject.dart';
import '../widgets/sliver_page_delegate.dart';

class TopicDetailPage extends StatefulWidget {
  final String topicId;

  TopicDetailPage(this.topicId);

  @override
  TopicDetailPageState createState() => TopicDetailPageState();
}

class TopicDetailPageState extends State<TopicDetailPage> {
  final GlobalKey globalKey = GlobalKey();

  Topic topic;

  bool loading = false;
  bool hasError = false;
  bool reverse = false;

  ScrollController _scrollController = new ScrollController();

  EasyRefreshController _refreshController;

  List<Reply> items = List();

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _refreshController = EasyRefreshController();
    _fetchData(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  Future _fetchData(int page) async {
    print(page);
    if (!loading) {
      loading = true;
      hasError = false;

      Topic res;
      try {
        res = await API.getTopicDetail(widget.topicId, page);
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
          // 第一页时更新所有数据，此后只更新回复和页码
          if (page < 2) {
            topic = res;
          }
          items.addAll(
            reverse ? res.replies.reversed.toList() : res.replies,
          );
          topic.total = res.total;
          topic.current = res.current;
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = DbHelper.instance;

    return Scaffold(
      appBar: MyAppBar(title: '详情'),
      body: hasError
          ? NetworkError(onPress: () async {
              _fetchData(1);
            })
          : !loading
              ? Container(
                  color: Colors.grey[200],
                  child: Scrollbar(
                    child: EasyRefresh(
                      enableControlFinishRefresh: true,
                      enableControlFinishLoad: true,
                      header: RefreshHeader(
                        color: Color(0xFF999999),
                      ),
                      footer: RefreshFooter(
                        color: Color(0xFF999999),
                        enableHapticFeedback: false,
                      ),
                      child: CustomScrollView(
                        slivers: <Widget>[
                          // 详情view
                          SliverToBoxAdapter(
                            child: detailCard(),
                          ),

                          pagePersistent(),

                          // 评论view
                          SliverToBoxAdapter(
                            child: commentCard(),
                          ),
                        ],
                        controller: _scrollController,
                      ),
                      onRefresh: () async {
                        items.clear();
                        await _fetchData(1);
                        _refreshController.finishRefresh(success: true);
                      },
                      onLoad: () async {
                        var page =
                            reverse ? topic.current - 1 : topic.current + 1;
                        if (page > topic.total || page <= 1) {
                          _refreshController.finishLoad(
                              success: true, noMore: true);
                          return;
                        }
                        await _fetchData(page);
                        _refreshController.finishLoad(
                            success: true, noMore: false);
                      },
                      controller: _refreshController,
                      scrollController: _scrollController,
                    ),
                  ),
                )
              : SpinKitWave(
                  color: Color(0xFF999999),
                  type: SpinKitWaveType.start,
                  size: 20,
                ),
    );
  }

  Widget detailCard() {
    return TopicSubject(topic);
  }

  Widget pagePersistent() {
    return items.length == 0
        ? SliverToBoxAdapter(
            child: Container(
              key: globalKey,
              padding: EdgeInsets.all(10.0),
              color: Colors.grey[200],
              child: Center(
                child: Text(
                  '目前尚无回复',
                  style: new TextStyle(color: Colors.grey[600]),
                ),
              ),
            ),
          )
        : SliverPersistentHeader(
            pinned: true,
            floating: true,
            delegate: SliverPageDelegate(
              maxHeight: 40,
              minHeight: 40,
              child: Container(
                padding: const EdgeInsets.only(left: 20),
                color: Colors.grey[200],
                alignment: Alignment.centerLeft,
                child: Row(children: <Widget>[
                  Text('页码 ${topic.current} / ${topic.total}'),
                  Spacer(),
                  RaisedButton(
                    color: Colors.grey[200],
                    splashColor: Colors.transparent,
                    highlightColor: Colors.transparent,
                    elevation: 0.0,
                    focusElevation: 0.0,
                    hoverElevation: 0.0,
                    highlightElevation: 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          reverse ? "倒序" : "正序",
                          style: TextStyle(
                            fontWeight: FontWeight.normal,
                            color: Theme.of(context).textTheme.body1.color,
                          ),
                        ),
                        Icon(
                          Icons.swap_vert,
                          size: 20,
                          color: Theme.of(context).textTheme.body1.color,
                        ),
                      ],
                    ),
                    onPressed: () {
                      setState(() {
                        reverse = !reverse;
                        items.clear();
                      });
                      _fetchData(reverse ? topic.total : 1);
                    },
                  )
                ]),
              ),
            ),
          );
  }

  Widget commentCard() {
    return Container(
      color: Colors.white,
      child: ListView.separated(
        itemCount: items.length,
        itemBuilder: (context, index) {
          Reply comment = items[index];
          if (index == 0) {
            return TopicReply(
              comment,
              topic.author == comment.author,
              key: globalKey,
            );
          }
          return TopicReply(comment, topic.author == comment.author);
        },
        separatorBuilder: (BuildContext context, int index) {
          return Divider(height: 0.0);
        },
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }
}
