import 'package:communityfor1024/blocs/list/bloc.dart';
import 'package:communityfor1024/pages/home/page/home_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:oktoast/oktoast.dart';

// ignore: must_be_immutable
class IndexPage extends StatelessWidget {
  IndexPage({Key key}) : super(key: key);

  DateTime _lastPressedAt;

  @override
  Widget build(BuildContext context) {
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
        body: BlocProvider(
          create: (_) => TopicListBloc(),
          child: HomePage(),
        ),
      ),
    );
  }
}
