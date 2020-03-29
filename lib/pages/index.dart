import 'package:flutter/material.dart';
import 'package:oktoast/oktoast.dart';
import 'package:provider/provider.dart';

import '../util/event_bus.dart';
import 'account/page/account_page.dart';
import 'community/page/community_page.dart';
import 'home/page/home_page.dart';

class IndexPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      child: BottomNav(),
      create: (context) => BottomNavigationBarProvider(),
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  int _currentIndex = 0;

  get currentIndex => _currentIndex;

  set currentIndex(val) {
    _currentIndex = val;
    notifyListeners();
  }
}

// ignore: must_be_immutable
class BottomNav extends StatelessWidget {
  BottomNav({Key key}) : super(key: key);

  DateTime _lastPressedAt;

  PageController _pageController = new PageController(initialPage: 0);

  final _pages = [
    HomePage(),
    CommunityPage(),
    AccountPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavigationBarProvider>(context);

    return WillPopScope(
      onWillPop: () async {
        if (_lastPressedAt == null ||
            DateTime.now().difference(_lastPressedAt) > Duration(seconds: 1)) {
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
            provider.currentIndex = index;
          },
          children: _pages,
          physics: NeverScrollableScrollPhysics(), // 禁止滑动
        ),
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: provider.currentIndex,
          onTap: (index) {
            if (index != provider.currentIndex) {
              _pageController.jumpToPage(index);
            } else if (index == 0) {
              eventBus.emit('RefreshTopicsEvent');
            }
          },
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
          elevation: 5,
        ),
      ),
    );
  }
}
