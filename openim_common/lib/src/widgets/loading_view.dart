import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:async/async.dart';

class LoadingView extends NavigatorObserver {
  static final LoadingView singleton = LoadingView._();

  factory LoadingView() => singleton;

  LoadingView._();

  OverlayState? _overlayState;
  OverlayEntry? _overlayEntry;
  bool _isVisible = false;
  CancelToken? _cancelToken;
  CancelableOperation? _cancelableOperation;

  @override
  void didPop(Route route, Route? previousRoute) {
    dismiss();
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    dismiss();
    super.didPush(route, previousRoute);
  }

  Future<T> wrap<T>(
      {required Future<T> Function() asyncFunction,
      bool showing = true,
      double? navBarHeight,
      CancelToken? cancelToken}) async {
    navBarHeight = navBarHeight ?? 44.h;
    _cancelToken = cancelToken;
    await Future.delayed(1.milliseconds);
    if (showing) show(navBarHeight: navBarHeight);
    T data;
    try {
      _cancelableOperation = CancelableOperation.fromFuture(asyncFunction());
      data = await _cancelableOperation?.value;
      // await Future.delayed(3000.milliseconds);
    } catch (_) {
      rethrow;
    } finally {
      dismiss();
    }
    return data;
  }

  void show({double? navBarHeight}) async {
    navBarHeight = navBarHeight ?? 44.h;
    if (_isVisible) return;
    _overlayState = Overlay.of(Get.overlayContext!);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).padding.top + navBarHeight!,
        left: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - navBarHeight,
          color: Colors.transparent,
          child: Center(
            child: SpinKitCircle(color: Styles.c_8443F8),
          ),
        ),
      ),
    );
    _isVisible = true;
    _overlayState?.insert(_overlayEntry!);
  }

  dismiss() async {
    if (!_isVisible) return;
    _overlayEntry?.remove();
    _isVisible = false;
    _cancelToken?.cancel({"cancelReason": "loadingViewSwitchPage"});
    _cancelableOperation?.cancel();
    _cancelToken = null;
    _cancelableOperation = null;
  }
}
