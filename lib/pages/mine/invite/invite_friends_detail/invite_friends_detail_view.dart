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
      appBar: TitleBar.back(title: StrLibrary.newFriend),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Obx(() => Container(
            width: 1.sw,
            padding: EdgeInsets.all(12.w),
            child: Column(children: [
              GestureDetector(
                onTap: () {
                  AppNavigator.startInviteFriendsHistory();
                },
                behavior: HitTestBehavior.translucent,
                child: Container(
                  width: 1.sw-24.w,
                  decoration: BoxDecoration(
                      color: StylesLibrary.c_FFFFFF,
                      borderRadius: BorderRadius.circular(12.w)),
                  padding: EdgeInsets.all(12.w),
                  child: Column(
                    children: [
                      StrLibrary.invited.toText
                        ..style = StylesLibrary.ts_333333_14sp,
                      10.verticalSpace,
                      logic.invitedTotal.toString().toText
                        ..style = StylesLibrary.ts_333333_16sp,
                    ],
                  ),
                ),
              ),
              10.verticalSpace,
              _buildItemView(
                  label: StrLibrary.invitationCode,
                  value: iMCtrl.userInfo.value.mitiID,
                  showRightArrow: false,
                  onTap: () {
                    MitiUtils.copy(text: iMCtrl.userInfo.value.mitiID ?? "");
                  }),
              10.verticalSpace,
              _buildItemView(
                  label: StrLibrary.waitingAgree,
                  value: logic.invitingTotal.toString(),
                  onTap: () {
                    AppNavigator.startInvitingFriends();
                  })
            ]))),
      ),
    );
  }

  Widget _buildItemView({
    required String label,
    TextStyle? textStyle,
    String? value,
    bool switchOn = false,
    bool showRightArrow = true,
    bool showSwitchButton = false,
    bool showBorder = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
          onTap: onTap,
          behavior: HitTestBehavior.translucent,
          child: Container(
            decoration: BoxDecoration(
              color: StylesLibrary.c_FFFFFF,
            ),
            padding: EdgeInsets.symmetric(horizontal: 12.w),
            child: Container(
              height: 50.h,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: StylesLibrary.c_F1F2F6,
                    width: showBorder ? 1.h : 0,
                  ),
                ),
              ),
              child: Row(
                children: [
                  label.toText
                    ..style = textStyle ?? StylesLibrary.ts_333333_16sp,
                  const Spacer(),
                  if (null != value)
                    value.toText..style = StylesLibrary.ts_333333_14sp,
                  if (showSwitchButton)
                    CupertinoSwitch(
                      value: switchOn,
                      activeColor: StylesLibrary.c_07C160,
                      onChanged: onChanged,
                    ),
                  if (showRightArrow)
                    ImageLibrary.appRightArrow.toImage
                      ..width = 20.w
                      ..height = 20.h,
                ],
              ),
            ),
          ));
}
