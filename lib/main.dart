import 'dart:io';

import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:oktoast/oktoast.dart';

import 'routers/routers.dart';
import 'util/fetcher.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  const maxBytes = 768 * (1 << 20);
  // Invoke both method names to ensure the correct one gets invoked.
  SystemChannels.skia.invokeMethod('setResourceCacheMaxBytes', maxBytes);
  SystemChannels.skia.invokeMethod('Skia.setResourceCacheMaxBytes', maxBytes);

  // 强制竖屏
  SystemChrome.setPreferredOrientations(
    [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
  );

  // 透明状态栏
  if (Platform.isAndroid) {
    SystemUiOverlayStyle systemUiOverlayStyle =
        SystemUiOverlayStyle(statusBarColor: Colors.transparent);
    SystemChrome.setSystemUIOverlayStyle(systemUiOverlayStyle);
  }

  _initAsync();

  return runApp(MyApp());
}

void _initAsync() async {
  await Fetcher.init();
}

class MyApp extends StatelessWidget {
  final Widget home;

  MyApp({this.home}) {
    final router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
  }

  @override
  Widget build(BuildContext context) {
    return OKToast(
      child: MaterialApp(
        home: home,
        onGenerateRoute: Application.router.generator,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
        ],
        supportedLocales: const [Locale('zh', 'CH'), Locale('en', 'US')],
      ),
      backgroundColor: Colors.grey[800],
      textPadding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
      radius: 20.0,
      position: ToastPosition.bottom,
    );
  }
}
