import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../../live_client.dart';
import 'participant.dart';
import 'participant_info.dart';

class BeCalledView extends StatelessWidget {
  const BeCalledView({
    Key? key,
    required this.callType,
    required this.inviterUserID,
    required this.inviteeUserIDList,
    this.memberInfoList,
    this.groupInfo,
  }) : super(key: key);
  final String inviterUserID;
  final List<String> inviteeUserIDList;
  final List<GroupMembersInfo>? memberInfoList;
  final GroupInfo? groupInfo;
  final CallType callType;

  @override
  Widget build(BuildContext context) {
    final inviterUserInfo =
        memberInfoList?.firstWhereOrNull((e) => e.userID == inviterUserID);
    return Column(
      children: [
        47.verticalSpace,
        Row(
          children: [
            16.horizontalSpace,
            if (null != groupInfo)
              AvatarView(
                url: groupInfo!.faceURL,
                text: groupInfo!.groupName,
                width: 48.w,
                height: 48.h,
                isGroup: true,
              ),
            10.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (null != inviterUserInfo)
                    sprintf(
                        callType == CallType.audio
                            ? StrRes.whoInvitedVoiceCallHint
                            : StrRes.whoInvitedVideoCallHint,
                        [inviterUserInfo.nickname]).toText
                      ..style = Styles.ts_FFFFFF_17sp_medium,
                  if (null != memberInfoList && memberInfoList!.isNotEmpty)
                    sprintf(StrRes.nPeopleCalling, [memberInfoList!.length])
                        .toText
                      ..style = Styles.ts_FFFFFF_14sp,
                ],
              ),
            ),
            16.horizontalSpace,
          ],
        ),
        48.verticalSpace,
        if (null != memberInfoList)
          GridView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 1.0,
              mainAxisSpacing: 10.w,
              crossAxisSpacing: 10.h,
            ),
            itemCount: memberInfoList!.length,
            shrinkWrap: true,
            itemBuilder: (_, index) => AvatarView(
              url: memberInfoList![index].faceURL,
              text: memberInfoList![index].nickname,
              width: 48.w,
              height: 48.h,
            ),
          ),
      ],
    );
  }
}

class CallingView extends StatelessWidget {
  const CallingView({
    Key? key,
    required this.participantTracks,
  }) : super(key: key);

  final List<ParticipantTrack> participantTracks;

  @override
  Widget build(BuildContext context) => GridView.builder(
        itemCount: participantTracks.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 4.h,
          crossAxisSpacing: 4.w,
          childAspectRatio: 1.0,
        ),
        itemBuilder: (_, i) {
          return ParticipantWidget.widgetFor(participantTracks.elementAt(i));
        },
      );
}
