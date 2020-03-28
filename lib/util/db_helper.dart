import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

import '../api/model.dart';

class DbHelper {
  static final _databaseName = "data.db";
  static final _databaseVersion = 1;

  static final table = 't_local_topics';

  // make this a singleton class
  DbHelper._privateConstructor();

  static final DbHelper instance = DbHelper._privateConstructor();

  // only have a single app-wide reference to the database
  static Database _database;

  Future<Database> get database async {
    if (_database != null) return _database;
    // lazily instantiate the db the first time it is accessed
    _database = await _initDatabase();
    return _database;
  }

  // this opens the database (and creates it if it doesn't exist)
  _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, _databaseName);

//    await deleteDatabase(path);

    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // SQL code to create the database table
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $table (
      nodeId TEXT NOT NULL,
      topicId TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      author TEXT NOT NULL,
      publishTime TEXT NOT NULL,
      replier TEXT,
      replyTime TEXT,
      replyCount TEXT NOT NULL,
      readTime TEXT,
      starredTime TEXT
    )
    ''');
  }

  Future<int> insertOrUpdate(Topic topic) async {
    Database db = await instance.database;
    if (await queryTopic(topic.id) != null) {
      return await update(topic);
    }
    return await db.insert(table, topic.toMap());
  }

  Future<Topic> queryTopic(String topicId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.query(table, where: 'topicId = ?', whereArgs: [topicId]);

    if (result.length > 0) {
      return Topic.fromMap(result.first);
    }

    return null;
  }

  Future<List<Topic>> updateStatus(List<Topic> list) async {
    for (var topic in list) {
      var val = await queryTopic(topic.id);
      if (val != null && val.readTime != null) {
//        print("${topic.title} : 存在，设为已读");
        topic.readTime = val.readTime;
        topic.starredTime = val.starredTime;
      } else {
//        print("${topic.title} : 不存在");
      }
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    return await db.query(table);
  }

  Future<List<Topic>> getRecentReadTopics() async {
    var mapList = await queryAllRows();
    List<Topic> topicList = List<Topic>();
    mapList.forEach((map) => topicList.insert(0, Topic.fromMap(map)));
    print("当前数据库共有${topicList.length}条记录");
    return topicList;
  }

  Future<List<Topic>> getStarredTopics() async {
    var mapList = await queryAllRows();
    List<Topic> topicList = List<Topic>();
    mapList.forEach((map) {
      Topic topic = Topic.fromMap(map);
      if (topic.starredTime != null) {
        topicList.insert(0, topic);
      }
    });
    print("当前数据库共有${topicList.length}条记录");
    return topicList;
  }

  Future<int> delAllRecentReadTopic() async {
    Database db = await instance.database;
    return await db.delete(table, where: 'readTime IS NOT null');
  }

  Future<int> delStarredTopic(Topic topic) async {
    topic.starredTime = null;
    return await update(topic);
  }

  Future<int> update(Topic topic) async {
    Database db = await instance.database;
    return await db.update(table, topic.toMap(),
        where: 'topicId = ?', whereArgs: [topic.id]);
  }

  Future<int> delete(String topicId) async {
    Database db = await instance.database;
    print("删除某条已读： " + topicId);
    return await db.delete(table, where: 'topicId = ?', whereArgs: [topicId]);
  }
}
