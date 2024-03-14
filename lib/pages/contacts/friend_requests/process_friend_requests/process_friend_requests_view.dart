import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'process_friend_requests_logic.dart';

class ProcessFriendRequestsPage extends StatelessWidget {
  final logic = Get.find<ProcessFriendRequestsLogic>();

  ProcessFriendRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.newFriend),
      backgroundColor: Styles.c_F8F9FA,
      body: Container(
        color: Styles.c_FFFFFF,
        padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AvatarView(
                  width: 48.w,
                  height: 48.h,
                  url: logic.applicationInfo.fromFaceURL,
                  text: logic.applicationInfo.fromNickname,
                ),
                10.horizontalSpace,
                (logic.applicationInfo.fromNickname ?? '').toText
                  ..style = Styles.ts_333333_17sp,
              ],
            ),
            12.verticalSpace,
            if (IMUtils.isNotNullEmptyStr(logic.applicationInfo.reqMsg))
              Container(
                height: 80.h,
                width: 343.w,
                margin: EdgeInsets.only(bottom: 12.h),
                decoration: BoxDecoration(
                  color: Styles.c_E8EAEF_opacity50,
                  borderRadius: BorderRadius.circular(6.r),
                ),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 16.h,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      (logic.applicationInfo.reqMsg ?? '').toText
                        ..style = Styles.ts_333333_17sp,
                    ],
                  ),
                ),
              ),
            Row(
              children: [
                Flexible(child: _buildRejectButton()),
                12.horizontalSpace,
                Flexible(
                  child: Button(
                    text: StrLibrary.accept,
                    textStyle: Styles.ts_FFFFFF_17sp,
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

  Widget _buildRejectButton() => Material(
        child: Ink(
          height: 44.h,
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            border: Border.all(
              color: Styles.c_E8EAEF,
              width: 1,
            ),
            borderRadius: BorderRadius.circular(6.r),
          ),
          child: InkWell(
            onTap: logic.refuseFriendApplication,
            child: Container(
              alignment: Alignment.center,
              child: StrLibrary.reject.toText..style = Styles.ts_333333_17sp,
            ),
          ),
        ),
      );
}
