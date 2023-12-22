import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'meeting_detail_logic.dart';

class MeetingDetailPage extends StatelessWidget {
  final logic = Get.find<MeetingDetailLogic>();

  MeetingDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrRes.meetingDetail,
        right: Row(
          children: [
            ImageRes.meetingForward.toImage
              ..width = 36.w
              ..height = 36.h
              ..onTap = logic.shareMeeting,
            12.horizontalSpace,
            ImageRes.moreBlack.toImage
              ..width = 24.w
              ..height = 24.h
              ..onTap = logic.editMeeting,
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            Container(
              color: Styles.c_FFFFFF,
              padding: EdgeInsets.only(
                left: 16.w,
                right: 16.w,
                top: 16.h,
                bottom: 20.h,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  (logic.meetingInfo.meetingName ?? '').toText
                    ..style = Styles.ts_0C1C33_17sp_medium,
                  14.verticalSpace,
                  Row(
                    children: [
                      22.horizontalSpace,
                      logic.meetingStartTime.toText
                        ..style = Styles.ts_0C1C33_20sp_medium,
                      const Spacer(),
                      Container(
                        decoration: BoxDecoration(
                          color: logic.isStartedMeeting()
                              ? Styles.c_FFB300
                              : Styles.c_0089FF,
                          borderRadius: BorderRadius.circular(12.r),
                        ),
                        padding: EdgeInsets.symmetric(
                          horizontal: 10.w,
                          vertical: 2.h,
                        ),
                        child: Text(
                          logic.isStartedMeeting()
                              ? StrRes.started
                              : StrRes.didNotStart,
                          style: Styles.ts_FFFFFF_12sp,
                        ),
                      ),
                      const Spacer(),
                      logic.meetingEndTime.toText
                        ..style = Styles.ts_0C1C33_20sp_medium,
                      22.horizontalSpace,
                    ],
                  ),
                  Row(
                    children: [
                      logic.meetingStartDate.toText
                        ..style = Styles.ts_8E9AB0_14sp,
                      const Spacer(),
                      Container(
                        height: 1.h,
                        width: 28.w,
                        margin: EdgeInsets.only(right: 5.w),
                        color: Styles.c_E8EAEF,
                      ),
                      logic.meetingDuration.toText
                        ..style = Styles.ts_8E9AB0_14sp,
                      Container(
                        height: 1.h,
                        width: 28.w,
                        margin: EdgeInsets.only(left: 5.w),
                        color: Styles.c_E8EAEF,
                      ),
                      const Spacer(),
                      logic.meetingEndDate.toText
                        ..style = Styles.ts_8E9AB0_14sp,
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Styles.c_FFFFFF,
              margin: EdgeInsets.only(top: 12.h),
              padding: EdgeInsets.only(left: 15.w, right: 15.w),
              child: Column(
                children: [
                  _buildItemView(
                    value: sprintf(StrRes.meetingNoIs, [logic.meetingNo]),
                    showCopy: true,
                    onTap: logic.copy,
                  ),
                  _buildItemView(
                    value: sprintf(
                        StrRes.meetingOrganizerIs, [logic.meetingCreator]),
                  ),
                ],
              ),
            ),
            Button(
              text: StrRes.enterMeeting,
              onTap: logic.enterMeeting,
              margin: EdgeInsets.symmetric(
                horizontal: 72.w,
                vertical: 90.h,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItemView({
    String? value,
    bool showCopy = false,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 44.h,
          color: Styles.c_FFFFFF,
          child: Row(
            children: [
              (value ?? '').toText..style = Styles.ts_0C1C33_17sp,
              6.horizontalSpace,
              if (showCopy)
                ImageRes.mineCopy.toImage
                  ..width = 16.w
                  ..height = 16.h,
            ],
          ),
        ),
      );
}
