import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class FakeSearchBox extends StatelessWidget {
  FakeSearchBox(
      {Key? key,
      this.onTap,
      double? width,
      double? height,
      Color? color,
      double? borderRadius})
      : width = width ?? 350.w,
        height = height ?? 35.h,
        color = color ?? Styles.c_F7F7F7,
        borderRadius = borderRadius ?? 6.r,
        super(key: key);

  Function()? onTap;
  double? width;
  double? height;
  Color? color;
  double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color, borderRadius: BorderRadius.circular(borderRadius)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageRes.appSearch.toImage
                ..width = 15.w
                ..height = 15.h,
              10.horizontalSpace,
              StrLibrary.search.toText..style = Styles.ts_999999_16sp
            ],
          )),
    );
  }
}
