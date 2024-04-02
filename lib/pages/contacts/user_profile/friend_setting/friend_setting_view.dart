import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'friend_setting_logic.dart';

class FriendSettingPage extends StatelessWidget {
  final logic = Get.find<FriendSettingLogic>();

  FriendSettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.friendSetup,
      ),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
          children: [
            10.verticalSpace,
            itemView(
              label: StrLibrary.setupRemark,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(6.r),
                topLeft: Radius.circular(6.r),
              ),
              showRightArrow: true,
              onTap: logic.setFriendRemark,
            ),
            itemView(
              label: StrLibrary.recommendToFriend,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(6.r),
                bottomRight: Radius.circular(6.r),
              ),
              showRightArrow: true,
              onTap: logic.recommendToFriend,
            ),
            10.verticalSpace,
            Obx(() => itemView(
                  label: StrLibrary.addToBlacklist,
                  showSwitchButton: true,
                  switchOn:
                      logic.userProfilesLogic.userInfo.value.isBlacklist ==
                          true,
                  onChanged: (_) => logic.toggleBlacklist(),
                )),
            10.verticalSpace,
            itemView(
              isDelFriendButton: true,
              onTap: logic.deleteFromFriendList,
            )
          ],
        ),
      ),
    );
  }

  Widget itemView({
    String? label,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    BorderRadius? borderRadius,
    bool switchOn = false,
    bool isDelFriendButton = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: onTap,
        child: Container(
          height: 46.h,
          decoration: BoxDecoration(
            color: StylesLibrary.c_FFFFFF,
            borderRadius: borderRadius ?? BorderRadius.circular(6.r),
          ),
          alignment: isDelFriendButton ? Alignment.center : null,
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: isDelFriendButton
              ? (StrLibrary.unfriend.toText
                ..style = StylesLibrary.ts_FF4E4C_16sp)
              : Row(
                  children: [
                    (label ?? '').toText..style = StylesLibrary.ts_333333_16sp,
                    const Spacer(),
                    if (showRightArrow)
                      ImageLibrary.appRightArrow.toImage
                        ..width = 24.w
                        ..height = 24.h,
                    if (showSwitchButton)
                      CupertinoSwitch(
                        value: switchOn,
                        onChanged: onChanged,
                        activeColor: StylesLibrary.c_07C160,
                      ),
                  ],
                ),
        ),
      );
}
