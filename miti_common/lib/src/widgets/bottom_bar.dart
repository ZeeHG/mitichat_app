import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    super.key,
    this.activeIndex = 0,
    required this.items,
  });
  final int activeIndex;
  final List<BottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color:
            activeIndex == 1 ? StylesLibrary.c_F7F7F7 : StylesLibrary.c_FFFFFF,
      ),
      child: Row(
        children: List.generate(
            items.length,
            (index) => _buildItemView(
                  // i: index,
                  item: items[index],
                )),
      ),
    );
  }

  Widget _buildItemView({required BottomBarItem item}) => Expanded(
        child: XGestureDetector(
          onDoubleTap: (_) => item.onDoubleClick?.call(item.itemIndex),
          onPointerDown: (_) => item.onClick?.call(item.itemIndex),
          behavior: HitTestBehavior.translucent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  IntrinsicWidth(
                      child: Container(
                    // 最大图片的高度
                    height: 24.h,
                    alignment: Alignment.bottomCenter,
                    child: (item.itemIndex == activeIndex
                        ? item.selectedImgRes.toImage
                        : item.unselectedImgRes.toImage)
                      ..width = item.imgWidth
                      ..height = item.imgHeight,
                  )),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: const Offset(2, -2),
                      child: UnreadCountView(
                        count: item.count ?? 0,
                        showCount: item.showCount,
                      ),
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              item.label.toText
                ..style = item.itemIndex == activeIndex
                    ? (item.selectedStyle ?? StylesLibrary.ts_8443F8_11sp)
                    : (item.unselectedStyle ?? StylesLibrary.ts_B3B3B3_11sp),
            ],
          ),
        ),
      );
}

class BottomBarItem {
  final String selectedImgRes;
  final String unselectedImgRes;
  final String label;
  final TextStyle? selectedStyle;
  final TextStyle? unselectedStyle;
  final double imgWidth;
  final double imgHeight;
  final Function(int index)? onClick;
  final Function(int index)? onDoubleClick;
  final Stream<int>? steam;
  final int? count;
  final int itemIndex;
  final bool showCount;

  BottomBarItem({
    required this.selectedImgRes,
    required this.unselectedImgRes,
    required this.label,
    required this.itemIndex,
    this.selectedStyle,
    this.unselectedStyle,
    required this.imgWidth,
    required this.imgHeight,
    this.onClick,
    this.onDoubleClick,
    this.steam,
    this.count,
    this.showCount = true,
  });
}
