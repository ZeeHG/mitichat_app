import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'inviting_friends_logic.dart';

class InvitingFriendsPage extends StatelessWidget {
  final logic = Get.find<InvitingFriendsLogic>();

  InvitingFriendsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
              title: StrLibrary.waitingAgree, result: logic.hadHandle.value),
          backgroundColor: StylesLibrary.c_F8F9FA,
          body: SingleChildScrollView(
            child: logic.inviteInfos.isEmpty
                ? Container(
                    margin: EdgeInsets.only(top: 112.h),
                    child: Center(
                      child: ImageLibrary.inviteEmpty.toImage
                        ..width = 224.w
                        ..height = 224.h,
                    ),
                  )
                : Container(
                    width: 1.sw,
                    padding:
                        EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
                    child: Column(
                        children: List.generate(
                            logic.inviteInfos.length,
                            (index) => _buildItemView(
                                inviteInfo: logic.inviteInfos[index]))),
                  ),
          ),
        ));
  }

  Widget _buildItemView({required InviteInfo inviteInfo}) => Container(
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
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(50.r),
                      border:
                          Border.all(color: StylesLibrary.c_8443F8, width: 1.w),
                    ),
                    child: StrLibrary.waitingAgree.toText
                      ..style = StylesLibrary.ts_8443F8_12sp,
                  ))
            ],
          ),
        ),
      );
}
