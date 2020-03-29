import 'package:communityfor1024/pages/detail/page/topic_detail_page.dart';
import 'package:communityfor1024/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

import '../html_factory.dart';

class TopicContent extends StatelessWidget {
  final String content;

  const TopicContent({Key key, this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return HtmlWidget(
      content.replaceAll('ess-data', 'data-src'),
      bodyPadding: const EdgeInsets.symmetric(vertical: 15),
      factoryBuilder: (config) => HtmlWidgetFactory(config),
      onTapUrl: (url) async {
        await _launchURL(context, url);
      },
    );
  }

  _launchURL(BuildContext context, String url) async {
    url = url
        .replaceFirst('http://www.viidii.info/?', '')
        .replaceAll('______', '.');
    if (url.startsWith('http://t66y.com') || url.startsWith(BASE_URL)) {
      var topicId = RegExp(r"[1-9]\d*").allMatches(url).last.group(0);
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => new TopicDetailPage(topicId),
        ),
      );
      return;
    }
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
