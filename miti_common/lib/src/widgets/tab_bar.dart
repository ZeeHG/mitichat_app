import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {super.key,
      required this.index,
      required this.labels,
      this.selectedStyle,
      this.unselectedStyle,
      this.indicatorColor,
      this.indicatorHeight,
      this.indicatorWidth,
      this.onTabChanged,
      this.height,
      this.width,
      this.showUnderline = false,
      this.activeTextStyle,
      this.inactiveTextStyle,
      this.counts,
      this.bgColor});
  final int index;
  final List<String> labels;
  final List<RxInt>? counts;
  final TextStyle? selectedStyle;
  final TextStyle? unselectedStyle;
  final double? height;
  final double? width;
  final Color? indicatorColor;
  final double? indicatorHeight;
  final double? indicatorWidth;
  final Color? bgColor;
  final TextStyle? activeTextStyle;
  final TextStyle? inactiveTextStyle;
  final Function(int index)? onTabChanged;
  final bool showUnderline;

  @override
  Widget build(BuildContext context) {
    return IntrinsicWidth(
      child: Container(
        // width: width,
        constraints: BoxConstraints(minWidth: width ?? 110.w),
        decoration: BoxDecoration(
          color: this.bgColor ?? StylesLibrary.c_FFFFFF,
          border: showUnderline
              ? BorderDirectional(
                  bottom: BorderSide(color: StylesLibrary.c_E8EAEF, width: 1.h))
              : null,
        ),
        child: Row(
          children: List.generate(labels.length, (i) => _buildItemView(i)),
        ),
      ),
    );
  }

  Widget _buildItemView(int i) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (null != onTabChanged) onTabChanged!(i);
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: height ?? 40.h,
            margin: EdgeInsets.only(left: i != 0 ? 5.w : 0),
            child: Stack(
              children: [
                if (null != counts?.elementAt(i)?.value)
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: const Offset(2, 2),
                      child: Obx(() => UnreadCountView(
                          count: counts?.elementAt(i)?.value ?? 0)),
                    ),
                  ),
                Align(
                  alignment: Alignment.center,
                  child: labels.elementAt(i).toText
                    ..style = i == index
                        ? activeTextStyle ?? StylesLibrary.ts_333333_16sp
                        : inactiveTextStyle ?? StylesLibrary.ts_333333_16sp,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible: i == index,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        // color: StylesLibrary.c_8443F8,
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            StylesLibrary.c_8443F8,
                            StylesLibrary.c_BA78FC
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1.r),
                      ),
                      height: indicatorHeight ?? 2.h,
                      width: indicatorWidth ?? 32.w,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class TabInfo {
  String label;
  TextStyle styleSel;
  TextStyle styleUnsel;
  double iconHeight;
  double iconWidth;
  String iconSel;
  String iconUnsel;

  TabInfo({
    required this.label,
    required this.styleSel,
    required this.styleUnsel,
    required this.iconSel,
    required this.iconUnsel,
    required this.iconHeight,
    required this.iconWidth,
  });
}
