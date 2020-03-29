import 'package:fluro/fluro.dart';

import '../../routers/routers.dart';
import 'page/about_page.dart';
import 'page/account_page.dart';
import 'page/recent_read_page.dart';

class AccountRouter implements IRouterProvider {
  static String accountPage = "/account";
  static String recentReadPage = "/account/recentRead";
  static String aboutPage = "/account/about";

  @override
  void initRouter(Router router) {
    router.define(accountPage,
        handler: Handler(handlerFunc: (_, params) => AccountPage()));
    router.define(recentReadPage,
        handler: Handler(handlerFunc: (_, params) => RecentReadPage()));
    router.define(aboutPage,
        handler: Handler(handlerFunc: (_, params) => AboutPage()));
  }
}
