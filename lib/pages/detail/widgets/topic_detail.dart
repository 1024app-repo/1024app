import 'dart:async';
import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:oktoast/oktoast.dart';

import '../../../api/api.dart';
import '../../../api/model.dart';
import '../../../util/db_helper.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/error/error.dart';
import '../../../widgets/refresh_indicator.dart';
import '../../../widgets/topic/topic_reply.dart';
import '../../../widgets/topic/topic_subject.dart';
import 'sliver_page_delegate.dart';

class TopicDetailView extends StatefulWidget {
  final Topic topic;

  TopicDetailView(this.topic);

  @override
  TopicDetailViewState createState() => TopicDetailViewState();
}

class TopicDetailViewState extends State<TopicDetailView> {
  final GlobalKey globalKey = GlobalKey();

  bool loading = false;
  bool hasError = false;
  bool reverse = false;

  ScrollController _scrollController;

  EasyRefreshController _refreshController;
  TextEditingController _textController;

  List<Reply> items = List();

  @override
  void initState() {
    super.initState();
    _refreshController = EasyRefreshController();
    _textController = TextEditingController();
    _fetchData(1);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    _scrollController = PrimaryScrollController.of(context);
    super.didChangeDependencies();
  }

  Future _fetchData(int page) async {
    if (!loading) {
      loading = true;
      hasError = false;

      Topic topic;
      try {
        topic = await API.getTopicDetail(widget.topic, page);
      } on DioError catch (e) {
        print(e);
        setState(() {
          loading = false;
          hasError = true;
        });
        return;
      }

      if (mounted) {
        setState(() {
          items.addAll(
            reverse ? topic.replies.reversed.toList() : topic.replies,
          );
          loading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dbHelper = DbHelper.instance;

    return Scaffold(
      appBar: MyAppBar(
        title: '详情',
        actions: <Widget>[
          IconButton(
            icon: Icon(
              widget.topic.starredTime != null ? Icons.star : Icons.star_border,
            ),
            onPressed: () {
              HapticFeedback.heavyImpact();
              var now = new DateTime.now().toString();
              setState(() {
                widget.topic.starredTime =
                    widget.topic.starredTime == null ? now : null;
              });
              dbHelper.insertOrUpdate(widget.topic);
              widget.topic.starredTime == null
                  ? showToast('已取消收藏')
                  : showToast('收藏成功');
            },
          ),
        ],
      ),
      body: hasError
          ? NetworkError(onPress: () async {
              _fetchData(1);
            })
          : !loading && widget.topic.subject != null
              ? Container(
                  color: Theme.of(context).scaffoldBackgroundColor,
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

                          // 翻页
                          items.length == 0
                              ? SliverToBoxAdapter(
                                  child: Container(
                                    key: globalKey,
                                    padding: EdgeInsets.all(10.0),
                                    color: Colors.grey[200],
                                    child: Center(
                                      child: Text(
                                        '目前尚无回复',
                                        style: new TextStyle(
                                            color: Colors.grey[600]),
                                      ),
                                    ),
                                  ),
                                )
                              : pagePersistent(),

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
                        var page = reverse
                            ? widget.topic.current - 1
                            : widget.topic.current + 1;
                        if (page > widget.topic.total || page <= 1) {
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
    return TopicSubject(widget.topic);
  }

  Widget pagePersistent() {
    return SliverPersistentHeader(
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
            Text("共 ${widget.topic.replyCount} 条回复"),
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
                _fetchData(reverse ? widget.topic.total : 1);
              },
            )
          ]),
        ),
      ),
    );
  }

  Widget commentCard() {
    return items.length == 0
        ? Container(
            height: 20,
          )
        : Container(
            margin: const EdgeInsets.all(0.0),
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                Reply comment = items[index];
                if (index == 0) {
                  return TopicReply(
                    comment,
                    widget.topic.author == comment.author,
                    key: globalKey,
                  );
                }
                return TopicReply(
                    comment, widget.topic.author == comment.author);
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
