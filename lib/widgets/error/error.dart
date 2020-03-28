import 'package:flutter/material.dart';

typedef OnPressCallback = Future<void> Function();

class NetworkError extends StatelessWidget {
  final OnPressCallback onPress;

  const NetworkError({this.onPress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 80),
      width: double.infinity,
      height: double.infinity,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image(
              image: AssetImage("assets/ic_error.png"),
              width: 80,
              height: 80,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: Text("网络请求失败，请检查您的网络",
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  )),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(0, 20, 0, 0),
              child: OutlineButton(
                child: Text("重新加载",
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w600,
                    )),
                onPressed: onPress,
              ),
            )
          ],
        ),
      ),
    );
  }
}
