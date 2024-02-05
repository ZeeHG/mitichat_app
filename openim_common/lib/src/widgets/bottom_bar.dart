import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class BottomBar extends StatelessWidget {
  const BottomBar({
    Key? key,
    this.index = 0,
    required this.items,
  }) : super(key: key);
  final int index;
  final List<BottomBarItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 56.h,
      decoration: BoxDecoration(
        color: index == 1? Styles.c_F7F7F7 : Styles.c_FFFFFF,
      ),
      child: Row(
        children: List.generate(
            items.length,
            (index) => _buildItemView(
                  i: index,
                  item: items.elementAt(index),
                )).toList(),
      ),
    );
  }

  Widget _buildItemView({required int i, required BottomBarItem item}) =>
      Expanded(
        child: XGestureDetector(
          onDoubleTap: (_) => item.onDoubleClick?.call(i),
          onPointerDown: (_) => item.onClick?.call(i),
          behavior: HitTestBehavior.translucent,
          child: Container(
            // color: Styles.c_000000,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    IntrinsicWidth(
                        child: Container(
                      // 最大图片的高度
                      height: 22.h,
                      alignment: Alignment.bottomCenter,
                      child: ((i == 0 && (index == 0 || index == 1)) || (i == 1 && index == 2) || (i == 3 && index == 3)
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
                        child: UnreadCountView(count: item.count ?? 0),
                      ),
                    ),
                  ],
                ),
                4.verticalSpace,
                item.label.toText
                  ..style = (i == 0 && (index == 0 || index == 1)) ||
                          (i == 1 && index == 2) || 
                          (i == 3 && index == 3)
                      ? (item.selectedStyle ?? Styles.ts_8443F8_11sp)
                      : (item.unselectedStyle ?? Styles.ts_B3B3B3_11sp),
              ],
            ),
          ),
        ),
        /*child: InkWell(
          onTap: () {
            if (item.onClick != null) item.onClick!(i);
          },
          onDoubleTap: () => item.onDoubleClick?.call(i),
          // behavior: HitTestBehavior.translucent,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  (i == index
                      ? item.selectedImgRes.toImage
                      : item.unselectedImgRes.toImage)
                    ..width = item.imgWidth
                    ..height = item.imgHeight,
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Transform.translate(
                      offset: const Offset(2, -2),
                      child: UnreadCountView(count: item.count ?? 0),
                    ),
                  ),
                ],
              ),
              4.verticalSpace,
              item.label.toText
                ..style = i == index
                    ? (item.selectedStyle ?? Styles.ts_8443F8_10sp_semibold)
                    : (item.unselectedStyle ?? Styles.ts_999999_10sp_semibold),
            ],
          ),
        ),*/
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

  BottomBarItem(
      {required this.selectedImgRes,
      required this.unselectedImgRes,
      required this.label,
      this.selectedStyle,
      this.unselectedStyle,
      required this.imgWidth,
      required this.imgHeight,
      this.onClick,
      this.onDoubleClick,
      this.steam,
      this.count});
}
