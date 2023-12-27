import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class CustomTabBar extends StatelessWidget {
  const CustomTabBar(
      {Key? key,
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
      this.bgColor})
      : super(key: key);
  final int index;
  final List<String> labels;
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
        color: this.bgColor ?? Styles.c_FFFFFF,
        border: showUnderline
            ? BorderDirectional(
                bottom: BorderSide(color: Styles.c_E8EAEF, width: 1.h))
            : null,
      ),
      child: Row(
        children: List.generate(labels.length, (i) => _buildItemView(i)),
      ),
    ),
    ) ;
  }

  Widget _buildItemView(int i) => Expanded(
        child: GestureDetector(
          onTap: () {
            if (null != onTabChanged) onTabChanged!(i);
          },
          behavior: HitTestBehavior.translucent,
          child: Container(
            height: height ?? 40.h,
            margin: EdgeInsets.only(left: i !=0? 5.w : 0),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.center,
                  child: labels.elementAt(i).toText
                    ..style = i == index? activeTextStyle ?? Styles.ts_333333_16sp : inactiveTextStyle ?? Styles.ts_333333_16sp,
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Visibility(
                    visible: i == index,
                    child: Container(
                      margin: EdgeInsets.only(bottom: 2.h),
                      decoration: BoxDecoration(
                        color: Styles.c_8443F8,
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
