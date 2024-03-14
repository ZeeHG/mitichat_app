import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'friend_permissions_logic.dart';

class FriendPermissionsPage extends StatelessWidget {
  final logic = Get.put(FriendPermissionsLogic());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: TitleBar.back(
          title: StrLibrary.friendPermissions,
        ),
        backgroundColor: Styles.c_F7F8FA,
        body: SingleChildScrollView(
            child: Container(
                width: 1.sw,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.only(top: 20.h, bottom: 12.h, left: 12.w),
                      child: StrLibrary.momentsAndStatus.toText
                        ..style = Styles.ts_999999_12sp,
                    ),
                    _buildItemView(
                      text: StrLibrary.moments,
                      switchOn: logic.momentsStatus.value,
                      onChanged: (_) => logic.changeMoments(),
                      showSwitchButton: true,
                    ),
                  ],
                )))));
  }

  Widget _buildItemView({
    required String text,
    String? hintText,
    TextStyle? textStyle,
    String? value,
    bool switchOn = false,
    bool isTopRadius = false,
    bool isBottomRadius = false,
    bool showRightArrow = false,
    bool showSwitchButton = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: Styles.c_FFFFFF,
          padding: EdgeInsets.only(left: 12.w, right: 12.w),
          child: Container(
            height: hintText == null ? 46.h : 68.h,
            child: Row(
              children: [
                null != hintText
                    ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          text.toText
                            ..style = textStyle ?? Styles.ts_333333_16sp,
                          hintText.toText..style = Styles.ts_999999_14sp,
                        ],
                      )
                    : (text.toText..style = textStyle ?? Styles.ts_333333_16sp),
                const Spacer(),
                if (null != value) value.toText..style = Styles.ts_999999_14sp,
                if (showSwitchButton)
                  CupertinoSwitch(
                    value: switchOn,
                    activeColor: Styles.c_07C160,
                    onChanged: onChanged,
                  ),
                if (showRightArrow)
                  ImageRes.appRightArrow.toImage
                    ..width = 24.w
                    ..height = 24.h,
              ],
            ),
          ),
        ),
      );
}
