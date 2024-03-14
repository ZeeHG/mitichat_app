import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class MetasImageView extends StatelessWidget {
  const MetasImageView(
      {Key? key, required this.urls, this.width, this.height, this.radius})
      : super(key: key);
  final List<String> urls;
  final double? width;
  final double? height;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(radius ?? 0)),
      ),
      width: width ?? 77.w,
      height: height ?? 77.h,
      child: _buildItemView(),
    );
  }

  Widget _buildItemView() {
    if (urls.length == 1) {
      return ImageUtil.networkImage(
        url: urls[0],
        width: width ?? 77.w,
        height: height ?? 77.h,
        fit: BoxFit.cover,
      );
    } else if (urls.length == 2) {
      return Row(
        children: [
          Expanded(
            child: ImageUtil.networkImage(
              url: urls[0],
              width: null != width ? (width! - 2.w) / 2 : 38.w,
              height: height ?? 77.h,
              fit: BoxFit.cover,
            ),
          ),
          1.horizontalSpace,
          Expanded(
            child: ImageUtil.networkImage(
              url: urls[1],
              width: null != width ? (width! - 2.w) / 2 : 38.w,
              height: height ?? 77.h,
              fit: BoxFit.cover,
            ),
          ),
        ],
      );
    } else if (urls.length == 3) {
      return Row(
        children: [
          Expanded(
            child: ImageUtil.networkImage(
              url: urls[0],
              width: null != width ? (width! - 2.w) / 2 : 38.w,
              height: height ?? 77.h,
              fit: BoxFit.cover,
            ),
          ),
          1.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                ImageUtil.networkImage(
                  url: urls[1],
                  width: null != width ? (width! - 2.w) / 2 : 38.w,
                  height: null != height ? (height! - 2.h) / 2 : 38.h,
                  fit: BoxFit.cover,
                ),
                1.verticalSpace,
                ImageUtil.networkImage(
                  url: urls[2],
                  width: null != width ? (width! - 2.w) / 2 : 38.w,
                  height: null != height ? (height! - 2.h) / 2 : 38.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      );
    } else {
      return Row(
        children: [
          Expanded(
            child: Column(
              children: [
                ImageUtil.networkImage(
                  url: urls[0],
                  width: null != width ? (width! - 2.w) / 2 : 38.w,
                  height: null != height ? (height! - 2.h) / 2 : 38.h,
                  fit: BoxFit.cover,
                ),
                1.verticalSpace,
                ImageUtil.networkImage(
                  url: urls[1],
                  width: null != width ? (width! - 2.w) / 2 : 38.w,
                  height: null != height ? (height! - 2.h) / 2 : 38.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          1.horizontalSpace,
          Expanded(
            child: Column(
              children: [
                ImageUtil.networkImage(
                  url: urls[2],
                  width: null != width ? (width! - 2.w) / 2 : 38.w,
                  height: null != height ? (height! - 2.h) / 2 : 38.h,
                  fit: BoxFit.cover,
                ),
                1.verticalSpace,
                ImageUtil.networkImage(
                  url: urls[3],
                  width: null != width ? (width! - 2.w) / 2 : 38.w,
                  height: null != height ? (height! - 2.h) / 2 : 38.h,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
        ],
      );
    }
  }
}
