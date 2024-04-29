import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

/// 群公告
class ChatNoticeView extends StatelessWidget {
  const ChatNoticeView({
    Key? key,
    required this.isISend,
    required this.content,
  }) : super(key: key);
  final bool isISend;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: maxWidth),
      padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: (isISend ? StylesLibrary.c_8443F8 : StylesLibrary.c_FFFFFF),
        border: Border.all(color: StylesLibrary.c_E8EAEF, width: 1.h),
        borderRadius: borderRadius(isISend),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ImageLibrary.notice.toImage
                ..width = 24.w
                ..height = 24.h,
              StrLibrary.groupAc.toText
                ..style = (isISend
                    ? StylesLibrary.ts_FFFFFF_16sp
                    : StylesLibrary.ts_333333_16sp),
            ],
          ),
          6.verticalSpace,
          content.toText
            ..style = (isISend
                ? StylesLibrary.ts_FFFFFF_16sp
                : StylesLibrary.ts_333333_16sp),
        ],
      ),
    );
  }
}

class TopNoticeView extends StatelessWidget {
  const TopNoticeView({
    Key? key,
    required this.content,
    this.onPreview,
    this.onClose,
  }) : super(key: key);
  final String content;
  final Function()? onPreview;
  final Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 10.w, right: 10.w, top: 10.h),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: StylesLibrary.c_F2F8FF,
        borderRadius: BorderRadius.circular(6.r),
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onPreview,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                ImageLibrary.notice.toImage
                  ..width = 24.w
                  ..height = 24.h,
                2.horizontalSpace,
                StrLibrary.groupAc.toText..style = StylesLibrary.ts_8443F8_16sp,
                const Spacer(),
                ImageLibrary.closeGroupNotice.toImage
                  ..width = 16.w
                  ..height = 16.h
                  ..onTap = onClose,
              ],
            ),
            8.verticalSpace,
            content.toText
              ..style = StylesLibrary.ts_333333_14sp
              ..maxLines = 2
              ..overflow = TextOverflow.ellipsis,
          ],
        ),
      ),
    );
  }
}
