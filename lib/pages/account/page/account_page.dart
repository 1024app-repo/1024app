import 'package:flutter/material.dart';

import '../../../routers/routers.dart';
import '../../../util/utils.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/list_title.dart';
import '../account_router.dart';

class AccountPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AccountPageState();
}

class AccountPageState extends State<AccountPage> {
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
    var myNavChildren = [
      MyListTitle(
        leading: Icon(Icons.access_time),
        title: Text("历史阅读"),
        onTap: () {
          Routes.push(context, AccountRouter.recentReadPage);
        },
      ),
      MyListTitle(
        leading: Icon(Icons.favorite_border),
        title: Text("我的收藏"),
        onTap: () {
          Routes.push(context, AccountRouter.favoriteTopicPage);
        },
      ),
      MyListTitle(
        leading: Icon(Icons.cached),
        title: Text("清除缓存"),
        content: cacheSize ?? '计算中...',
        onTap: () {
          clearCache().then((_) => getCacheSize());
        },
      ),
      MyListTitle(
        leading: Icon(Icons.info_outline),
        title: Text("关于"),
        onTap: () {
          Routes.push(context, AccountRouter.aboutPage);
        },
      ),
    ];

    return Scaffold(
      appBar: MyAppBar(title: '个人'),
      body: Container(
        child: Column(children: myNavChildren),
      ),
    );
  }
}
