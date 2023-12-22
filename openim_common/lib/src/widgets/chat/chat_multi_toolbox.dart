import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatMultiSelToolbox extends StatelessWidget {
  const ChatMultiSelToolbox({Key? key, this.onDelete, this.onMergeForward})
      : super(key: key);
  final Function()? onDelete;
  final Function()? onMergeForward;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Styles.c_F0F2F6,
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
              StrRes.delete.toText..style = Styles.ts_FF381F_12sp,
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
              StrRes.mergeForward.toText..style = Styles.ts_0C1C33_10sp,
            ],
          ),
          98.horizontalSpace,
        ],
      ),
    );
  }
}
