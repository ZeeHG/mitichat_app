import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class NewMessageIndicator extends StatelessWidget {
  const NewMessageIndicator({
    Key? key,
    this.newMessageCount = 0,
    this.onTap,
  }) : super(key: key);
  final int newMessageCount;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 13.w, vertical: 7.h),
          constraints: BoxConstraints(minHeight: 31.h),
          decoration: BoxDecoration(
            color: StylesLibrary.c_FFFFFF,
            borderRadius: BorderRadius.circular(16.r),
            border: Border.all(color: StylesLibrary.c_E8EAEF, width: 1.h),
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 6.h),
                blurRadius: 16.r,
                spreadRadius: 1.r,
                color: StylesLibrary.c_999999_opacity16,
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageLibrary.scrollDown.toImage
                ..width = 16.w
                ..height = 16.h,
              4.horizontalSpace,
              sprintf(StrLibrary.nMessage, [newMessageCount]).toText
                ..style = StylesLibrary.ts_8443F8_12sp,
            ],
          ),
        ),
      ),
    );
  }
}
