import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatMeetingView extends StatelessWidget {
  const ChatMeetingView({
    Key? key,
    required this.inviterUserID,
    this.inviterNickname,
    required this.subject,
    required this.start,
    required this.duration,
    required this.id,
  }) : super(key: key);
  final String inviterUserID;
  final String? inviterNickname;
  final String subject;
  final int start;
  final int duration;
  final String id;

  Widget _buildMeetingInfoItemView(String text, String value) => Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 24.h,
            alignment: Alignment.center,
            child: Center(
              child: Container(
                width: 6.w,
                height: 6.h,
                decoration: BoxDecoration(
                  color: Styles.c_333333,
                  shape: BoxShape.circle,
                ),
              ),
            ),
          ),
          8.horizontalSpace,
          Expanded(
            child: sprintf(text, [value]).toText..style = Styles.ts_333333_17sp,
          ),
        ],
      );

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints(maxWidth: maxWidth),
      width: maxWidth,
      decoration: BoxDecoration(
        color: Styles.c_FFFFFF,
        border: Border.all(color: Styles.c_E8EAEF, width: 1),
        borderRadius: BorderRadius.circular(6.r),
      ),
      padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 10.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageRes.videoMeeting.toImage
                ..width = 20.h
                ..height = 20.h,
              2.horizontalSpace,
              Expanded(
                // child: sprintf(
                //         StrLibrary .invitesYouToVideoConference, [inviterNickname])
                //     .toText
                //   ..style = Styles.ts_333333_17sp
                //   ..maxLines = 1
                //   ..overflow = TextOverflow.ellipsis,
                child: subject.toText
                  ..style = Styles.ts_333333_17sp
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
            ],
          ),
          8.verticalSpace,
          // _buildMeetingInfoItemView(
          //   StrLibrary .meetingSubjectIs,
          //   subject ?? '',
          // ),
          // 2.verticalSpace,
          _buildMeetingInfoItemView(
            StrLibrary.meetingStartTimeIs,
            DateUtil.formatDateMs(
              start * 1000,
              format: IMUtils.getTimeFormat2(),
            ),
          ),
          2.verticalSpace,
          _buildMeetingInfoItemView(
            StrLibrary.meetingDurationIs,
            '${duration / 60 / 60} ${StrLibrary.hours}',
          ),
          2.verticalSpace,
          _buildMeetingInfoItemView(StrLibrary.meetingNoIs, id),
          2.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: StrLibrary.enterMeeting.toText
                  ..style = Styles.ts_8443F8_17sp
                  ..textAlign = TextAlign.center
                  ..maxLines = 1
                  ..overflow = TextOverflow.ellipsis,
              ),
              ImageRes.nextBlue.toImage
                ..width = 24.w
                ..height = 24.h,
            ],
          )
        ],
      ),
    );
  }
}
