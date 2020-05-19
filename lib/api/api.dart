import '../util/fetcher.dart';
import '../util/time_formatter.dart';
import 'model.dart';

RegExp regNodeId = RegExp(r"(?<=fid=)([1-9]\d*)");
RegExp regTopicId = RegExp(r"[1-9]\d*");
RegExp regFloor = RegExp(r"(?<=',')(\d+)(?=',')");
RegExp regLevel = RegExp(r'(?<=會員頭銜:\s)[^\s]*');
RegExp regPrestige = RegExp(r'(?<=威望:\s)[^\s]*(?=\s點)');
RegExp regMoney = RegExp(r'(?<=金錢:\s)[^\s]*(?=\sUSD)');
RegExp regContribution = RegExp(r'(?<=貢獻:\s)[^\s]*(?=\s點)');
RegExp regPosted = RegExp(r'(?<=發帖:\s)[^\s]*');

class API {
  static Future<List<Node>> getNodeList() async {
    var document = await Fetcher.invoke("index.php");

    List<Node> nodes = List<Node>();
    document.querySelectorAll(".tr3.f_one").forEach((v) {
      var e = v.querySelector('h2 > a');
      var nodeId = regNodeId.allMatches(e.attributes['href']).last.group(0);
      if (nodeId != '10') {
        nodes.add(Node(
          id: nodeId,
          name: e.text,
        ));
      }
    });

    return nodes;
  }

  static Future<Result<Topic>> getTopicList(String nodeId, int page) async {
    var url = "thread0806.php?fid=$nodeId";
    if (page > 1) {
      url += "&search=&page=$page";
    }

    List<Topic> topics = List<Topic>();
    var current = 1;
    var total = 1;
    var document = await Fetcher.invoke(url);

    document.querySelectorAll(".tr3.t_one.tac").forEach((v) {
      var t = v.querySelector('h3 > a');
      var r = v.querySelector('.f10');
      var h = t.attributes['href'];

      if (r != null) {
        Topic topic = Topic(
          id: regTopicId.allMatches(h).last.group(0),
          title: t.text
              .replaceAll(RegExp(r'\s+'), "")
              .replaceAll(RegExp(r'\［'), '[')
              .replaceAll(RegExp(r'］'), ']'),
          author: v.querySelector('.bl').text.trim(),
          publishTime: v.querySelector('.f12').text.trim(),
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

        topics.add(topic);
      }
    });

    var p = document.querySelector(".w70");
    if (p != null) {
      var v = p.querySelector('input').attributes['value'].split('/');
      current = int.parse(v[0]);
      total = int.parse(v[1]);
    }

    return Result(rows: topics, page: current, total: total);
  }

  static Future<Result<Reply>> getTopicDetail(String topicId, int page) async {
    var url = "read.php?";
    if (page > 1) {
      url += "tid=$topicId&page=$page";
    } else {
      url += "tid=$topicId&toread=1";
//      topic.images = List<String>(); // 只在第一页拿图片列表
    }
    print(url);

    List<Reply> replies = List<Reply>();
    var current = 1;
    var total = 1;
    var document = await Fetcher.invoke(url);

    // 帖子下的回复内容
    document.querySelectorAll(".t.t2").forEach((v) {
      var a = v.querySelector('.r_two');
      var t = v.querySelector(".tipad");
      // 有时可能会找不到这个 tipad 元素，就尝试去父级节点找
      if (t == null) {
        t = v.parent.querySelector('.tipad');
      }
      var i = t.text.indexOf("Posted:");

      // 从 onclick 中获取楼层，2020.5.19 fixed
      var g = regFloor
          .firstMatch(t.querySelectorAll('a').last.attributes['onclick']);
      var floor = g != null ? g.group(0) : "0";

      // 回帖的时间缺少秒，这边拼上00
      var time = (t.text.substring(i + 8, i + 24) + ':00').trim();

      Reply reply = Reply(
        author: a.querySelector("b").text.trim(),
        level: a.querySelector("font").text,
        content: v
            .querySelector(".tpc_content")
            .innerHtml
            .replaceAll('<h6 class="quote">Quote:</h6>', '<div></div>'),
        time: formatTime(DateTime.parse(time).millisecondsSinceEpoch),
        floor: floor,
      );

      if (floor == "0") {
        reply.title =
            document.querySelector('a[href="read.php?tid=$topicId"]').text;
      }
      replies.add(reply);
    });

    var p = document.querySelector(".w70");
    if (p != null) {
      var v = p.querySelector('input').attributes['value'].split('/');
      current = int.parse(v[0]);
      total = int.parse(v[1]);
    }

    return Result(rows: replies, page: current, total: total);
  }
}
