import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
  CancelToken? cancelToken;
  CancelableOperation? _cancelableOperation;

  @override
  void didPop(Route route, Route? previousRoute) {
    close(true);
    super.didPop(route, previousRoute);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    close(true);
    super.didPush(route, previousRoute);
  }

  Future<T> start<T>(
      {required Future<T> Function() fn,
      bool fullScreenAnimation = true,
      double? topBarHeight,
      String? loadingTips,
      EdgeInsetsGeometry? padding,
      CancelToken? cancelToken}) async {
    cancelToken = cancelToken;
    await Future.delayed(2.milliseconds);
    if (fullScreenAnimation) {
      showAnimation(
          topBarHeight: topBarHeight,
          loadingTips: loadingTips,
          padding: padding);
    }
    T data;
    try {
      _cancelableOperation?.cancel();
      _cancelableOperation = CancelableOperation.fromFuture(fn());
      data = await _cancelableOperation?.value;
    } catch (e) {
      rethrow;
    } finally {
      close();
    }
    return data;
  }

  void showAnimation(
      {double? topBarHeight,
      String? loadingTips,
      EdgeInsetsGeometry? padding}) async {
    loadingTips = loadingTips ?? "";
    topBarHeight = topBarHeight ?? 44.h;
    padding = padding ?? EdgeInsets.only(bottom: 94.h);
    if (_isVisible) return;
    _overlayState = Overlay.of(Get.overlayContext!);
    _overlayEntry = OverlayEntry(
      builder: (BuildContext context) => Positioned(
        top: MediaQuery.of(context).padding.top + topBarHeight!,
        left: 0,
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height - topBarHeight,
          color: Colors.transparent,
          child: Container(
            padding: padding,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Styles.c_FFFFFF,
                      boxShadow: [
                        BoxShadow(
                          color: const Color.fromRGBO(0, 0, 0, 0.11),
                          offset: const Offset(0, 1),
                          blurRadius: 10.r,
                        ),
                      ],
                      borderRadius:
                          BorderRadius.all(Radius.circular(12.r)),
                    ),
                    child: Center(
                      child: ImageRes.loading.toImage
                        ..width = 53.w
                        ..height = 53.h,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
    _isVisible = true;
    _overlayState?.insert(_overlayEntry!);
  }

  close([bool isNav = false]) async {
    if (!_isVisible) return;
    _isVisible = false;
    _overlayEntry?.remove();

    cancelToken?.cancel({"reason": isNav ? "导航触发取消" : "正常取消"});
    cancelToken = null;

    _cancelableOperation?.cancel();
    _cancelableOperation = null;
  }
}
