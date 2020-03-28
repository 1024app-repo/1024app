import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_easyrefresh/easy_refresh.dart';

class RefreshHeader extends Header {
  final Key key;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color color;

  RefreshHeader({
    extent = 60.0,
    triggerDistance = 70.0,
    float = false,
    completeDuration = const Duration(seconds: 1),
    enableInfiniteRefresh = false,
    enableHapticFeedback = true,
    this.key,
    this.bgColor: Colors.transparent,
    this.color: Colors.black,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: float
              ? completeDuration == null
                  ? Duration(
                      milliseconds: 400,
                    )
                  : completeDuration +
                      Duration(
                        milliseconds: 400,
                      )
              : completeDuration,
          enableInfiniteRefresh: enableInfiniteRefresh,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      RefreshMode refreshState,
      double pulledExtent,
      double refreshTriggerPullDistance,
      double refreshIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteRefresh,
      bool success,
      bool noMore) {
    return RefreshHeaderWidget(
      key: key,
      refreshHeader: this,
      refreshState: refreshState,
      pulledExtent: pulledExtent,
      refreshTriggerPullDistance: refreshTriggerPullDistance,
      refreshIndicatorExtent: refreshIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteRefresh: enableInfiniteRefresh,
      success: success,
      noMore: noMore,
    );
  }
}

class RefreshHeaderWidget extends StatefulWidget {
  final RefreshHeader refreshHeader;
  final RefreshMode refreshState;
  final double pulledExtent;
  final double refreshTriggerPullDistance;
  final double refreshIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration completeDuration;
  final bool enableInfiniteRefresh;
  final bool success;
  final bool noMore;

  RefreshHeaderWidget(
      {Key key,
      this.refreshState,
      this.refreshHeader,
      this.pulledExtent,
      this.refreshTriggerPullDistance,
      this.refreshIndicatorExtent,
      this.axisDirection,
      this.float,
      this.completeDuration,
      this.enableInfiniteRefresh,
      this.success,
      this.noMore})
      : super(key: key);

  @override
  RefreshHeaderWidgetState createState() => RefreshHeaderWidgetState();
}

class RefreshHeaderWidgetState extends State<RefreshHeaderWidget>
    with TickerProviderStateMixin<RefreshHeaderWidget> {
  // 是否到达触发刷新距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
      _overTriggerDistance = over;
    }
  }

  // 是否刷新完成
  bool _refreshFinish = false;

  set refreshFinish(bool finish) {
    if (_refreshFinish != finish) {
      if (finish && widget.float) {
        Future.delayed(widget.completeDuration - Duration(milliseconds: 400),
            () {
          if (mounted) {
            _floatBackController.forward();
          }
        });
        Future.delayed(widget.completeDuration, () {
          _floatBackDistance = null;
          _refreshFinish = false;
        });
      }
      _refreshFinish = finish;
    }
  }

  // 动画
  AnimationController _readyController;
  Animation<double> _readyAnimation;
  AnimationController _restoreController;
  Animation<double> _restoreAnimation;
  AnimationController _floatBackController;
  Animation<double> _floatBackAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 浮动时,收起距离
  double _floatBackDistance;

  // 刷新结束图标
  IconData get _finishedIcon {
    if (!widget.success) return Icons.error_outline;
    if (widget.noMore) return Icons.hourglass_empty;
    return Icons.done;
  }

  @override
  void initState() {
    super.initState();
    // 准备动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    // 恢复动画
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
        new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
          ..addListener(() {
            setState(() {
              if (_restoreAnimation.status != AnimationStatus.dismissed) {
                _iconRotationValue = _restoreAnimation.value;
              }
            });
          });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
    // float收起动画
    _floatBackController = new AnimationController(
        duration: const Duration(milliseconds: 300), vsync: this);
    _floatBackAnimation =
        new Tween(begin: widget.refreshIndicatorExtent, end: 0.0)
            .animate(_floatBackController)
              ..addListener(() {
                setState(() {
                  if (_floatBackAnimation.status != AnimationStatus.dismissed) {
                    _floatBackDistance = _floatBackAnimation.value;
                  }
                });
              });
    _floatBackAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _floatBackController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    _floatBackController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    overTriggerDistance = widget.refreshState != RefreshMode.inactive &&
        widget.pulledExtent >= widget.refreshTriggerPullDistance;
    if (widget.refreshState == RefreshMode.refreshed) {
      refreshFinish = true;
    }

    return Stack(
      children: <Widget>[
        Positioned(
          bottom: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            height: _floatBackDistance == null
                ? (widget.refreshIndicatorExtent > widget.pulledExtent
                    ? widget.refreshIndicatorExtent
                    : widget.pulledExtent)
                : widget.refreshIndicatorExtent,
            color: widget.refreshHeader.bgColor,
            child: SizedBox(
              height: widget.refreshIndicatorExtent,
              width: double.infinity,
              child: _buildContent(),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  Widget _buildContent() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        right: 10.0,
      ),
      child: (widget.refreshState == RefreshMode.refresh ||
                  widget.refreshState == RefreshMode.armed) &&
              !widget.noMore
          ? Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(
                  widget.refreshHeader.color,
                ),
              ),
            )
          : widget.refreshState == RefreshMode.refreshed ||
                  widget.refreshState == RefreshMode.done ||
                  (widget.enableInfiniteRefresh &&
                      widget.refreshState != RefreshMode.refreshed) ||
                  widget.noMore
              ? Icon(
                  _finishedIcon,
                  color: widget.refreshHeader.color,
                )
              : Transform.rotate(
                  child: Icon(
                    Icons.arrow_downward,
                    color: widget.refreshHeader.color,
                  ),
                  angle: 2 * pi * _iconRotationValue,
                ),
    );
  }
}

class RefreshFooter extends Footer {
  /// Key
  final Key key;

  /// 背景颜色
  final Color bgColor;

  /// 字体颜色
  final Color color;

  RefreshFooter({
    extent = 60.0,
    triggerDistance = 70.0,
    float = false,
    completeDuration = const Duration(seconds: 1),
    enableInfiniteLoad = true,
    enableHapticFeedback = true,
    this.key,
    this.bgColor: Colors.transparent,
    this.color: Colors.black,
  }) : super(
          extent: extent,
          triggerDistance: triggerDistance,
          float: float,
          completeDuration: completeDuration,
          enableInfiniteLoad: enableInfiniteLoad,
          enableHapticFeedback: enableHapticFeedback,
        );

  @override
  Widget contentBuilder(
      BuildContext context,
      LoadMode loadState,
      double pulledExtent,
      double loadTriggerPullDistance,
      double loadIndicatorExtent,
      AxisDirection axisDirection,
      bool float,
      Duration completeDuration,
      bool enableInfiniteLoad,
      bool success,
      bool noMore) {
    return RefreshFooterWidget(
      key: key,
      refreshFooter: this,
      loadState: loadState,
      pulledExtent: pulledExtent,
      loadTriggerPullDistance: loadTriggerPullDistance,
      loadIndicatorExtent: loadIndicatorExtent,
      axisDirection: axisDirection,
      float: float,
      completeDuration: completeDuration,
      enableInfiniteLoad: enableInfiniteLoad,
      success: success,
      noMore: noMore,
    );
  }
}

class RefreshFooterWidget extends StatefulWidget {
  final RefreshFooter refreshFooter;
  final LoadMode loadState;
  final double pulledExtent;
  final double loadTriggerPullDistance;
  final double loadIndicatorExtent;
  final AxisDirection axisDirection;
  final bool float;
  final Duration completeDuration;
  final bool enableInfiniteLoad;
  final bool success;
  final bool noMore;

  RefreshFooterWidget(
      {Key key,
      this.loadState,
      this.refreshFooter,
      this.pulledExtent,
      this.loadTriggerPullDistance,
      this.loadIndicatorExtent,
      this.axisDirection,
      this.float,
      this.completeDuration,
      this.enableInfiniteLoad,
      this.success,
      this.noMore})
      : super(key: key);

  @override
  RefreshFooterWidgetState createState() => RefreshFooterWidgetState();
}

class RefreshFooterWidgetState extends State<RefreshFooterWidget>
    with TickerProviderStateMixin<RefreshFooterWidget> {
  // 是否到达触发加载距离
  bool _overTriggerDistance = false;

  bool get overTriggerDistance => _overTriggerDistance;

  set overTriggerDistance(bool over) {
    if (_overTriggerDistance != over) {
      _overTriggerDistance
          ? _readyController.forward()
          : _restoreController.forward();
    }
    _overTriggerDistance = over;
  }

  // 动画
  AnimationController _readyController;
  Animation<double> _readyAnimation;
  AnimationController _restoreController;
  Animation<double> _restoreAnimation;

  // Icon旋转度
  double _iconRotationValue = 1.0;

  // 加载结束图标
  IconData get _finishedIcon {
    if (!widget.success) return Icons.error_outline;
    if (widget.noMore) return Icons.hourglass_empty;
    return Icons.done;
  }

  @override
  void initState() {
    super.initState();
    // 初始化动画
    _readyController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _readyAnimation = new Tween(begin: 0.5, end: 1.0).animate(_readyController)
      ..addListener(() {
        setState(() {
          if (_readyAnimation.status != AnimationStatus.dismissed) {
            _iconRotationValue = _readyAnimation.value;
          }
        });
      });
    _readyAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _readyController.reset();
      }
    });
    _restoreController = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    _restoreAnimation =
        new Tween(begin: 1.0, end: 0.5).animate(_restoreController)
          ..addListener(() {
            setState(() {
              if (_restoreAnimation.status != AnimationStatus.dismissed) {
                _iconRotationValue = _restoreAnimation.value;
              }
            });
          });
    _restoreAnimation.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _restoreController.reset();
      }
    });
  }

  @override
  void dispose() {
    _readyController.dispose();
    _restoreController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    overTriggerDistance = widget.loadState != LoadMode.inactive &&
        widget.pulledExtent >= widget.loadTriggerPullDistance;
    return Stack(
      children: <Widget>[
        Positioned(
          top: 0.0,
          left: 0.0,
          right: 0.0,
          child: Container(
            alignment: Alignment.bottomCenter,
            width: double.infinity,
            height: widget.loadIndicatorExtent > widget.pulledExtent
                ? widget.loadIndicatorExtent
                : widget.pulledExtent,
            color: widget.refreshFooter.bgColor,
            child: SizedBox(
              height: widget.loadIndicatorExtent,
              width: double.infinity,
              child: _buildContent(),
            ),
          ),
        ),
      ],
    );
  }

  // 构建显示内容
  Widget _buildContent() {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(
        right: 10.0,
      ),
      child: (widget.loadState == LoadMode.load ||
                  widget.loadState == LoadMode.armed) &&
              !widget.noMore
          ? Container(
              width: 20.0,
              height: 20.0,
              child: CircularProgressIndicator(
                strokeWidth: 2.0,
                valueColor: AlwaysStoppedAnimation(
                  widget.refreshFooter.color,
                ),
              ),
            )
          : widget.loadState == LoadMode.loaded ||
                  widget.loadState == LoadMode.done ||
                  (widget.enableInfiniteLoad &&
                      widget.loadState != LoadMode.loaded) ||
                  widget.noMore
              ? Icon(
                  _finishedIcon,
                  color: widget.refreshFooter.color,
                )
              : Transform.rotate(
                  child: Icon(
                    Icons.arrow_upward,
                    color: widget.refreshFooter.color,
                  ),
                  angle: 2 * pi * _iconRotationValue,
                ),
    );
  }
}
