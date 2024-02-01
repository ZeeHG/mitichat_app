import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'meeting_logic.dart';

class MeetingPage extends StatelessWidget {
  final logic = Get.find<MeetingLogic>();

  MeetingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return FocusDetector(
      onVisibilityGained: logic.queryUnfinishedMeeting,
      child: Scaffold(
        appBar: TitleBar.back(title: StrRes.videoMeeting),
        backgroundColor: Styles.c_FFFFFF,
        body: Column(
          children: [
            26.verticalSpace,
            Row(
              children: [
                26.horizontalSpace,
                _buildButtonIcon(
                  text: StrRes.joinMeeting,
                  icon: ImageRes.meetingJoin,
                  onTap: logic.joinMeeting,
                ),
                const Spacer(),
                _buildButtonIcon(
                  text: StrRes.quickMeeting,
                  icon: ImageRes.meetingQuickStart,
                  onTap: logic.quickMeeting,
                ),
                const Spacer(),
                _buildButtonIcon(
                  text: StrRes.bookAMeeting,
                  icon: ImageRes.meetingBook,
                  onTap: logic.bookMeeting,
                ),
                26.horizontalSpace,
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 16.h, left: 16.w, right: 16.w),
              height: 1,
              color: Styles.c_E8EAEF,
            ),
            Expanded(
              child: Obx(() => ListView.builder(
                    padding: EdgeInsets.only(top: 16.h),
                    itemCount: logic.meetingInfoList.length,
                    itemBuilder: (_, index) => _buildMeetingInfoItemView(
                      logic.meetingInfoList.elementAt(index),
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMeetingInfoItemView(MeetingInfo meetingInfo) => GestureDetector(
        onTap: () => logic.meetingDetail(meetingInfo),
        behavior: HitTestBehavior.translucent,
        child: Container(
          height: 58.h,
          padding: EdgeInsets.symmetric(horizontal: 26.w),
          margin: EdgeInsets.only(bottom: 10.h),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        ConstrainedBox(
                          constraints: BoxConstraints(maxWidth: 200.w),
                          child: logic.getMeetingSubject(meetingInfo).toText
                            ..style = Styles.ts_0C1C33_17sp
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis,
                        ),
                        Container(
                          margin: EdgeInsets.only(left: 8.w),
                          decoration: BoxDecoration(
                            color: logic.isStartedMeeting(meetingInfo)
                                ? Styles.c_FFB300
                                : Styles.c_0089FF,
                            borderRadius: BorderRadius.circular(3.r),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: 3.h,
                            horizontal: 5.w,
                          ),
                          child: (logic.isStartedMeeting(meetingInfo)
                                  ? StrRes.started
                                  : StrRes.didNotStart)
                              .toText
                            ..style = Styles.ts_FFFFFF_10sp,
                        ),
                      ],
                    ),
                    4.verticalSpace,
                    RichText(
                      text: TextSpan(
                        text: logic.getMeetingCreateDate(meetingInfo),
                        style: Styles.ts_8E9AB0_13sp,
                        children: [
                          WidgetSpan(child: 10.horizontalSpace),
                          TextSpan(
                            text: logic.getMeetingDuration(meetingInfo),
                            style: Styles.ts_8E9AB0_13sp,
                          ),
                          WidgetSpan(child: 10.horizontalSpace),
                          TextSpan(
                            text: logic.getMeetingOrganizer(meetingInfo),
                            style: Styles.ts_8E9AB0_13sp,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ImageRes.rightArrow.toImage
                ..width = 24.w
                ..height = 24.h,
            ],
          ),
        ),
      );

  Widget _buildButtonIcon({
    required String icon,
    required String text,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Column(
          children: [
            icon.toImage
              ..width = 50.w
              ..height = 50.h,
            6.verticalSpace,
            text.toText..style = Styles.ts_0C1C33_14sp,
          ],
        ),
      );
}
