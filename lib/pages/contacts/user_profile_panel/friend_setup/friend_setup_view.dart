import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'friend_setup_logic.dart';

class FriendSetupPage extends StatelessWidget {
  final logic = Get.find<FriendSetupLogic>();

  FriendSetupPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        title: StrLibrary.friendSetup,
      ),
      backgroundColor: Styles.c_F8F9FA,
      body: Column(
        children: [
          10.verticalSpace,
          _buildItemView(
            label: StrLibrary.setupRemark,
            borderRadius: BorderRadius.only(
              topRight: Radius.circular(6.r),
              topLeft: Radius.circular(6.r),
            ),
            showRightArrow: true,
            onTap: logic.setFriendRemark,
          ),
          _buildItemView(
            label: StrLibrary.recommendToFriend,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(6.r),
              bottomRight: Radius.circular(6.r),
            ),
            showRightArrow: true,
            onTap: logic.recommendToFriend,
          ),
          10.verticalSpace,
          Obx(() => _buildItemView(
                label: StrLibrary.addToBlacklist,
                showSwitchButton: true,
                switchOn:
                    logic.userProfilesLogic.userInfo.value.isBlacklist == true,
                onChanged: (_) => logic.toggleBlacklist(),
              )),
          10.verticalSpace,
          _buildItemView(
            isDelFriendButton: true,
            onTap: logic.deleteFromFriendList,
          )
        ],
      ),
    );
  }

  Widget _buildItemView({
    String? label,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    BorderRadius? borderRadius,
    bool switchOn = false,
    bool isDelFriendButton = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      Container(
        margin: EdgeInsets.symmetric(horizontal: 10.w),
        child: Ink(
          height: 46.h,
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: borderRadius ?? BorderRadius.circular(6.r),
          ),
          child: InkWell(
            onTap: onTap,
            child: Container(
              alignment: isDelFriendButton ? Alignment.center : null,
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: isDelFriendButton
                  ? (StrLibrary.unfriend.toText..style = Styles.ts_FF4E4C_17sp)
                  : Row(
                      children: [
                        (label ?? '').toText..style = Styles.ts_333333_17sp,
                        const Spacer(),
                        if (showRightArrow)
                          ImageRes.appRightArrow.toImage
                            ..width = 24.w
                            ..height = 24.h,
                        if (showSwitchButton)
                          CupertinoSwitch(
                            value: switchOn,
                            onChanged: onChanged,
                            activeColor: Styles.c_07C160,
                          ),
                      ],
                    ),
            ),
          ),
        ),
      );
}
