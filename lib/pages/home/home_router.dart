import 'package:fluro/fluro.dart';

import '../../pages/home/page/home_page.dart';
import '../../routers/routers.dart';

class HomeRouter implements IRouterProvider {
  static String homePage = "/home";

  @override
  void initRouter(Router router) {
    router.define(homePage,
        handler: Handler(handlerFunc: (_, params) => HomePage()));
  }
}
