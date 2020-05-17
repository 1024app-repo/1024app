import 'dart:io';

import 'package:communityfor1024/api/api.dart';
import 'package:communityfor1024/api/model.dart';
import 'package:communityfor1024/blocs/theme/bloc.dart';
import 'package:communityfor1024/pages/index.dart';
import 'package:communityfor1024/util/fetcher.dart';
import 'package:communityfor1024/util/sp_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
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

  await _initAsync();

  return runApp(MyApp());
}

List<Node> nodes;
int initialIndex;

Future _initAsync() async {
  SpHelper.sp = await SharedPreferences.getInstance();
  await Fetcher.init();
  nodes = await API.getNodeList();
  initialIndex = nodes.indexWhere((Node e) => e.id == '7');
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider<ThemeBloc>(
      create: (_) => ThemeBloc(),
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return MaterialApp(
            home: IndexPage(nodes, initialIndex),
            theme: state.getTheme(),
            themeMode: SpHelper.getThemeMode(),
            darkTheme: state.getTheme(isDark: true),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: const [Locale('zh', 'CH')],
          );
        },
      ),
    );
  }
}
