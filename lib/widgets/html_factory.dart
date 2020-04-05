import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:communityfor1024/util/image_optimizer.dart';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart' as crypto;
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html_core/flutter_widget_from_html_core.dart';

import 'image_view.dart';

class HtmlWidgetFactory extends WidgetFactory {
  BuildContext context;
  bool viewImage;

  HtmlWidgetFactory(HtmlWidgetConfig config,
      {this.context, this.viewImage = false})
      : super(config);

  @override
  ImageProvider buildImageFromUrl(String url) =>
      url?.isNotEmpty == true ? CachedNetworkImageProvider(url) : null;

  @override
  Widget buildImage(String url, {double height, String text, double width}) {
    url = getOptimizedImage(url);
    final imageWidget = super.buildImage(
      url,
      height: height,
      text: text,
      width: width,
    );

    if (viewImage) {
      var tag = generateMd5(url);
      return GestureDetector(
        child: Hero(
          tag: tag,
          child: imageWidget,
        ),
        onTap: () {
          print(url);
          Navigator.of(context).push(
            new FadeRoute(
              page: ImageView(
                imageProvider: CachedNetworkImageProvider(url),
                heroTag: tag,
              ),
            ),
          );
        },
      );
    }
    return imageWidget;
  }

  @override
  NodeMetadata parseLocalName(NodeMetadata meta, String localName) {
    meta = super.parseLocalName(meta, localName);

    switch (localName) {
      case 'blockquote':
        meta = lazySet(
          meta,
          styles: ['margin', '0 0 5px 0'],
          buildOp: buildBlockquoteOp(),
        );
        break;
      case 'img':
        meta = lazySet(
          meta,
          styles: ['margin', '2px 0'],
        );
        break;
    }

    return meta;
  }

  // 重写引用的样式
  BuildOp buildBlockquoteOp() {
    return BuildOp(
      onWidgets: (_, Iterable<Widget> widgets) => widgets.map(
        (Widget widget) => Container(
          padding: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Colors.grey[300],
          ),
          child: widget,
        ),
      ),
    );
  }
}

generateMd5(String data) {
  var content = new Utf8Encoder().convert(data);
  var md5 = crypto.md5;
  var digest = md5.convert(content);
  return hex.encode(digest.bytes);
}
