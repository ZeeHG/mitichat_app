import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class ChatTimelineView extends StatelessWidget {
  const ChatTimelineView({
    Key? key,
    required this.timeStr,
    this.margin,
  }) : super(key: key);
  final String timeStr;
  final EdgeInsetsGeometry? margin;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      padding: EdgeInsets.symmetric(vertical: 2.h, horizontal: 6.w),
      decoration: BoxDecoration(
        color: StylesLibrary.c_EBEBEB,
        borderRadius: BorderRadius.circular(2.r),
      ),
      child: timeStr.toText..style = StylesLibrary.ts_333333_12sp,
    );
  }
}
