import 'package:cached_network_image/cached_network_image.dart';
import 'package:communityfor1024/util/image_optimizer.dart';
import 'package:flutter/material.dart';
import 'package:identicon/identicon.dart';

class CircleAvatarWithPlaceholder extends StatelessWidget {
  final String imageUrl;
  final String userName;
  final double size;

  const CircleAvatarWithPlaceholder(
      {Key key, this.imageUrl, this.userName, this.size})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var identicon = Image.memory(
      Identicon().generate(userName),
      width: size,
      height: size,
      gaplessPlayback: true,
    );

    return ClipOval(
      child: imageUrl != null
          ? CachedNetworkImage(
              imageUrl: getOptimizedImage(imageUrl),
              imageBuilder: (context, imageProvider) => Image.network(
                getOptimizedImage(imageUrl),
                width: size,
                height: size,
                gaplessPlayback: true,
              ),
              placeholder: (context, url) => identicon,
            )
          : identicon,
    );
  }
}
