import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ImageView extends StatelessWidget {
  final ImageProvider imageProvider;
  final String heroTag;

  const ImageView({
    this.imageProvider,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.black,
        constraints: BoxConstraints.expand(
          height: MediaQuery.of(context).size.height,
        ),
        child: GestureDetector(
          onTapDown: (_) {
            Navigator.pop(context);
          },
          child: PhotoView(
            imageProvider: imageProvider,
            loadingBuilder: (context, progress) => Center(
              child: CircularProgressIndicator(
                value: progress == null
                    ? null
                    : progress.cumulativeBytesLoaded /
                        progress.expectedTotalBytes,
                valueColor: AlwaysStoppedAnimation(Colors.white),
                strokeWidth: 2,
              ),
            ),
            heroAttributes: PhotoViewHeroAttributes(tag: heroTag),
            enableRotation: false,
          ),
        ),
      ),
    );
  }
}

class FadeRoute extends PageRouteBuilder {
  final Widget page;
  FadeRoute({this.page})
      : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              page,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) =>
              FadeTransition(
            opacity: animation,
            child: child,
          ),
        );
}
