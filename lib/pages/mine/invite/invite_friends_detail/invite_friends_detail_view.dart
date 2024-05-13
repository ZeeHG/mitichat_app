import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

import 'invite_friends_detail_logic.dart';

class InviteFriendsDetailPage extends StatelessWidget {
  final logic = Get.find<InviteFriendsDetailLogic>();
  final iMCtrl = Get.find<IMCtrl>();

  InviteFriendsDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Obx(() => Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 15.h),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      AppNavigator.startInviteFriendsHistory();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: 165.w,
                      decoration: BoxDecoration(
                          color: StylesLibrary.c_FFFFFF,
                          borderRadius: BorderRadius.circular(10.w)),
                      padding: EdgeInsets.all(12.w),
                      child: Column(
                        children: [
                          logic.invitedTotal.toString().toText
                            ..style = StylesLibrary.ts_333333_24sp_bold,
                          8.verticalSpace,
                          StrLibrary.invited.toText
                            ..style =
                                StylesLibrary.ts_333333_14sp_regular_opacity70,
                        ],
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      AppNavigator.startInvitingFriends();
                    },
                    behavior: HitTestBehavior.translucent,
                    child: Container(
                      width: 165.w,
                      decoration: BoxDecoration(
                          color: StylesLibrary.c_FFFFFF,
                          borderRadius: BorderRadius.circular(10.w)),
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.w, vertical: 15.h),
                      child: Column(
                        children: [
                          logic.invitingTotal.toString().toText
                            ..style = StylesLibrary.ts_333333_24sp_bold,
                          8.verticalSpace,
                          StrLibrary.waitingAgree.toText
                            ..style =
                                StylesLibrary.ts_333333_14sp_regular_opacity70,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              15.verticalSpace,
              _buildItemView(
                  label: StrLibrary.idInvite,
                  icon: ImageLibrary.iDinvite,
                  showRightArrow: false,
                  buttonText: StrLibrary.copy,
                  onTapButton: () {
                    MitiUtils.copy(text: iMCtrl.userInfo.value.mitiID ?? "");
                  }),
              15.verticalSpace,
              _buildItemView(
                  label: StrLibrary.qrcodeInvite,
                  icon: ImageLibrary.qrcodeInvite,
                  showRightArrow: true,
                  onTap: () {}),
              15.verticalSpace,
              _buildItemView(
                  label: StrLibrary.urlInvite,
                  icon: ImageLibrary.urlInvite,
                  showRightArrow: false,
                  buttonText: StrLibrary.share,
                  onTapButton: () {}),
            ]))),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    required String icon,
    bool showRightArrow = true,
    String? buttonText,
    Function()? onTapButton,
    Function()? onTap,
  }) =>
      GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: Container(
            decoration: BoxDecoration(
              color: StylesLibrary.c_FFFFFF,
              borderRadius: BorderRadius.circular(10.r)
            ),
            padding: EdgeInsets.symmetric(horizontal: 15.w),
            child: Container(
              height: 58.h,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Row(
                children: [
                  icon.toImage
                    ..width = 20.w
                    ..height = 20.h,
                  8.horizontalSpace,
                  label.toText..style = StylesLibrary.ts_333333_16sp_medium,
                  const Spacer(),
                  if (null != buttonText)
                    GestureDetector(
                        onTap: onTapButton,
                        behavior: HitTestBehavior.translucent,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 16.w, vertical: 4.h),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(26.r),
                              border: Border.all(
                                color: StylesLibrary.c_8443F8,
                                width: 1.h,
                              )),
                          child: buttonText.toText
                            ..style = StylesLibrary.ts_8443F8_12sp,
                        )),
                  if (showRightArrow)
                    ImageLibrary.appRightArrow.toImage
                      ..width = 20.w
                      ..height = 20.h,
                ],
              ),
            ),
          ));
}
