import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../util/event_bus.dart';
import 'account/page/account_page.dart';
import 'community/page/community_page.dart';
import 'home/page/home_page.dart';

class IndexProvider extends ValueNotifier<int> {
  IndexProvider() : super(0);
}

class Index extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => IndexState();
}

class IndexState extends State<Index> {
  DateTime _lastPressedAt;

  PageController _pageController = new PageController(initialPage: 0);
  IndexProvider provider = IndexProvider();

  List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    initData();
  }

  void initData() {
    _pages = [
      HomePage(),
      CommunityPage(),
      AccountPage(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<IndexProvider>(
      builder: (_) => provider,
      child: WillPopScope(
        onWillPop: () async {
          if (_lastPressedAt == null ||
              DateTime.now().difference(_lastPressedAt) >
                  Duration(seconds: 1)) {
            _lastPressedAt = DateTime.now();
            showToast('再次点击退出应用');
            return false;
          }
          return true;
        },
        child: Scaffold(
          body: PageView(
            controller: _pageController,
            onPageChanged: (index) {
              provider.value = index;
            },
            children: _pages,
            physics: NeverScrollableScrollPhysics(), // 禁止滑动
          ),
          bottomNavigationBar: Consumer<IndexProvider>(
            builder: (_, provider, __) {
              return BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    title: Text("首页"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.dashboard),
                    title: Text("社区"),
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.person),
                    title: Text("个人"),
                  )
                ],
                currentIndex: provider.value,
                selectedItemColor: Theme.of(context).accentColor,
                onTap: (index) {
                  if (index != provider.value) {
                    _pageController.jumpToPage(index);
                  } else if (index == 0) {
                    eventBus.emit('RefreshTopicsEvent');
//                  } else if (index == 2) {
//                    eventBus.emit('RefreshPropertyEvent');
                  }
                },
                elevation: 5,
              );
            },
          ),
        ),
      ),
    );
  }
}
