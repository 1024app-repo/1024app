import 'package:communityfor1024/pages/drawer/page/about_page.dart';
import 'package:communityfor1024/pages/drawer/page/recent_read_page.dart';
import 'package:communityfor1024/routers/routers.dart';
import 'package:fluro/fluro.dart';

class DrawerRouter implements IRouterProvider {
  static String recentReadPage = "/account/recentRead";
  static String aboutPage = "/account/about";

  @override
  void initRouter(Router router) {
    router.define(recentReadPage,
        handler: Handler(handlerFunc: (_, params) => RecentReadPage()));
    router.define(aboutPage,
        handler: Handler(handlerFunc: (_, params) => AboutPage()));
  }
}
