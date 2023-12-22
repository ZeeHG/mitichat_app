import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

import 'button.dart';

class MeetingAppBar extends StatelessWidget {
  const MeetingAppBar({
    Key? key,
    this.title,
    this.time,
    this.openSpeakerphone = true,
    this.onMinimize,
    this.onEndMeeting,
    this.onTapSpeakerphone,
    this.onViewMeetingDetail,
  }) : super(key: key);
  final String? title;
  final String? time;
  final bool openSpeakerphone;
  final Function()? onEndMeeting;
  final Function()? onMinimize;
  final Function()? onTapSpeakerphone;
  final Function()? onViewMeetingDetail;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 48.h,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Row(
              children: [
                ImageButton.minimize(
                  width: 48.w,
                  height: 48.h,
                  onTap: onMinimize,
                ),
                ImageButton.trumpet(
                  width: 48.w,
                  height: 48.h,
                  on: openSpeakerphone,
                  onTap: onTapSpeakerphone,
                ),
                // ImageRes.liveClose.toImage
                //   ..width = 30.w
                //   ..height = 30.h,
                // 12.horizontalSpace,
                // ImageRes.meetingTrumpet.toImage
                //   ..width = 30.w
                //   ..height = 30.h,
                const Spacer(),
                GestureDetector(
                  onTap: onEndMeeting,
                  child: Container(
                    width: 54.w,
                    height: 28.h,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Styles.c_FF381F,
                      borderRadius: BorderRadius.circular(6.r),
                    ),
                    child: StrRes.over.toText..style = Styles.ts_FFFFFF_17sp,
                  ),
                ),
                16.horizontalSpace,
              ],
            ),
            Column(
              children: [
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onViewMeetingDetail,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 100.w),
                        child: (title ?? '').toText
                          ..style = Styles.ts_FFFFFF_17sp
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis
                          ..textAlign = TextAlign.right,
                      ),
                      Icon(
                        EvaIcons.chevronDownOutline,
                        size: 30.h,
                        color: Styles.c_FFFFFF,
                      ),
                      // ImageButton.expandArrow(
                      //   width: 48.w,
                      //   height: 48.h,
                      //   onTap: () {},
                      // ),
                      // ImageRes.meetingExpandArrow.toImage
                      //   ..width = 30.w
                      //   ..height = 30.h,
                    ],
                  ),
                ),
                if (null != time) time!.toText..style = Styles.ts_FFFFFF_12sp,
              ],
            ),
          ],
        ),
      );
}
