import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class FakeSearchBox extends StatelessWidget {
  FakeSearchBox({
    Key? key,
    this.onTap,
    width,
    height,
  }) : super(key: key);
  final Function()? onTap;
  final double? width = 351.w;
  final double? height = 35.h;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: onTap,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: Styles.c_F7F7F7, borderRadius: BorderRadius.circular(6.r)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageRes.appSearch.toImage
                ..width = 15.w
                ..height = 15.h,
              10.horizontalSpace,
              StrRes.search.toText..style = Styles.ts_999999_16sp
            ],
          )),
    );
  }
}
