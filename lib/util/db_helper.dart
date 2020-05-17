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
      topicId TEXT PRIMARY KEY,
      title TEXT NOT NULL,
      author TEXT NOT NULL,
      publishTime TEXT NOT NULL,
      replyTime TEXT,
      replyCount TEXT
    );
    ''');
  }

  Future<int> insert(Topic topic) async {
    Database db = await instance.database;

    if (await query(topic.id) != null) {
      return await update(topic);
    }
    return await db.insert(table, topic.toMap());
  }

  Future<int> deleteAll() async {
    Database db = await instance.database;
    return await db.delete(table);
  }

  Future<List<Topic>> queryAll() async {
    Database db = await instance.database;
    var mapList = await db.query(table);
    List<Topic> topicList = List<Topic>();
    mapList.forEach((map) => topicList.insert(0, Topic.fromMap(map)));
    return topicList;
  }

  Future<Topic> query(String topicId) async {
    Database db = await instance.database;
    List<Map<String, dynamic>> result =
        await db.query(table, where: 'topicId = ?', whereArgs: [topicId]);

    if (result.length > 0) {
      return Topic.fromMap(result.first);
    }

    return null;
  }

  Future<int> update(Topic topic) async {
    Database db = await instance.database;
    return await db.update(table, topic.toMap(),
        where: 'topicId = ?', whereArgs: [topic.id]);
  }
}
