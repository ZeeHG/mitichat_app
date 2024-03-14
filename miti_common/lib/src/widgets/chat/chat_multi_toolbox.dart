import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class ChatMultiSelToolbox extends StatelessWidget {
  const ChatMultiSelToolbox({Key? key, this.onDelete, this.onMergeForward})
      : super(key: key);
  final Function()? onDelete;
  final Function()? onMergeForward;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.c_F7F8FA,
      height: 92.h,
      // padding: EdgeInsets.symmetric(vertical: 12.h),
      child: Row(
        children: [
          98.horizontalSpace,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageRes.multiBoxDel.toImage
                ..width = 48.w
                ..height = 48.h
                ..onTap = onDelete,
              4.verticalSpace,
              StrLibrary.delete.toText..style = Styles.ts_FF4E4C_12sp,
            ],
          ),
          const Spacer(),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ImageRes.multiBoxForward.toImage
                ..width = 48.w
                ..height = 48.h
                ..onTap = onMergeForward,
              4.verticalSpace,
              StrLibrary.mergeForward.toText..style = Styles.ts_333333_10sp,
            ],
          ),
          98.horizontalSpace,
        ],
      ),
    );
  }
}
