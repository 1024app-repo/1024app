import 'package:flutter/material.dart';

import '../../../widgets/app_bar.dart';

class PrivateMessagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => PrivateMessagePageState();
}

class PrivateMessagePageState extends State<PrivateMessagePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: "我的消息"),
      body: Container(
        child: Center(
          child: Text('我的消息'),
        ),
      ),
    );
  }
}
