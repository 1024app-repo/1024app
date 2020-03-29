import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;

import '../util/db_helper.dart';
import '../util/fetcher.dart';
import '../util/time_formatter.dart';
import 'model.dart';

RegExp regId = RegExp(r"[1-9]\d*");
RegExp regFloor = RegExp(r'\d+');
RegExp regLevel = RegExp(r'(?<=會員頭銜:\s)[^\s]*');
RegExp regPrestige = RegExp(r'(?<=威望:\s)[^\s]*(?=\s點)');
RegExp regMoney = RegExp(r'(?<=金錢:\s)[^\s]*(?=\sUSD)');
RegExp regContribution = RegExp(r'(?<=貢獻:\s)[^\s]*(?=\s點)');
RegExp regPosted = RegExp(r'(?<=發帖:\s)[^\s]*');

class API {
  static Future<List<Node>> getNodes() async {
    var document = await Fetcher.invoke("index.php");

    List<Node> nodes = List<Node>();
    document.querySelectorAll(".tr3.f_one").forEach((v) {
      var e = v.querySelector('h2 > a');
      nodes.add(Node(
        id: '',
        name: e.text,
        url: e.attributes['href'],
        desc: v.querySelector('.smalltxt.gray').text,
        categories: [],
      ));
    });

    return nodes;
  }

  static Future<Node> getNodeDetail(Node node, int page) async {
    var url = node.url;
    if (page > 1) {
      url += "&search=&page=$page";
    }

    node.topics = List<Topic>();
    var document = await Fetcher.invoke(url);

    document.querySelectorAll(".tr3.t_one.tac").forEach((v) {
      var t = v.querySelector('h3 > a');
      var r = v.querySelector('.f10');
      var h = t.attributes['href'];

      if (r != null) {
        Topic topic = Topic(
          id: regId.allMatches(h).last.group(0),
          title: t.text
              .replaceAll(RegExp(r'\s+'), "")
              .replaceAll(RegExp(r'\［'), '[')
              .replaceAll(RegExp(r'］'), ']'),
          author: v.querySelector('.bl').text.trim(),
          publishTime: v.querySelector('.f12').text.trim(),
          replier:
              r.parent.text.substring(r.parent.text.indexOf("by:") + 3).trim(),
          replyTime:
              formatTime(DateTime.parse(r.text.trim()).millisecondsSinceEpoch),
          replyCount: r.parent.previousElementSibling.text.trim(),
        );

        v.querySelectorAll(".sred").forEach((e) {
          if (e.text == "熱") {
            topic.hot = true;
          }
          if (e.text == "[精]") {
            topic.prime = true;
          }
        });

        node.topics.add(topic);
      }
    });

    var p = document.querySelector(".w70");
    if (p != null) {
      var v = p.querySelector('input').attributes['value'].split('/');
      node.current = int.parse(v[0]);
      node.total = int.parse(v[1]);
    }
    await DbHelper.instance.addReadState(node.topics);

    return node;
  }

  static Future<Topic> getTopicDetail(String topicId, int page) async {
    var url = "read.php?";

    Topic topic = new Topic(id: topicId);
    if (page > 1) {
      url += "tid=${topic.id}&page=$page";
    } else {
      url += "tid=${topic.id}&toread=1";
      topic.images = List<String>(); // 只在第一页拿图片列表
    }

    topic.replies = List<Reply>();
    var document = await Fetcher.invoke(url);

    // 解析帖子标题
    if (page < 2) {
      topic.title =
          document.querySelector('a[href="read.php?tid=${topic.id}"]').text;
    }

    // 帖子下的回复内容
    document.querySelectorAll(".t.t2").forEach((v) {
      var a = v.querySelector('.r_two');
      var t = v.querySelector(".tipad");
      // 有时可能会找不到这个 tipad 元素，就尝试去父级节点找
      if (t == null) {
        t = v.parent.querySelector('.tipad');
      }
      var i = t.text.indexOf("Posted:");

      var u = a.querySelector(".tac > img");
      var avatar;
      if (u != null) {
        avatar = u.attributes["src"].trim();
      }

      var g = regFloor.firstMatch(t.querySelector(".s3").text);
      var floor = g != null ? g.group(0) : "0";

      // 回帖的时间缺少秒，这边拼上00
      var time = (t.text.substring(i + 8, i + 24) + ':00').trim();

      Reply reply = Reply(
        author: a.querySelector("b").text.trim(),
        avatar: avatar,
        level: a.querySelector("font").text,
        content: v
            .querySelector(".tpc_content")
            .innerHtml
            .replaceAll('<h6 class="quote">Quote:</h6>', '<div></div>'),
        time: formatTime(DateTime.parse(time).millisecondsSinceEpoch),
        floor: floor,
      );

      if (floor == "0") {
        topic.subject = reply;
        topic.author = reply.author;
        topic.publishTime = reply.time;

        List<dom.Element> images = parse(topic.subject.content)
            .querySelectorAll("input[type='image'],img");
        if (images != null && images.isNotEmpty) {
          images.forEach((v) {
            if (v.attributes["ess-data"] != null) {
              topic.images.add(v.attributes["ess-data"].trim());
            }
          });
        }
      } else {
        topic.replies.add(reply);
      }
    });

    var p = document.querySelector(".w70");
    if (p != null) {
      var v = p.querySelector('input').attributes['value'].split('/');
      topic.current = int.parse(v[0]);
      topic.total = int.parse(v[1]);
    }

    return topic;
  }
}
