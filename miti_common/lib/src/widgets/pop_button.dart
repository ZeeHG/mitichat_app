import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

// typedef PopupMenuItemBuilder = Widget Function(PopMenuInfo info);

class PopMenuInfo {
  final String? icon;
  final String text;
  final Function()? onTap;

  PopMenuInfo({
    this.icon,
    required this.text,
    this.onTap,
  });
}

class CusPopMenuInfo {
  final Function()? onTap;
  final Widget child;

  CusPopMenuInfo({this.onTap, required this.child});
}

class PopButton extends StatelessWidget {
  final List<PopMenuInfo> menus;
  final Widget child;
  final CustomPopupMenuController? popCtrl;
  final PressType pressType;
  final bool showArrow;
  final Color arrowColor;
  final Color barrierColor;
  final double horizontalMargin;
  final double verticalMargin;
  final double arrowSize;
  final Color? bgColor;
  final double? bgRadius;
  final Color? bgShadowColor;
  final Offset? bgShadowOffset;
  final double? bgShadowBlurRadius;
  final double? bgShadowSpreadRadius;
  final double? menuItemHeight;
  final double? menuItemWidth;
  final EdgeInsetsGeometry? menuItemPadding;
  final TextStyle? menuItemTextStyle;
  final double? menuItemIconWidth;
  final double? menuItemIconHeight;
  final Color? lineColor;
  final double? lineWidth;
  final List<CusPopMenuInfo>? cusMenus;

  PopButton({
    super.key,
    menus,
    required this.child,
    this.cusMenus,
    this.popCtrl,
    this.arrowColor = const Color(0xFFFFFFFF),
    this.showArrow = false,
    this.barrierColor = Colors.transparent,
    this.arrowSize = 10.0,
    this.horizontalMargin = 10.0,
    this.verticalMargin = 10.0,
    this.pressType = PressType.singleClick,
    this.bgColor,
    this.bgRadius,
    this.bgShadowColor,
    this.bgShadowOffset,
    this.bgShadowBlurRadius,
    this.bgShadowSpreadRadius,
    this.menuItemHeight,
    this.menuItemWidth,
    this.menuItemTextStyle,
    this.menuItemIconWidth,
    this.menuItemIconHeight,
    this.menuItemPadding,
    this.lineColor,
    this.lineWidth = 1.0,
  })  : menus = menus ?? [];

  @override
  Widget build(BuildContext context) {
    return CopyCustomPopupMenu(
      controller: popCtrl,
      arrowColor: arrowColor,
      showArrow: showArrow,
      barrierColor: barrierColor,
      arrowSize: arrowSize,
      verticalMargin: verticalMargin,
      horizontalMargin: horizontalMargin,
      pressType: pressType,
      child: child,
      menuBuilder: () => _buildPopBgView(
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: 0.5.sh),
          child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: null == cusMenus
                ? menus
                    .map((e) =>
                        _buildPopItemView(e, showLine: menus.lastOrNull != e))
                    .toList()
                : cusMenus!.map((e) => _buildCusPopItemView(e)).toList(),
          ),
        ),
          )),
    );
  }

  _clickArea(double dy) {
    for (var i = 0; i < menus.length; i++) {
      if (dy > i * menuItemHeight! && dy <= (i + 1) * menuItemHeight!) {
        menus.elementAt(i).onTap?.call();
        popCtrl?.hideMenu();
      }
    }
  }

  Widget _buildPopBgView({Widget? child}) => Container(
        decoration: BoxDecoration(
          color: bgColor ?? StylesLibrary.c_FFFFFF,
          borderRadius: BorderRadius.circular(bgRadius ?? 8.r),
          boxShadow: [
            BoxShadow(
              color: bgShadowColor ?? StylesLibrary.c_999999_opacity16,
              offset: bgShadowOffset ?? Offset(0, 6.h),
              blurRadius: bgShadowBlurRadius ?? 16.r,
              spreadRadius: bgShadowSpreadRadius ?? 1.r,
            )
          ],
        ),
        child: child,
      );

  Widget _buildPopItemView(PopMenuInfo info, {bool showLine = true}) =>
      GestureDetector(
        onTap: () {
          popCtrl?.hideMenu();
          info.onTap?.call();
        },
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: menuItemHeight ?? 45.h,
          width: menuItemWidth,
          padding: menuItemPadding,
          constraints: BoxConstraints(minWidth: 117.w),
          margin: EdgeInsets.symmetric(horizontal: 14.w),
          decoration: showLine
              ? BoxDecoration(
                  border: BorderDirectional(
                    bottom: BorderSide(
                      color: lineColor ?? StylesLibrary.c_F5F0F0,
                      width: lineWidth ?? 1,
                    ),
                  ),
                )
              : null,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (null != info.icon)
                Padding(
                  padding: EdgeInsets.only(right: 12.w),
                  child: info.icon!.toImage
                    ..width = (menuItemIconWidth ?? 20.w)
                    ..height = (menuItemIconHeight ?? 20.h),
                ),
              info.text.toText
                ..style = (menuItemTextStyle ?? StylesLibrary.ts_333333_16sp),
            ],
          ),
        ),
      );

  Widget _buildCusPopItemView(CusPopMenuInfo info) => GestureDetector(
        onTap: () {
          popCtrl?.hideMenu();
          info.onTap?.call();
        },
        behavior: HitTestBehavior.translucent,
        child: info.child,
      );
}
