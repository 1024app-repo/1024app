import 'package:flutter/material.dart';

import '../../../api/model.dart';
import '../../../widgets/app_bar.dart';
import '../widgets/topics.dart';

var nodes = [
  Node(
    id: '7',
    name: "技術討論區",
    url: "thread0806.php?fid=7",
    desc: "日常生活 興趣交流 時事經濟 求助求檔 會員閑談吹水區",
    categories: [
      Category(
        id: '7',
        name: '所有主題',
        url: '/thread0806.php?fid=7',
      ),
      Category(
        id: '7',
        name: '今日主題',
        url: '/thread0806.php?fid=7&search=today',
      ),
      Category(
        id: '7',
        name: '精華主題',
        url: '/thread0806.php?fid=7&search=digest',
      ),
    ],
  ),
  Node(
    id: '8',
    name: "新時代的我們",
    url: "thread0806.php?fid=8",
    desc: "草榴貼圖區 加大你的帶寬! 加大你的內存! 加大你的顯示器!",
    categories: [
      Category(
        id: '8',
        name: '所有主題',
        url: '/thread0806.php?fid=8',
      ),
      Category(
        id: '8',
        name: '今日主題',
        url: '/thread0806.php?fid=8&search=today',
      ),
      Category(
        id: '8',
        name: '精華主題',
        url: '/thread0806.php?fid=8&search=digest',
      ),
      Category(
        id: '8',
        name: '亞洲',
        url: '/thread0806.php?fid=8&type=1',
      ),
      Category(
        id: '8',
        name: '歐美',
        url: '/thread0806.php?fid=8&type=2',
      ),
      Category(
        id: '8',
        name: '動漫',
        url: '/thread0806.php?fid=8&type=3',
      ),
      Category(
        id: '8',
        name: '寫真',
        url: '/thread0806.php?fid=8&type=4',
      ),
      Category(
        id: '8',
        name: '其他',
        url: '/thread0806.php?fid=8&type=12',
      ),
    ],
  ),
  Node(
    id: '16',
    name: "達蓋爾的旗幟",
    url: "thread0806.php?fid=16",
    desc: "草榴自拍區 分享你我光圈下的最美",
    categories: [
      Category(
        id: '16',
        name: '所有主題',
        url: '/thread0806.php?fid=16',
      ),
      Category(
        id: '16',
        name: '今日主題',
        url: '/thread0806.php?fid=16&search=today',
      ),
      Category(
        id: '16',
        name: '精華主題',
        url: '/thread0806.php?fid=16&search=digest',
      ),
    ],
  ),
  Node(
    id: '20',
    name: "成人文學交流區",
    url: "thread0806.php?fid=20",
    desc: "草榴文學區 歡迎各位發表",
    categories: [
      Category(
        id: '20',
        name: '所有主題',
        url: '/thread0806.php?fid=20',
      ),
      Category(
        id: '20',
        name: '今日主題',
        url: '/thread0806.php?fid=20&search=today',
      ),
      Category(
        id: '20',
        name: '精華主題',
        url: '/thread0806.php?fid=20&search=digest',
      ),
      Category(
        id: '20',
        name: '現代奇幻',
        url: '/thread0806.php?fid=20&type=1',
      ),
      Category(
        id: '20',
        name: '古典武俠',
        url: '/thread0806.php?fid=20&type=2',
      ),
      Category(
        id: '20',
        name: '另類禁忌',
        url: '/thread0806.php?fid=20&type=3',
      ),
      Category(
        id: '20',
        name: '性愛技巧',
        url: '/thread0806.php?fid=20&type=4',
      ),
      Category(
        id: '20',
        name: '笑話連篇',
        url: '/thread0806.php?fid=20&type=5',
      ),
      Category(
        id: '20',
        name: '有声小说',
        url: '/thread0806.php?fid=20&type=6',
      ),
      Category(
        id: '20',
        name: '其他交流',
        url: '/thread0806.php?fid=20&type=12',
      ),
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
        padding: const EdgeInsets.only(top: 20),
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
                            Node(
                              id: v.id,
                              name: v.name,
                              url: v.url,
                              desc: v.desc,
                              categories: v.categories,
                            ),
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
