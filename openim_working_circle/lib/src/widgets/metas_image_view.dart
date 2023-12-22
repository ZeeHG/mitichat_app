import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class MetasImageView extends StatelessWidget {
  const MetasImageView({
    Key? key,
    required this.urls,
    this.width,
    this.height,
  }) : super(key: key);
  final List<String> urls;
  final double? width;
  final double? height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
              width: width ?? 38.w,
              height: height ?? 77.h,
              fit: BoxFit.cover,
            ),
          ),
          1.horizontalSpace,
          Expanded(
            child: ImageUtil.networkImage(
              url: urls[1],
              width: width ?? 38.w,
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
              width: width ?? 38.w,
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
                  width: width ?? 38.w,
                  height: height ?? 38.h,
                  fit: BoxFit.cover,
                ),
                1.verticalSpace,
                ImageUtil.networkImage(
                  url: urls[2],
                  width: width ?? 38.w,
                  height: height ?? 38.h,
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
                  width: width ?? 38.w,
                  height: height ?? 38.h,
                  fit: BoxFit.cover,
                ),
                1.verticalSpace,
                ImageUtil.networkImage(
                  url: urls[1],
                  width: width ?? 38.w,
                  height: height ?? 38.h,
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
                  width: width ?? 38.w,
                  height: height ?? 38.h,
                  fit: BoxFit.cover,
                ),
                1.verticalSpace,
                ImageUtil.networkImage(
                  url: urls[3],
                  width: width ?? 38.w,
                  height: height ?? 38.h,
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
