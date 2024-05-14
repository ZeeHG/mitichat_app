import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'invite_friends_history_logic.dart';

class InviteFriendsHistoryPage extends StatelessWidget {
  final logic = Get.find<InviteFriendsHistoryLogic>();

  InviteFriendsHistoryPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.invited),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: logic.users.isEmpty? Container(
                    margin: EdgeInsets.only(top: 112.h),
                    child: Center(
                      child: ImageLibrary.inviteEmpty.toImage
                        ..width = 224.w
                        ..height = 224.h,
                    ),
                  ) : Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
              child: Column(
                  children: List.generate(logic.users.length,
                      (index) => _buildItemView(user: logic.users[index]))),
            ),
          )),
    );
  }

  Widget _buildItemView({required UserFullInfo user}) => Container(
    margin: EdgeInsets.only(bottom: 15.h),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.r),
            color: StylesLibrary.c_FFFFFF,
          ),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  AvatarView(
                    width: 40.w,
                    height: 40.h,
                    url: user.faceURL,
                    text: user.showName,
                  ),
                  8.horizontalSpace,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      user.showName.toText
                        ..style = StylesLibrary.ts_333333_16sp,
                      DateUtil.formatDateMs(
                              0, format: "yyyy.MM.dd")
                          .toText
                        ..style = StylesLibrary.ts_999999_12sp,
                    ],
                  )
                ],
              )),
              10.horizontalSpace,
              StrLibrary.inviteSuccess.toText
                ..style = StylesLibrary.ts_999999_12sp
            ],
          ),
        ),
      );
}
