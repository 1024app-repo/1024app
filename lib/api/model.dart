class Node {
  String id;
  String name;
  String url;
  String desc;

  List<Category> categories;
  List<Topic> topics;

  int total = 1;
  int current = 1;

  Node(this.id, this.name, this.url, this.desc, this.categories);

  @override
  String toString() {
    return 'Node{name: $name, url: $url}';
  }
}

class Category {
  String id;
  final String name;
  final String url;

  Category(this.id, this.name, this.url);

  @override
  String toString() {
    return 'Category{name: $name, url: $url}';
  }
}

class Topic {
  String nodeId;
  String id;
  String title;
  String author;
  String publishTime;
  bool hot = false;
  bool prime = false;

  String replier;
  String replyTime;
  String replyCount;

  String readTime;
  String starredTime;

  Reply subject;
  List<String> images;
  List<Reply> replies;

  int total = 1;
  int current = 1;

  Topic(this.nodeId, this.id, this.title, this.author, this.publishTime,
      this.replier, this.replyTime, this.replyCount);

  Topic.fromMap(Map<String, dynamic> map) {
    this.nodeId = map['nodeId'];
    this.id = map['topicId'];
    this.title = map['title'];
//    this.url = map['url'];
    this.author = map['author'];
    this.publishTime = map['publishTime'];
    this.replier = map['replier'];
    this.replyTime = map['replyTime'];
    this.replyCount = map['replyCount'];
    this.readTime = map['readTime'];
    this.starredTime = map['starredTime'];
  }

  Map<String, dynamic> toMap() {
    final map = Map<String, dynamic>();
    map['nodeId'] = this.nodeId;
    map['topicId'] = this.id;
    map['title'] = this.title;
//    map['url'] = this.url;
    map['author'] = this.author;
    map['publishTime'] = this.publishTime;
    map['replier'] = this.replier;
    map['replyTime'] = this.replyTime;
    map['replyCount'] = this.replyCount;
    map['readTime'] = this.readTime;
    map['starredTime'] = this.starredTime;
    return map;
  }

  @override
  String toString() {
    return 'Topic{id: $id, title: $title, author: $author,'
        ' publishTime: $publishTime, replier: $replier, replyTime: $replyTime,'
        ' replyNum: $replyCount}';
  }
}

class Reply {
  final String author;
  final String avatar;
  final String level;
  final String content;
  final String time;
  final String floor;

  Reply(this.author, this.avatar, this.level, this.content, this.time,
      this.floor);

  @override
  String toString() {
    return 'Detail{author: $author, level: $level, time: $time, floor: $floor}';
  }
}

class UserProperty {
  String prestige;
  String money;
  String contribution;
  String posted;

  UserProperty(this.prestige, this.money, this.contribution, this.posted);

  UserProperty.fromString(String str) {
    var v = str.split('|');
    this.prestige = v[0];
    this.money = v[1];
    this.contribution = v[2];
    this.posted = v[3];
  }

  @override
  String toString() {
    return '$prestige|$money|$contribution|$posted';
  }
}
