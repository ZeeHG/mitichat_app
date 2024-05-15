import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'invite_friends_logic.dart';

class InviteFriendsPage extends StatelessWidget {
  final logic = Get.find<InviteFriendsLogic>();

  InviteFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.inviteFriends),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Obx(() => SizedBox(
              width: 1.sw,
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 219.h,
                      ),
                      ImageLibrary.inviteBg.toImage
                        ..width = 375.w
                        ..height = 198.h,
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Button(
                            width: 289.w,
                            text: StrLibrary.inviteNow,
                            onTap: logic.inviteDetail,
                          ),
                        ),
                      )
                    ],
                  ),
                  15.verticalSpace,
                  Container(
                      decoration: BoxDecoration(
                        color: StylesLibrary.c_FFFFFF,
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      padding: EdgeInsets.symmetric(
                          vertical: 15.h, horizontal: 15.w),
                      margin: EdgeInsets.symmetric(horizontal: 15.h),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              // alignment: Alignment.center,
                              child: StrLibrary.inviteInstructions1.toText
                                ..style = StylesLibrary.ts_333333_16sp_medium,
                            ),
                            15.verticalSpace,
                            StrLibrary.inviteInstructions2.toText
                              ..style = StylesLibrary.ts_333333_14sp_medium,
                            4.verticalSpace,
                            StrLibrary.inviteInstructions3.toText
                              ..style = StylesLibrary.ts_666666_14sp,
                            15.verticalSpace,
                            StrLibrary.inviteInstructions4.toText
                              ..style = StylesLibrary.ts_666666_14sp,
                            15.verticalSpace,
                            StrLibrary.inviteInstructions5.toText
                              ..style = StylesLibrary.ts_333333_14sp_medium,
                            4.verticalSpace,
                            StrLibrary.inviteInstructions6.toText
                              ..style = StylesLibrary.ts_666666_14sp,
                          ])),
                  15.verticalSpace,
                  Container(
                    decoration: BoxDecoration(
                      color: StylesLibrary.c_FFFFFF,
                      borderRadius: BorderRadius.circular(10.w),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 15.h),
                    margin: EdgeInsets.symmetric(horizontal: 15.h),
                    child: Column(
                      children: [
                        Center(
                          // alignment: Alignment.center,
                          child: StrLibrary.myInviteRecords.toText
                            ..style = StylesLibrary.ts_333333_16sp_medium,
                        ),
                        15.verticalSpace,
                        if (logic.users.isEmpty && logic.inviteInfos.isEmpty)
                          StrLibrary.empty.toText
                            ..style = StylesLibrary.ts_333333_14sp,
                        if (logic.inviteInfos.isNotEmpty)
                          ...List.generate(logic.inviteInfos.length,
                              (index) => _buildInviteItem(logic.inviteInfos[index],index)),
                        if (logic.users.isNotEmpty)
                          ...List.generate(logic.users.length,
                              (index) => _buildUserItem(index))
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  _buildUserItem(int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      margin: EdgeInsets.only(top: index > 0 || logic.inviteInfos.isNotEmpty ? 15.h : 0),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              AvatarView(
                width: 40.w,
                height: 40.h,
                url: logic.users[index].faceURL,
                text: logic.users[index].showName,
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  logic.users[index].showName.toText
                    ..style = StylesLibrary.ts_333333_16sp,
                  DateUtil.formatDateMs(logic.applyTimes[index] * 1000,
                          format: "yyyy.MM.dd")
                      .toText
                    ..style = StylesLibrary.ts_999999_12sp,
                ],
              )
            ],
          )),
          10.horizontalSpace,
          StrLibrary.inviteSuccess.toText..style = StylesLibrary.ts_999999_12sp
        ],
      ),
    );
  }

  _buildInviteItem(InviteInfo inviteInfo, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w),
      margin: EdgeInsets.only(top: index > 0 ? 15.h : 0),
      child: Row(
        children: [
          Expanded(
              child: Row(
            children: [
              AvatarView(
                width: 40.w,
                height: 40.h,
                url: inviteInfo.inviteUser.faceURL,
                text: inviteInfo.inviteUser.showName,
              ),
              8.horizontalSpace,
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  inviteInfo.inviteUser.showName.toText
                    ..style = StylesLibrary.ts_333333_16sp,
                  DateUtil.formatDateMs(inviteInfo.applyTime * 1000,
                          format: "yyyy.MM.dd")
                      .toText
                    ..style = StylesLibrary.ts_999999_12sp,
                ],
              )
            ],
          )),
          10.horizontalSpace,
          GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () => logic.showModal(inviteInfo),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(50.r),
                  border: Border.all(color: StylesLibrary.c_8443F8, width: 1.w),
                ),
                child: StrLibrary.waitingAgree.toText
                  ..style = StylesLibrary.ts_8443F8_12sp,
              ))
        ],
      ),
    );
  }
}
