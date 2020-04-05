import 'package:communityfor1024/api/model.dart';
import 'package:equatable/equatable.dart';

abstract class TopicListState extends Equatable {
  const TopicListState();

  @override
  List<Object> get props => [];
}

class TopicListUninitialized extends TopicListState {}

class TopicListError extends TopicListState {}

class TopicListLoaded extends TopicListState {
  final List<Topic> topics;
  final bool hasReachedMax;

  const TopicListLoaded({this.topics, this.hasReachedMax});

  TopicListLoaded copyWith({List<Topic> topics}) {
    return TopicListLoaded(topics: topics ?? this.topics);
  }

  @override
  List<Object> get props => [topics, hasReachedMax];

  @override
  String toString() =>
      'TopicListLoaded { topics: ${topics.length}, hasReachedMax: $hasReachedMax }';
}
