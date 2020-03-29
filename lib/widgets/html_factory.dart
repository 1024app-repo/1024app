import 'package:communityfor1024/util/image_optimizer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class HtmlWidgetFactory extends WidgetFactory {
  HtmlWidgetFactory(HtmlWidgetConfig config) : super(config);

  @override
  Widget buildImage(String url, {double height, String text, double width}) {
    url = getOptimizedImage(url);
    final imageWidget = super.buildImage(
      url,
      height: height,
      text: text,
      width: width,
    );
    if (imageWidget == null) return imageWidget;

    return GestureDetector(
      child: imageWidget,
      onTap: () => print(url),
    );
  }

  @override
  NodeMetadata parseLocalName(NodeMetadata meta, String localName) {
    meta = super.parseLocalName(meta, localName);

    if (localName == 'blockquote') {
      meta = lazySet(
        meta,
        styles: ['margin', '0 0 5px 0'],
        buildOp: buildBlockquoteOp(),
      );
    }
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
          styles: ['margin', '5px 0'],
          buildOp: buildImageOp(),
        );
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
            borderRadius: BorderRadius.circular(5.0),
            color: Colors.grey[300],
          ),
          child: widget,
        ),
      ),
    );
  }

  // 重写图片样式，加圆角
  BuildOp buildImageOp() {
    return BuildOp(
      onWidgets: (_, Iterable<Widget> widgets) => widgets.map(
        (Widget widget) => ClipRRect(
          borderRadius: BorderRadius.circular(10.0),
          child: widget,
        ),
      ),
    );
  }

  BuildOp buildTagA() {
    return BuildOp();
  }
}
