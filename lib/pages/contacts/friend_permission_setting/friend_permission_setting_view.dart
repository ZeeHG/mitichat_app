import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'friend_permission_setting_logic.dart';

class FriendPermissionSettingPage extends StatelessWidget {
  final logic = Get.put(FriendPermissionSettingLogic());
  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
        appBar: TitleBar.back(
          title: StrLibrary.friendPermissions,
        ),
        backgroundColor: Styles.c_F7F8FA,
        body: SingleChildScrollView(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.all(12.w),
              child: StrLibrary.momentsAndStatus.toText
                ..style = Styles.ts_999999_12sp,
            ),
            _itemView(
              text: StrLibrary.moments,
              switchOn: logic.seeMomentPermission.value,
              onChanged: (_) => logic.changeMoments(),
            ),
          ],
        ))));
  }

  Widget _itemView({
    required String text,
    bool switchOn = false,
    ValueChanged<bool>? onChanged,
    Function()? onTap,
  }) =>
      GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.translucent,
        child: Container(
          color: Styles.c_FFFFFF,
          padding: EdgeInsets.only(left: 12.w, right: 12.w),
          child: SizedBox(
            height: 46.h,
            child: Row(
              children: [
                text.toText..style = Styles.ts_333333_16sp,
                const Spacer(),
                CupertinoSwitch(
                  value: switchOn,
                  activeColor: Styles.c_07C160,
                  onChanged: onChanged,
                )
              ],
            ),
          ),
        ),
      );
}
