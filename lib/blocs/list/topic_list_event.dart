import 'package:equatable/equatable.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

abstract class TopicListEvent extends Equatable {
  const TopicListEvent();

  @override
  List<Object> get props => [];
}

class RefreshEvent extends TopicListEvent {
  final String nodeId;
  final EasyRefreshController controller;

  const RefreshEvent({
    this.nodeId,
    this.controller,
  }) : super();
}

class LoadMoreEvent extends TopicListEvent {
  final String nodeId;
  final EasyRefreshController controller;

  const LoadMoreEvent({
    this.nodeId,
    this.controller,
  }) : super();
}
