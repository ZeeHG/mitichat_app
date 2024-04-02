import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class ChatGroupCallHitView extends StatelessWidget {
  const ChatGroupCallHitView({
    Key? key,
    this.expandPanel,
    this.joinGroupCalling,
    this.showCallingMember = false,
    this.participants = const [],
    this.maxCount = 20,
  }) : super(key: key);

  final bool showCallingMember;
  final List<Participant> participants;
  final int maxCount;
  final Function()? expandPanel;
  final Function()? joinGroupCalling;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: StylesLibrary.c_F2F8FF,
            borderRadius: BorderRadius.circular(6.r),
          ),
          padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 8.h),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildLinkView(),
              if (showCallingMember) _buildMemberView(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLinkView() => GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: expandPanel,
        child: Row(
          children: [
            Expanded(
              child:
                  sprintf(StrLibrary.groupVideoCallHint, [participants.length])
                      .toText
                    ..style = StylesLibrary.ts_999999_14sp,
            ),
            Transform.rotate(
              angle: (showCallingMember ? 1 : 0) * pi,
              child: ImageLibrary.groupCallHitArrow.toImage
                ..width = 16.w
                ..height = 16.h,
            ),
          ],
        ),
      );

  Widget _buildMemberView() => Container(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            GridView.builder(
              padding: EdgeInsets.symmetric(horizontal: 9.w, vertical: 9.h),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 6,
                childAspectRatio: 1.0,
                crossAxisSpacing: 14.w,
                mainAxisSpacing: 9.h,
              ),
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: participants.length > maxCount
                  ? maxCount
                  : participants.length,
              itemBuilder: (context, index) {
                final info = participants.elementAt(index).groupMemberInfo;
                if (index == maxCount - 1) {
                  return ImageLibrary.moreCallMember.toImage
                    ..width = 44.w
                    ..height = 44.h;
                }
                return AvatarView(
                  url: info?.faceURL,
                  text: info?.nickname,
                  borderRadius: BorderRadius.circular(6.r),
                );
              },
            ),
            Container(color: StylesLibrary.c_E8EAEF, height: .5),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: joinGroupCalling,
              child: Container(
                height: 44.h,
                alignment: Alignment.center,
                child: StrLibrary.joinIn.toText
                  ..style = StylesLibrary.ts_8443F8_14sp,
              ),
            ),
          ],
        ),
      );
}
