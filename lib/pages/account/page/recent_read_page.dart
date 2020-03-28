import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../../api/model.dart';
import '../../../util/db_helper.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/topic/topic_item.dart';

class RecentReadPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return RecentReadPageState();
  }
}

class RecentReadPageState extends State<RecentReadPage> {
  bool hasData = false;

  var dbHelper = DbHelper.instance;

  Future<List<Topic>> topicListFuture;

  Future<List<Topic>> getTopics() async {
    return await dbHelper.getRecentReadTopics();
  }

  @override
  void initState() {
    super.initState();
    topicListFuture = getTopics();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "历史阅读"),
      body: FutureBuilder<List<Topic>>(
          future: topicListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              hasData = snapshot.data.length > 0;

              snapshot.data.forEach((Topic topic) {
                topic.readTime = null;
              });

              return Offstage(
                child: Container(
                  child: Scrollbar(
                    child: ListView.separated(
                      itemBuilder: (context, index) => TopicItemView(
                        snapshot.data[index],
                      ),
                      separatorBuilder: (BuildContext context, int index) {
                        return Divider(height: 0.0);
                      },
                      itemCount: snapshot.data.length,
                    ),
                  ),
                ),
                offstage: snapshot.data.length < 1,
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text("oops"),
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
