/*
 * Author: Jpeng
 * Email: peng8350@gmail.com
 * Time: 2019/5/19 下午9:23
 */

import 'dart:math';

import 'package:flutter/material.dart'
    hide RefreshIndicator, RefreshIndicatorState;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

// How much the scroll's drag gesture can overshoot the RefreshIndicator's
// displacement; max displacement = _kDragSizeFactorLimit * displacement.
const double _kDragSizeFactorLimit = 1.5;

/// mostly use flutter inner's RefreshIndicator
class MomentsIndicator extends RefreshIndicator {
  /// see flutter RefreshIndicator documents,the meaning same with that
  final String? semanticsLabel;

  /// see flutter RefreshIndicator documents,the meaning same with that
  final String? semanticsValue;

  /// see flutter RefreshIndicator documents,the meaning same with that
  final Color? color;

  /// Distance from the top when refreshing
  final double distance;

  /// see flutter RefreshIndicator documents,the meaning same with that
  final Color? backgroundColor;

  const MomentsIndicator({
    Key? key,
    double height = 200.0,
    this.semanticsLabel,
    this.semanticsValue,
    this.color,
    double offset = 0,
    this.distance = 200.0,
    this.backgroundColor,
  }) : super(
          key: key,
          refreshStyle: RefreshStyle.Front,
          offset: offset,
          height: height,
        );

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState

    return _MaterialClassicHeaderState();
  }
}

class _MaterialClassicHeaderState
    extends RefreshIndicatorState<MomentsIndicator>
    with TickerProviderStateMixin {
  ScrollPosition? _position;
  Animation<Offset>? _positionFactor;
  Animation<Color?>? _valueColor;
  late AnimationController _scaleFactor;
  late AnimationController _positionController;
  late AnimationController _valueAni;

  late AnimationController _rotationCtrl;
  bool _isRefreshing = false;

  @override
  void initState() {
    // TODO: implement initState
    _valueAni = AnimationController(
        vsync: this,
        value: 0.0,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 500));
    _valueAni.addListener(() {
      // frequently setState will decline the performance
      if (mounted && _position!.pixels <= 0) setState(() {});
    });
    _positionController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _scaleFactor = AnimationController(
        vsync: this,
        value: 1.0,
        lowerBound: 0.0,
        upperBound: 1.0,
        duration: const Duration(milliseconds: 300));
    _positionFactor = _positionController.drive(Tween<Offset>(
        begin: const Offset(0.0, -1.0),
        end: Offset(0.0, widget.height / 44.0)));

    _rotationCtrl = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    )..repeat(); // 通过 repeat() 方法来让动画无限循环
    super.initState();
  }

  @override
  void didUpdateWidget(covariant MomentsIndicator oldWidget) {
    // TODO: implement didUpdateWidget
    _position = Scrollable.of(context).position;
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget buildContent(BuildContext context, RefreshStatus? mode) {
    // TODO: implement buildContent
    return Container(
      margin: EdgeInsets.only(left: 10.w),
      child: _buildIndicator(widget.backgroundColor ?? Colors.white),
    );
  }

  Widget _buildIndicator(Color outerColor) {
    double? value = floating ? null : _valueAni.value;
    if (value != null) {
      _lastValue = value;
    }
    final double rotation;
    if (value == null && _lastValue == null) {
      rotation = 0.0;
    } else {
      rotation = pi * _additionalRotationTween.transform(value ?? _lastValue!);
    }
    return SlideTransition(
      position: _positionFactor!,
      child: Align(
        alignment: Alignment.topLeft,
        child: ScaleTransition(
          scale: _scaleFactor,
          child: _isRefreshing
              ? RotationTransition(
                  turns: _rotationCtrl,
                  child: ImageLibrary.circle.toImage
                    ..width = 24.w
                    ..height = 24.h,
                )
              : Transform.rotate(
                  angle: rotation,
                  child: ImageLibrary.circle.toImage
                    ..width = 24.w
                    ..height = 24.h,
                ),
        ),
      ),
      // child: ScaleTransition(
      //   scale: _scaleFactor,
      //   child: Align(
      //     alignment: Alignment.topCenter,
      //     // child: RefreshProgressIndicator(
      //     //   semanticsLabel: widget.semanticsLabel ??
      //     //       MaterialLocalizations.of(context).refreshIndicatorSemanticLabel,
      //     //   semanticsValue: widget.semanticsValue,
      //     //   value: floating ? null : _valueAni.value,
      //     //   valueColor: _valueColor,
      //     //   backgroundColor: outerColor,
      //     // ),
      //   ),
      // ),
    );
  }

  @override
  void onOffsetChange(double offset) {
    // TODO: implement onOffsetChange
    if (!floating) {
      _valueAni.value = offset / configuration!.headerTriggerDistance;
      _positionController.value = offset / configuration!.headerTriggerDistance;
    }
  }

  @override
  void onModeChange(RefreshStatus? mode) {
    // TODO: implement onModeChange
    _isRefreshing = mode == RefreshStatus.refreshing;
    if (mode == RefreshStatus.refreshing) {
      _positionController.value = widget.distance / widget.height;
      _scaleFactor.value = 1;
    }
    super.onModeChange(mode);
  }

  @override
  void resetValue() {
    // TODO: implement resetValue
    _scaleFactor.value = 1.0;
    _positionController.value = 0.0;
    _valueAni.value = 0.0;
    super.resetValue();
  }

  @override
  void didChangeDependencies() {
    final ThemeData theme = Theme.of(context);
    _position = Scrollable.of(context).position;
    _valueColor = _positionController.drive(
      ColorTween(
        begin: (widget.color ?? theme.primaryColor).withOpacity(0.0),
        end: (widget.color ?? theme.primaryColor).withOpacity(1.0),
      ).chain(
          CurveTween(curve: const Interval(0.0, 1.0 / _kDragSizeFactorLimit))),
    );
    super.didChangeDependencies();
  }

  @override
  Future<void> readyToRefresh() {
    // TODO: implement readyToRefresh
    return _positionController.animateTo(widget.distance / widget.height);
  }

  @override
  Future<void> endRefresh() {
    // TODO: implement endRefresh
    return _scaleFactor.animateTo(0.0);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _valueAni.dispose();
    _scaleFactor.dispose();
    _positionController.dispose();
    _rotationCtrl.dispose();
    super.dispose();
  }

  static const double _strokeHeadInterval = 0.33;

  // Last value received from the widget before null.
  double? _lastValue;

  late final Animatable<double> _additionalRotationTween =
      TweenSequence<double>(
    <TweenSequenceItem<double>>[
      // Makes arrow to expand a little bit earlier, to match the Android look.
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -0.1, end: -0.2),
        weight: _strokeHeadInterval,
      ),
      // Additional rotation after the arrow expanded
      TweenSequenceItem<double>(
        tween: Tween<double>(begin: -0.2, end: 1.35),
        weight: 1 - _strokeHeadInterval,
      ),
    ],
  );
}
