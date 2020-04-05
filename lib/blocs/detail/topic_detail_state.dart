import 'package:communityfor1024/api/model.dart';
import 'package:equatable/equatable.dart';

abstract class TopicDetailState extends Equatable {
  const TopicDetailState();

  @override
  List<Object> get props => [];
}

class TopicDetailUninitialized extends TopicDetailState {}

class TopicDetailError extends TopicDetailState {}

class TopicDetailLoaded extends TopicDetailState {
  final Reply subject;
  final List<Reply> replies;
  final int current;
  final int total;

  const TopicDetailLoaded({
    this.subject,
    this.replies,
    this.current,
    this.total,
  });

  TopicDetailLoaded copyWith({
    Reply subject,
    List<Reply> replies,
    int current,
    int total,
  }) {
    return TopicDetailLoaded(
      subject: subject ?? this.subject,
      replies: replies ?? this.replies,
      current: current ?? this.current,
      total: total ?? this.total,
    );
  }

  @override
  List<Object> get props => [subject, replies, current, total];

  @override
  String toString() =>
      'TopicDetailLoaded { subject: $subject, replies: ${replies.length}, current: $current, total: $total }';
}
