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
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Obx(() => SingleChildScrollView(
            child: logic.users.isEmpty
                ? Container()
                : Container(
                    width: 1.sw,
                    padding:
                        EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
                    decoration: BoxDecoration(color: StylesLibrary.c_FFFFFF),
                    child: Column(
                        children: List.generate(
                            logic.users.length,
                            (index) =>
                                _buildItemView(user: logic.users[index]))),
                  ),
          )),
    );
  }

  Widget _buildItemView({required dynamic user}) => Container(
        padding: EdgeInsets.symmetric(horizontal: 12.w),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
                child: Row(
              children: [
                Expanded(
                  child: user["inviteUserID"].toString().toText
                    ..maxLines = 1
                    ..overflow = TextOverflow.ellipsis,
                ),
                10.horizontalSpace,
                _buildTimeView(user["applyTime"])
              ],
            )),
            10.horizontalSpace,
            Button(
              width: 50.w,
              height: 30.h,
              text: StrLibrary.accept,
              onTap: () => logic.agreeOrReject(user, 1),
              enabled: user["disabled"] != true,
            ),
            10.horizontalSpace,
            Button(
              width: 50.w,
              height: 30.h,
              text: StrLibrary.reject,
              onTap: () => logic.agreeOrReject(user, 2),
              enabled: user["disabled"] != true,
            ),
          ],
        ),
      );

  Widget _buildTimeView(int time) => TimelineUtil.format(
        time*1000,
        dayFormat: DayFormat.Full,
        locale: Get.locale?.languageCode ?? 'zh',
      ).toText
        ..style = StylesLibrary.ts_999999_12sp;
}
