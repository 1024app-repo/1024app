import 'dart:ui';

import 'package:flutter/material.dart';

class SliverPageDelegate extends SliverPersistentHeaderDelegate {
  SliverPageDelegate({
    @required this.minHeight,
    @required this.maxHeight,
    @required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return SizedBox.expand(
      child: Container(
        color: Colors.transparent,
        child: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 15.0, sigmaY: 15.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200.withOpacity(0.5),
                border: Border.all(color: Colors.grey, width: 0.2),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }

  @override
  double get maxExtent => maxHeight;

  @override
  double get minExtent => minHeight;

  @override
  bool shouldRebuild(SliverPageDelegate oldDelegate) {
    return maxHeight != oldDelegate.maxHeight ||
        minHeight != oldDelegate.minHeight ||
        child != oldDelegate.child;
  }
}
