import 'package:communityfor1024/widgets/topic/topic_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../api/model.dart';
import '../util/db_helper.dart';
import '../widgets/app_bar.dart';

class ReadingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return ReadingPageState();
  }
}

class ReadingPageState extends State<ReadingPage> {
  bool hasData = false;

  var dbHelper = DbHelper.instance;

  Future<List<Topic>> topicListFuture;

  Future<List<Topic>> getTopics() async {
    return await dbHelper.queryAll();
  }

  @override
  void initState() {
    super.initState();
    topicListFuture = getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(
        title: "历史阅读",
        actions: <Widget>[
          IconButton(
            icon: Icon(
              Icons.delete_sweep,
            ),
            onPressed: () async {
              HapticFeedback.heavyImpact();
              await dbHelper.deleteAll();
              setState(() {
                topicListFuture = getTopics();
              });
            },
          )
        ],
      ),
      body: FutureBuilder<List<Topic>>(
          future: topicListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              hasData = snapshot.data.length > 0;

              return Offstage(
                child: Container(
                  child: Scrollbar(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var item = snapshot.data[index];
                        return TopicItem(topic: item);
                      },
                      separatorBuilder: (BuildContext context, int index) {
                        return const Divider(height: 0.0);
                      },
                      itemCount: snapshot.data.length,
                    ),
                  ),
                ),
                offstage: snapshot.data.length < 1,
              );
            }
            return SpinKitWave(
              color: Theme.of(context).primaryColorLight,
              type: SpinKitWaveType.start,
              size: 20,
            );
          }),
    );
  }
}
