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
                        if (logic.myInviteRecords.isEmpty)
                          StrLibrary.empty.toText
                            ..style = StylesLibrary.ts_333333_14sp,
                        if (logic.myInviteRecords.isNotEmpty)
                          ...List.generate(
                              logic.myInviteRecords.length,
                              (index) => Container(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 15.w),
                                    child: Row(
                                      children: [
                                        Expanded(
                                            child: Row(
                                          children: [
                                            AvatarView(
                                              width: 40.w,
                                              height: 40.h,
                                              url: logic.myInviteRecords[index]
                                                  .inviteUser.faceURL,
                                              text: logic.myInviteRecords[index]
                                                  .inviteUser.showName,
                                            ),
                                            8.horizontalSpace,
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                logic.myInviteRecords[index]
                                                    .inviteUser.showName.toText
                                                  ..style = StylesLibrary
                                                      .ts_333333_16sp,
                                                DateUtil.formatDateMs(logic
                                                        .myInviteRecords[index]
                                                        .applyTime * 1000,
                                                        format: "yyyy.MM.dd")
                                                    .toText
                                                  ..style = StylesLibrary
                                                      .ts_999999_12sp,
                                              ],
                                            )
                                          ],
                                        )),
                                        10.horizontalSpace,
                                        StrLibrary.inviteSuccess.toText
                                          ..style = StylesLibrary.ts_999999_12sp
                                      ],
                                    ),
                                  ))
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
