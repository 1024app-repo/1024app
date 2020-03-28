import 'package:flutter/material.dart';

import '../../../api/model.dart';
import '../../../widgets/app_bar.dart';
import '../../../widgets/topic/topics.dart';

var nodes = [
  Node(
    '7',
    "技術討論區",
    "thread0806.php?fid=7",
    "日常生活 興趣交流 時事經濟 求助求檔 會員閑談吹水區",
    [
      Category('7', '所有主題', '/thread0806.php?fid=7'),
      Category('7', '今日主題', '/thread0806.php?fid=7&search=today'),
      Category('7', '精華主題', '/thread0806.php?fid=7&search=digest'),
    ],
  ),
  Node(
    '8',
    "新時代的我們",
    "thread0806.php?fid=8",
    "草榴貼圖區 加大你的帶寬! 加大你的內存! 加大你的顯示器!",
    [
      Category('8', '所有主題', '/thread0806.php?fid=8'),
      Category('8', '今日主題', '/thread0806.php?fid=8&search=today'),
      Category('8', '精華主題', '/thread0806.php?fid=8&search=digest'),
      Category('8', '亞洲', '/thread0806.php?fid=8&type=1'),
      Category('8', '歐美', '/thread0806.php?fid=8&type=2'),
      Category('8', '動漫', '/thread0806.php?fid=8&type=3'),
      Category('8', '寫真', '/thread0806.php?fid=8&type=4'),
      Category('8', '其他', '/thread0806.php?fid=8&type=12'),
    ],
  ),
  Node(
    '16',
    "達蓋爾的旗幟",
    "thread0806.php?fid=16",
    "草榴自拍區 分享你我光圈下的最美",
    [
      Category('16', '所有主題', '/thread0806.php?fid=16'),
      Category('16', '今日主題', '/thread0806.php?fid=16&search=today'),
      Category('16', '精華主題', '/thread0806.php?fid=16&search=digest'),
    ],
  ),
  Node(
    '20',
    "成人文學交流區",
    "thread0806.php?fid=20",
    "草榴文學區 歡迎各位發表",
    [
      Category('20', '所有主題', '/thread0806.php?fid=20'),
      Category('20', '今日主題', '/thread0806.php?fid=20&search=today'),
      Category('20', '精華主題', '/thread0806.php?fid=20&search=digest'),
      Category('20', '現代奇幻', '/thread0806.php?fid=20&type=1'),
      Category('20', '古典武俠', '/thread0806.php?fid=20&type=2'),
      Category('20', '另類禁忌', '/thread0806.php?fid=20&type=3'),
      Category('20', '性愛技巧', '/thread0806.php?fid=20&type=4'),
      Category('20', '笑話連篇', '/thread0806.php?fid=20&type=5'),
      Category('20', '有声小说', '/thread0806.php?fid=20&type=6'),
      Category('20', '其他交流', '/thread0806.php?fid=20&type=12'),
    ],
  ),
];

class CommunityPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => CommunityPageState();
}

class CommunityPageState extends State<CommunityPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: MyAppBar(title: '社区'),
      body: Container(
        padding: EdgeInsets.only(top: 20),
        child: ListView(
          children: nodes
              .map((Node v) => ListTile(
                    title: Text(v.name),
                    subtitle: Text(
                      v.desc,
                      style: TextStyle(fontSize: 12),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => TopicsView(
                            Node(v.id, v.name, v.url, v.desc, v.categories),
                          ),
                        ),
                      );
                    },
                  ))
              .toList(),
        ),
      ),
    );
  }
}
