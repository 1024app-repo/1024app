import 'package:communityfor1024/blocs/detail/bloc.dart';
import 'package:communityfor1024/pages/topic_detail_page.dart';
import 'package:communityfor1024/util/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';
import 'package:url_launcher/url_launcher.dart';

import '../html_factory.dart';

class TopicContent extends StatelessWidget {
  final String content;
  final bool viewImage;

  const TopicContent({Key key, this.content, this.viewImage}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final kHTML = content.replaceAll('ess-data', 'data-src');
    final defaultStyle = DefaultTextStyle.of(context).style;
    final textStyle = defaultStyle.copyWith(fontSize: 16);

    return HtmlWidget(
      kHTML,
      hyperlinkColor: Colors.red,
      bodyPadding: const EdgeInsets.symmetric(vertical: 15),
      textStyle: textStyle,
      factoryBuilder: (config) => HtmlWidgetFactory(
        config,
        context: context,
        viewImage: viewImage,
      ),
      onTapUrl: (url) async {
        await _launchURL(context, url);
      },
    );
  }

  _launchURL(BuildContext context, String url) async {
    print(url);
    url = url
        .replaceFirst('http://www.viidii.info/?', '')
        .replaceAll('______', '.');
    if (url.startsWith('http://t66y.com') || url.startsWith(BASE_URL)) {
      var topicId = RegExp(r"[1-9]\d*").allMatches(url).last.group(0);
      final page = BlocProvider(
        create: (_) => TopicDetailBloc(),
        child: TopicDetailPage(topicId),
      );
      Navigator.push(
        context,
        new MaterialPageRoute(
          builder: (context) => page,
        ),
      );
      return;
    }
    // 去掉最后的 &z
    url = url.substring(0, url.length - 2);
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
