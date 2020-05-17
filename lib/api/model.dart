import 'package:equatable/equatable.dart';

class Node {
  String id;
  String name;

  int total = 1;
  int current = 1;

  Node({this.id, this.name});

  @override
  String toString() {
    return 'Node{id: $id, name: $name}';
  }
}

// ignore: must_be_immutable
class Topic extends Equatable {
  String id;
  String title;
  String author;
  String publishTime;
  String replyTime;
  String replyCount;

  bool hot = false;
  bool prime = false;

  Reply subject;

  int total = 1;
  int current = 1;

  Topic({
    this.id,
    this.title,
    this.author,
    this.publishTime,
    this.replyTime,
    this.replyCount,
  });

  Topic.fromMap(Map<String, dynamic> map) {
    this.id = map['topicId'];
    this.title = map['title'];
    this.author = map['author'];
    this.publishTime = map['publishTime'];
    this.replyTime = map['replyTime'];
    this.replyCount = map['replyCount'];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['topicId'] = this.id;
    map['title'] = this.title;
    map['author'] = this.author;
    map['publishTime'] = this.publishTime;
    map['replyTime'] = this.replyTime;
    map['replyCount'] = this.replyCount;
    return map;
  }

  @override
  String toString() {
    return 'Topic {id: $id}';
  }

  @override
  List<Object> get props => [id, title, author, replyCount];
}

// ignore: must_be_immutable
class Reply extends Equatable {
  String title;
  final String author;

//  final String avatar;
  final String level;
  final String content;
  final String time;
  final String floor;

  Reply({
    this.author,
//    this.avatar,
    this.level,
    this.content,
    this.time,
    this.floor,
  });

  @override
  String toString() {
    return 'Reply {title: $title, author: $author, level: $level, time: $time, floor: $floor}';
  }

  @override
  List<Object> get props => [author, level, content, time, floor];
}

class Result<T> extends Equatable {
  final List<T> rows;
  final int page;
  final int total;

  const Result({this.rows, this.page, this.total});

  @override
  List<Object> get props => [rows, page, total];
}
