import 'package:communityfor1024/api/model.dart';
import 'package:communityfor1024/blocs/list/bloc.dart';
import 'package:communityfor1024/pages/drawer/drawer_router.dart';
import 'package:communityfor1024/routers/routers.dart';
import 'package:communityfor1024/util/constants.dart';
import 'package:communityfor1024/util/utils.dart';
import 'package:communityfor1024/widgets/topic/topics.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyDrawer extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => MyDrawerState();
}

class MyDrawerState extends State<MyDrawer> {
  var cacheSize;

  @override
  void initState() {
    super.initState();
    getCacheSize();
  }

  getCacheSize() {
    loadCache().then((v) => setState(() => cacheSize = v));
  }

  @override
  Widget build(BuildContext context) {
    var nodeList = nodes
        .map((Node v) => ListTile(
              title: Text(v.name),
              onTap: () {
                final page = BlocProvider(
                  create: (_) => TopicListBloc(),
                  child: TopicsView(
                    Node(
                      id: v.id,
                      name: v.name,
                    ),
                  ),
                );
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => page,
                  ),
                );
              },
            ))
        .toList();

    return SizedBox(
      width: 250,
      child: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Container(
              height: 200,
              color: Colors.indigo,
//              decoration: BoxDecoration(
//                image: DecorationImage(
//                  fit: BoxFit.cover,
//                  image: NetworkImage(
//                      "https://i.loli.net/2019/05/20/5ce2710ba8d5d69212.png"),
//                ),
//              ),
            ),
            // 可在这里替换自定义的header
            ListTile(
              title: Text("历史阅读"),
              leading: const Icon(Icons.access_time),
              onTap: () {
                Navigator.pop(context);
                Routes.push(context, DrawerRouter.recentReadPage);
              },
            ),
            Divider(),
            nodeList[0],
            nodeList[1],
            nodeList[2],
            nodeList[3],
            Divider(),
            ListTile(
              title: Text("清除缓存"),
              leading: const Icon(Icons.cached),
              subtitle: Text(cacheSize ?? '计算中...'),
              onTap: () {
                Navigator.pop(context);
                clearCache().then((_) => getCacheSize());
              },
            ),
            ListTile(
              title: Text("关于"),
              leading: const Icon(Icons.info_outline),
              onTap: () {
                Navigator.pop(context);
                Routes.push(context, DrawerRouter.aboutPage);
              },
            ),
          ],
        ),
      ),
    );
  }
}
