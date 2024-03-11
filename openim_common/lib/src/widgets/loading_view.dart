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
      String? loadingTips,
      EdgeInsetsGeometry? padding,
      CancelToken? cancelToken}) async {
    navBarHeight = navBarHeight ?? 44.h;
    _cancelToken = cancelToken;
    await Future.delayed(1.milliseconds);
    if (showing)
      show(
          navBarHeight: navBarHeight,
          loadingTips: loadingTips,
          padding: padding);
    T data;
    try {
      _cancelableOperation?.cancel();
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

  void show(
      {double? navBarHeight,
      String? loadingTips,
      EdgeInsetsGeometry? padding}) async {
    loadingTips = loadingTips ?? "";
    navBarHeight = navBarHeight ?? 44.h;
    padding = padding ?? EdgeInsets.only(bottom: 94.h);
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
          child: Container(
            padding: padding,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // SpinKitCircle(color: Styles.c_8443F8),
                  // if (loadingTips!.isNotEmpty) ...[
                  //   5.verticalSpace,
                  //   Text(loadingTips, style: Styles.ts_8443F8_14sp)
                  // ]
                  Container(
                    width: 80.w,
                    height: 80.h,
                    decoration: BoxDecoration(
                      color: Styles.c_FFFFFF,
                      boxShadow: [
                        BoxShadow(
                          color: Color.fromRGBO(0, 0, 0, 0.11),
                          offset: Offset(0, 1),
                          blurRadius: 10.r,
                        ),
                      ],
                      borderRadius:
                          BorderRadius.all(Radius.circular(12.r)), // 边框圆角
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
