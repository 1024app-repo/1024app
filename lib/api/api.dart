import 'package:flutter/material.dart';
import 'package:html/dom.dart' as dom;
import 'package:html/parser.dart' show parse;
import 'package:oktoast/oktoast.dart';

import '../util/db_helper.dart';
import '../util/fetcher.dart';
import '../util/time_formatter.dart';
import '../util/utils.dart';
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
        '',
        e.text,
        e.attributes['href'],
        v.querySelector('.smalltxt.gray').text,
        [],
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
          node.id,
          regId.allMatches(h).last.group(0),
          t.text
              .replaceAll(RegExp(r'\s+'), "")
              .replaceAll(RegExp(r'\［'), '[')
              .replaceAll(RegExp(r'］'), ']'),
          v.querySelector('.bl').text.trim(),
          v.querySelector('.f12').text.trim(),
          r.parent.text.substring(r.parent.text.indexOf("by:") + 3).trim(),
          formatTime(DateTime.parse(r.text.trim()).millisecondsSinceEpoch),
          r.parent.previousElementSibling.text.trim(),
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
    await DbHelper.instance.updateStatus(node.topics);

    return node;
  }

  static Future<Topic> getTopicDetail(Topic topic, int page) async {
    var url = "read.php?";

    if (page > 1) {
      url += "tid=${topic.id}&page=$page";
    } else {
      url += "tid=${topic.id}&toread=1";
      topic.images = List<String>(); // 只在第一页拿图片列表
    }

    topic.replies = List<Reply>();
    var document = await Fetcher.invoke(url);

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
        a.querySelector("b").text.trim(),
        avatar,
        a.querySelector("font").text,
        v
            .querySelector(".tpc_content")
            .innerHtml
            .replaceAll('<h6 class="quote">Quote:</h6>', '<div></div>'),
        formatTime(DateTime.parse(time).millisecondsSinceEpoch),
        floor,
      );

      if (floor == "0") {
        topic.subject = reply;
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

  static Future replyTopic(String nodeId, String topicId, String title,
      String content, BuildContext context) async {
    var data = buildQueryString({
      'atc_usesign': 1,
      'atc_convert': 1,
      'atc_autourl': 1,
      'atc_title': 'Re:$title',
      'atc_content': content,
      'step': 2,
      'action': 'reply',
      'fid': nodeId,
      'tid': topicId,
      'atc_attachment': 'none',
      'pid': '',
      'article': '',
      'verify': 'verify',
    });

    var resp = await Fetcher.invoke(
      "post.php",
      method: 'POST',
      data: data,
    );

    if (resp.outerHtml.contains('發貼完畢')) {
      showToast('回复成功');
    } else {
      showToast(resp.querySelector('.f_one').text.trim());
    }
  }
}
