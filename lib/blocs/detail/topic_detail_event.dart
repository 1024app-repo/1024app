import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

abstract class TopicDetailEvent extends Equatable {
  const TopicDetailEvent();

  @override
  List<Object> get props => [];
}

class RefreshEvent extends TopicDetailEvent {
  final String topicId;
  final EasyRefreshController controller;

  const RefreshEvent({
    @required this.topicId,
    @required this.controller,
  }) : super();
}

class LoadMoreEvent extends TopicDetailEvent {
  final String topicId;
  final EasyRefreshController controller;

  const LoadMoreEvent({
    @required this.topicId,
    @required this.controller,
  }) : super();
}
