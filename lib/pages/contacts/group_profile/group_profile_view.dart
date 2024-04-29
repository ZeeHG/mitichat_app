import 'dart:math';

import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'group_profile_logic.dart';

class GroupProfilePage extends StatelessWidget {
  final logic = Get.find<GroupProfileLogic>();

  GroupProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(),
      backgroundColor: StylesLibrary.c_F7F8FA,
      body: Obx(() => Column(
            children: [
              _buildBaseInfo(),
              if (logic.members.isNotEmpty) _buildGroupMemberList(),
              Container(
                height: 56.h,
                color: StylesLibrary.c_FFFFFF,
                padding: EdgeInsets.symmetric(horizontal: 16.w),
                child: Row(
                  children: [
                    StrLibrary.groupID.toText
                      ..style = StylesLibrary.ts_333333_16sp,
                    12.horizontalSpace,
                    logic.groupInfo.value.groupID.toText
                      ..style = StylesLibrary.ts_999999_16sp,
                  ],
                ),
              ),
              const Spacer(),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
                color: StylesLibrary.c_FFFFFF,
                child: Button(
                  text: logic.isJoined.value
                      ? StrLibrary.enterGroup
                      : StrLibrary.applyJoin,
                  onTap: logic.enterGroup,
                ),
              ),
            ],
          )),
    );
  }

  Widget _buildBaseInfo() => Container(
        height: 80.h,
        color: StylesLibrary.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        margin: EdgeInsets.only(bottom: 10.h),
        child: Row(
          children: [
            AvatarView(
              width: 48.w,
              height: 48.h,
              url: logic.groupInfo.value.faceURL,
              text: logic.groupInfo.value.groupName,
              isGroup: true,
            ),
            12.horizontalSpace,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  (logic.groupInfo.value.groupName ?? '').toText
                    ..style = StylesLibrary.ts_333333_16sp_medium,
                  4.verticalSpace,
                  Row(
                    children: [
                      ImageLibrary.createGroupTime.toImage
                        ..width = 12.w
                        ..height = 12.h,
                      6.horizontalSpace,
                      DateUtil.formatDateMs(
                        (logic.groupInfo.value.createTime ?? 0),
                        format: MitiUtils.getTimeFormat1(),
                      ).toText
                        ..style = StylesLibrary.ts_999999_14sp,
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _buildGroupMemberList() => Container(
        color: StylesLibrary.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
        margin: EdgeInsets.only(bottom: 10.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            RichText(
              text: TextSpan(
                text: StrLibrary.groupMember,
                style: StylesLibrary.ts_333333_16sp,
                children: [
                  WidgetSpan(child: 12.horizontalSpace),
                  TextSpan(
                    text: sprintf(StrLibrary.nPerson,
                        [logic.groupInfo.value.memberCount]),
                    style: StylesLibrary.ts_999999_16sp,
                  ),
                ],
              ),
            ),
            10.verticalSpace,
            GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 7,
                crossAxisSpacing: 6.w,
                childAspectRatio: 1,
              ),
              itemCount: min(logic.members.length, 7),
              shrinkWrap: true,
              itemBuilder: (_, index) {
                final member = logic.members.elementAt(index);
                if (index == 6 && logic.members.length != 7) {
                  return ImageLibrary.moreMembers.toImage
                    ..width = 44.w
                    ..height = 44.h;
                }
                return AvatarView(
                  width: 44.w,
                  height: 44.h,
                  text: member.nickname,
                  url: member.faceURL,
                );
              },
            ),
          ],
        ),
      );
}
