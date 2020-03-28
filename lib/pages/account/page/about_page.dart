import 'package:flutter/material.dart';

import '../../../widgets/app_bar.dart';

class AboutPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => AboutPageState();
}

class AboutPageState extends State<AboutPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '关于'),
      body: Center(
        child: Text('about'),
      ),
    );
  }
}
