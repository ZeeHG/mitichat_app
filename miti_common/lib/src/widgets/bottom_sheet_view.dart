import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class BottomSheetView extends StatelessWidget {
  const BottomSheetView({
    Key? key,
    required this.items,
    this.itemHeight,
    this.textStyle,
    this.mainAxisAlignment,
    this.isOverlaySheet = false,
    this.onCancel,
  }) : super(key: key);
  final List<SheetItem> items;
  final double? itemHeight;
  final TextStyle? textStyle;
  final MainAxisAlignment? mainAxisAlignment;
  final bool isOverlaySheet;
  final Function()? onCancel;

  @override
  Widget build(BuildContext context) {
    return Container(
      // padding: EdgeInsets.symmetric(horizontal: 10.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            clipBehavior: Clip.antiAlias,
            decoration: BoxDecoration(
              color: StylesLibrary.c_FFFFFF,
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.r),
                  topRight: Radius.circular(20.r)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: items.map(_parseItem).toList(),
            ),
          ),
          // 10.verticalSpace,
          Container(
            color: StylesLibrary.c_F7F8FA,
            height: 6.h,
          ),
          _itemBgView(
            label: StrLibrary.cancel,
            onTap: isOverlaySheet ? onCancel : () => Get.back(),
            // borderRadius: BorderRadius.circular(6.r),
            alignment: MainAxisAlignment.center,
          ),
          if (Platform.isIOS)
            Container(
              color: StylesLibrary.c_F7F8FA,
              height: MediaQuery.of(context).padding.bottom,
            )
          // 10.verticalSpace,
        ],
      ),
    );
  }

  Widget _parseItem(SheetItem item) {
    BorderRadius? borderRadius;
    int length = items.length;
    bool isLast = items.indexOf(item) == items.length - 1;
    bool isFirst = items.indexOf(item) == 0;
    if (length == 1) {
      borderRadius = item.borderRadius ?? BorderRadius.circular(6.r);
    } else {
      // borderRadius = item.borderRadius ??
      //     BorderRadius.only(
      //       topLeft: isFirst ? Radius.circular(6.r) : Radius.zero,
      //       topRight: isFirst ? Radius.circular(6.r) : Radius.zero,
      //       bottomLeft: isLast ? Radius.circular(6.r) : Radius.zero,
      //       bottomRight: isLast ? Radius.circular(6.r) : Radius.zero,
      //     );
      borderRadius = item.borderRadius;
    }
    return _itemBgView(
        label: item.label,
        textStyle: item.textStyle,
        icon: item.icon,
        alignment: item.alignment,
        line: !isLast,
        borderRadius: borderRadius,
        onTap: () {
          if (!isOverlaySheet) Get.back(result: item.result);
          item.onTap?.call();
        });
  }

  Widget _itemBgView({
    required String label,
    Widget? icon,
    Function()? onTap,
    BorderRadius? borderRadius,
    TextStyle? textStyle,
    MainAxisAlignment? alignment,
    bool line = false,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: StylesLibrary.c_FFFFFF,
            borderRadius: borderRadius,
          ),
          child: Container(
            decoration: line
                ? BoxDecoration(
                    border: BorderDirectional(
                      bottom:
                          BorderSide(color: StylesLibrary.c_EDEDED, width: 1.h),
                    ),
                  )
                : null,
            height: itemHeight ?? 63.h,
            child: Row(
              mainAxisAlignment:
                  alignment ?? mainAxisAlignment ?? MainAxisAlignment.center,
              children: [
                if (null != icon) 10.horizontalSpace,
                if (null != icon) _image(icon),
                if (null != icon) 12.horizontalSpace,
                _text(label, textStyle),
                if (null != icon) 10.horizontalSpace,
              ],
            ),
          ),
        ),
      );

  _text(String label, TextStyle? style) => label.toText
    ..style = (style ?? textStyle ?? StylesLibrary.ts_333333_16sp);

  _image(Widget icon) => Container(
        width: 24.w,
        height: 24.h,
        child: Center(
          child: icon,
        ),
      );
}

class SheetItem {
  final String label;
  final TextStyle? textStyle;
  final Widget? icon;
  final Function()? onTap;
  final BorderRadius? borderRadius;
  final MainAxisAlignment? alignment;
  final dynamic result;

  SheetItem({
    required this.label,
    this.textStyle,
    this.icon,
    this.onTap,
    this.borderRadius,
    this.alignment,
    this.result,
  });
}
