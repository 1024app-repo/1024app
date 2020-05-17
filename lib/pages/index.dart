import 'package:communityfor1024/api/model.dart';
import 'package:communityfor1024/blocs/list/bloc.dart';
import 'package:communityfor1024/pages/about_page.dart';
import 'package:communityfor1024/pages/image_quality_page.dart';
import 'package:communityfor1024/pages/reading_page.dart';
import 'package:communityfor1024/pages/theme_page.dart';
import 'package:communityfor1024/util/utils.dart';
import 'package:communityfor1024/widgets/app_bar.dart';
import 'package:communityfor1024/widgets/list_title.dart';
import 'package:communityfor1024/widgets/topic/topics.dart';
import 'package:communityfor1024/widgets/vertical_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_inner_drawer/inner_drawer.dart';

class IndexPage extends StatefulWidget {
  final List<Node> nodes;
  final int initialIndex;

  IndexPage(this.nodes, this.initialIndex);

  @override
  IndexPageState createState() {
    return IndexPageState();
  }
}

class IndexPageState extends State<IndexPage>
    with AutomaticKeepAliveClientMixin {
  final GlobalKey<InnerDrawerState> _innerDrawerKey =
      GlobalKey<InnerDrawerState>();

  PageController _pageController;
  int currentIndex;
  DateTime _lastPressedAt;
  String cacheSize;

  @override
  void initState() {
    currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: currentIndex);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
          _lastPressedAt = DateTime.now();
          return false;
        }
        return true;
      },
      child: Scaffold(
        body: BlocProvider(
          create: (_) => TopicListBloc(),
          child: InnerDrawer(
            key: _innerDrawerKey,
            onTapClose: true,
            offset: IDOffset.only(left: 0.2),
            leftChild: leftChild(),
            rightChild: rightChild(),
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            scaffold: Scaffold(
              appBar: MyAppBar(
                title: widget.nodes[currentIndex].name,
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () {
                    _innerDrawerKey.currentState.toggle(
                      direction: InnerDrawerDirection.start,
                    );
                  },
                ),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.more_horiz),
                    onPressed: () {
                      _innerDrawerKey.currentState.toggle(
                        direction: InnerDrawerDirection.end,
                      );
                    },
                  )
                ],
                automaticallyImplyLeading: false,
              ),
              body: PageView(
                controller: _pageController,
                children: widget.nodes.map((Node e) {
                  //创建3个Tab页
                  return BlocProvider(
                    create: (_) => TopicListBloc(),
                    child: TopicsView(e),
                  );
                }).toList(),
                physics: NeverScrollableScrollPhysics(),
              ),
            ),
            innerDrawerCallback: (bool isOpened) {
              if (isOpened) {
                getCacheSize();
              }
            },
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => false;

  Widget leftChild() {
    return Container(
      margin: const EdgeInsets.only(top: 200),
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: Colors.grey,
                  width: 0.2,
                ),
              ),
            ),
            child: MyListTitle(
              leading: const Icon(Icons.access_time),
              title: Text("历史阅读"),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  new MaterialPageRoute(
                    builder: (context) => ReadingPage(),
                  ),
                );
              },
              elevation: 0,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            decoration: BoxDecoration(
              border: Border.symmetric(
                vertical: BorderSide(
                  color: Colors.grey,
                  width: 0.2,
                ),
              ),
            ),
            child: Column(
              children: <Widget>[
                MyListTitle(
                  leading: const Icon(Icons.memory),
                  title: Text("图片质量"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => ImageQualityPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0, indent: 15),
                MyListTitle(
                  leading: const Icon(Icons.cached),
                  title: Text("清除缓存"),
                  content: Text(
                    cacheSize ?? '计算中...',
                    textAlign: TextAlign.right,
                    style: TextStyle(
                      color: Theme.of(context).hintColor,
                      fontSize: 12,
                    ),
                  ),
                  onTap: () {
                    clearCache().then((_) => getCacheSize());
                  },
                ),
                const Divider(height: 0, indent: 15),
                MyListTitle(
                  leading: const Icon(Icons.tonality),
                  title: Text("外观模式"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => ThemePage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 0, indent: 15),
                MyListTitle(
                  leading: const Icon(Icons.info_outline),
                  title: Text("关于"),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      new MaterialPageRoute(
                        builder: (context) => AboutPage(),
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        ],
        physics: NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget rightChild() {
    return VerticalTabs(
      initialIndex: currentIndex,
      tabs: widget.nodes.map((Node v) => Tab(text: v.name)).toList(),
      onSelect: (int i) {
        setState(() {
          currentIndex = i;
        });
        _innerDrawerKey.currentState.close(
          direction: InnerDrawerDirection.end,
        );
        _pageController.jumpToPage(i);
      },
    );
  }

  getCacheSize() {
    loadCache().then((v) => setState(() => cacheSize = v));
  }
}
