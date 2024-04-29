import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'handle_friend_requests_logic.dart';

class HandleFriendRequestsPage extends StatelessWidget {
  final logic = Get.find<HandleFriendRequestsLogic>();

  HandleFriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.newFriend),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Container(
        color: StylesLibrary.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          children: [
            Row(
              children: [
                AvatarView(
                  width: 42.w,
                  height: 42.h,
                  url: logic.applicationInfo.fromFaceURL,
                  text: logic.applicationInfo.fromNickname,
                ),
                10.horizontalSpace,
                (logic.applicationInfo.fromNickname ?? '').toText
                  ..style = StylesLibrary.ts_333333_16sp,
              ],
            ),
            10.verticalSpace,
            if (MitiUtils.isNotNullEmptyStr(logic.applicationInfo.reqMsg))
              Container(
                height: 80.h,
                width: 343.w,
                margin: EdgeInsets.only(bottom: 10.h),
                decoration: BoxDecoration(
                  color: StylesLibrary.c_E8EAEF_opacity50,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 12.w,
                    vertical: 12.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (logic.applicationInfo.reqMsg ?? '').toText
                        ..style = StylesLibrary.ts_333333_16sp,
                    ],
                  ),
                ),
              ),
            Row(
              children: [
                Flexible(
                    child: Button(
                        text: StrLibrary.reject,
                        textStyle: StylesLibrary.ts_333333_16sp,
                        onTap: logic.refuseFriendApplication,
                        enabledColor: StylesLibrary.c_FFFFFF,
                        borderColor: StylesLibrary.c_CCCCCC)),
                12.horizontalSpace,
                Flexible(
                  child: Button(
                    text: StrLibrary.accept,
                    textStyle: StylesLibrary.ts_FFFFFF_16sp,
                    onTap: logic.acceptFriendApplication,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
