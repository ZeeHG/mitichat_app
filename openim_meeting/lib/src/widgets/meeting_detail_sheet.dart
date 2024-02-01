import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sprintf/sprintf.dart';

class MeetingDetailSheetView extends StatefulWidget {
  const MeetingDetailSheetView({
    Key? key,
    required this.info,
    required this.hostNickname,
  }) : super(key: key);
  final MeetingInfo info;
  final String hostNickname;

  @override
  State<MeetingDetailSheetView> createState() => _MeetingDetailSheetViewState();
}

class _MeetingDetailSheetViewState extends State<MeetingDetailSheetView> {
  final subject = PublishSubject<bool>();
  UserInfo? _hostUserInfo;

  @override
  void initState() {
    _queryHostUserInfo();
    super.initState();
  }

  @override
  void dispose() {
    subject.close();
    super.dispose();
  }

  _queryHostUserInfo() async {
    if (null != widget.info.hostUserID) {
      final list = (await OpenIM.iMManager.userManager.getUsersInfo(
        userIDList: [widget.info.hostUserID!],
      ));
      if (!mounted) return;
      setState(() {
        final user = list.firstOrNull;
        _hostUserInfo = user?.simpleUserInfo;
      });
    }
  }

  void copy() {
    Clipboard.setData(ClipboardData(text: widget.info.roomID!));
    subject.add(true);
    Future.delayed(.5.seconds, () => subject.add(false));
  }

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFFFF),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(14.r),
            topRight: Radius.circular(14.r),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                14.verticalSpace,
                Center(
                  child: (widget.info.meetingName ?? sprintf(StrRes.meetingInitiatorIs, [widget.hostNickname])).toText
                    ..style = Styles.ts_0C1C33_17sp_medium,
                ),
                19.verticalSpace,
                GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: copy,
                  child: Row(
                    children: [
                      sprintf(StrRes.meetingNoIs, [widget.info.roomID]).toText..style = Styles.ts_8E9AB0_17sp,
                      ImageRes.mineCopy.toImage
                        ..width = 24.w
                        ..height = 24.h,
                    ],
                  ),
                ),
                16.verticalSpace,
                sprintf(StrRes.meetingHostIs, [_hostUserInfo?.nickname ?? '']).toText..style = Styles.ts_8E9AB0_17sp,
                16.verticalSpace,
                sprintf(StrRes.meetingStartTimeIs, [
                  DateUtil.formatDateMs(
                    widget.info.startTime! * 1000,
                    format: IMUtils.getTimeFormat1(),
                  )
                ]).toText
                  ..style = Styles.ts_8E9AB0_17sp,
                16.verticalSpace,
                '${sprintf(StrRes.meetingDurationIs, [(widget.info.endTime! - widget.info.startTime!) / 60 / 60])}${StrRes.hour}'.toText
                  ..style = Styles.ts_8E9AB0_17sp,
                16.verticalSpace,
              ],
            ),
            StreamBuilder(
              stream: subject.stream,
              initialData: false,
              builder: (_, AsyncSnapshot<bool> hot) => Visibility(
                visible: hot.data ?? false,
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: 10.w,
                    vertical: 6.h,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(6.r),
                  ),
                  child: StrRes.copySuccessfully.toText..style = Styles.ts_FFFFFF_14sp,
                ),
              ),
            )
          ],
        ),
      );
}

// class MeetingDetailSheetView extends StatelessWidget {
//   const MeetingDetailSheetView({
//     Key? key,
//     required this.info,
//     required this.hostNickname,
//   }) : super(key: key);
//   final MeetingInfo info;
//   final String hostNickname;
//
//   @override
//   Widget build(BuildContext context) => Container(
//     padding: EdgeInsets.symmetric(horizontal: 16.w),
//         decoration: BoxDecoration(
//           color: const Color(0xFFFFFFFF),
//           borderRadius: BorderRadius.only(
//             topLeft: Radius.circular(14.r),
//             topRight: Radius.circular(14.r),
//           ),
//         ),
//         child: Stack(
//           alignment: Alignment.center,
//           children: [
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 14.verticalSpace,
//                 Center(
//                   child: (info.meetingName ??
//                           sprintf(StrRes.meetingInitiatorIs, [hostNickname]))
//                       .toText
//                     ..style = Styles.ts_0C1C33_17sp_medium,
//                 ),
//                 19.verticalSpace,
//                 GestureDetector(
//                   behavior: HitTestBehavior.translucent,
//                   onTap: () => IMUtils.copy(text: info.roomID!),
//                   child: Row(
//                     children: [
//                       sprintf(StrRes.meetingNoIs, [info.roomID]).toText
//                         ..style = Styles.ts_8E9AB0_17sp,
//                       ImageRes.mineCopy.toImage
//                         ..width = 24.w
//                         ..height = 24.h,
//                     ],
//                   ),
//                 ),
//                 16.verticalSpace,
//                 sprintf(StrRes.meetingHostIs, [hostNickname]).toText
//                   ..style = Styles.ts_8E9AB0_17sp,
//                 16.verticalSpace,
//                 sprintf(StrRes.meetingStartTimeIs, [
//                   DateUtil.formatDateMs(
//                     info.startTime! * 1000,
//                     format: IMUtils.getTimeFormat1(),
//                   )
//                 ]).toText
//                   ..style = Styles.ts_8E9AB0_17sp,
//                 16.verticalSpace,
//                 '${sprintf(StrRes.meetingDurationIs, [
//                       (info.endTime! - info.startTime!) / 60 / 60
//                     ])}${StrRes.hour}'
//                     .toText
//                   ..style = Styles.ts_8E9AB0_17sp,
//                 16.verticalSpace,
//               ],
//             ),
//             FutureBuilder(
//               future: Future.delayed(1.seconds, () => false),
//               builder: (_, AsyncSnapshot<bool> hot) => Visibility(
//                 visible: hot.data ?? false,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(
//                     horizontal: 10.w,
//                     vertical: 4.h,
//                   ),
//                   decoration: BoxDecoration(
//                     color: Colors.black.withOpacity(0.5),
//                     borderRadius: BorderRadius.circular(6.r),
//                   ),
//                   child: StrRes.copySuccessfully.toText
//                     ..style = Styles.ts_FFFFFF_14sp,
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
// }
