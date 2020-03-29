import 'package:flutter/material.dart';

import '../../../widgets/app_bar.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '关于'),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Text('草榴非官方客户端'),
      ),
    );
  }
}
