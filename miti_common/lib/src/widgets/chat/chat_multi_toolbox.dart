import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class ChatMultiSelToolbox extends StatelessWidget {
  const ChatMultiSelToolbox({super.key, this.onDelete, this.onMergeForward, this.onByOneForward});
  final Function()? onDelete;
  final Function()? onMergeForward;
  final Function()? onByOneForward;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: StylesLibrary.c_F7F8FA,
      height: 100.h,
      padding: EdgeInsets.only(top: 15.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          70.horizontalSpace,
          Flexible(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageLibrary.multiBoxDel.toImage
                ..width = 48.w
                ..height = 48.h
                ..onTap = onDelete,
              4.verticalSpace,
              StrLibrary.delete.toText..style = StylesLibrary.ts_FF4E4C_10sp,
            ],
          )),
          Flexible(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageLibrary.multiBoxForward.toImage
                ..width = 48.w
                ..height = 48.h
                ..onTap = onMergeForward,
              4.verticalSpace,
              StrLibrary.mergeForward.toText..style = StylesLibrary.ts_333333_10sp,
            ],
          )),
          Flexible(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ImageLibrary.multiBoxForward.toImage
                ..width = 48.w
                ..height = 48.h
                ..onTap = onByOneForward,
              4.verticalSpace,
              StrLibrary.oneByOneForward.toText
                ..style = StylesLibrary.ts_333333_10sp
                ..textAlign = TextAlign.center,
            ],
          )),
          70.horizontalSpace,
        ],
      ),
    );
  }
}
