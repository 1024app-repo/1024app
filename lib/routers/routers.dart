import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

import '../pages/account/account_router.dart';
import '../pages/home/home_router.dart';
import '../pages/index.dart';

class Application {
  static Router router;
}

abstract class IRouterProvider {
  void initRouter(Router router);
}

class Routes {
  static List<IRouterProvider> _routers = [];

  static void configureRoutes(Router router) {
    router.define('/',
        handler: Handler(
            handlerFunc:
                (BuildContext context, Map<String, List<String>> params) =>
                    IndexPage()));

    _routers.clear();

    _routers.add(HomeRouter());
    _routers.add(AccountRouter());

    _routers.forEach((routerProvider) {
      routerProvider.initRouter(router);
    });
  }

  static Future<dynamic> push(BuildContext context, String path,
      {bool replace = false, bool clearStack = false}) {
    FocusScope.of(context).unfocus();
    return Application.router.navigateTo(context, path,
        replace: replace,
        clearStack: clearStack,
        transition: TransitionType.native);
  }

  static void goBack(BuildContext context) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context);
  }

  static void goBackWithResult(BuildContext context, result) {
    FocusScope.of(context).unfocus();
    Navigator.pop(context, result);
  }
}
