import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'process_group_requests_logic.dart';

class ProcessGroupRequestsPage extends StatelessWidget {
  final logic = Get.find<ProcessGroupRequestsLogic>();

  ProcessGroupRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.newGroup),
      backgroundColor: Styles.c_F8F9FA,
      body: Container(
        color: Styles.c_FFFFFF,
        padding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 16.h,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                AvatarView(
                  width: 48.w,
                  height: 48.h,
                  url: logic.applicationInfo.userFaceURL,
                  text: logic.applicationInfo.nickname,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (logic.applicationInfo.nickname ?? '').toText
                      ..style = Styles.ts_333333_17sp,
                    // if (!logic.isInvite)
                    RichText(
                      text: TextSpan(
                        text: StrLibrary.applyJoin,
                        style: Styles.ts_999999_14sp,
                        children: [
                          WidgetSpan(child: 2.horizontalSpace),
                          TextSpan(
                            text: logic.groupName,
                            style: Styles.ts_8443F8_14sp,
                          ),
                        ],
                      ),
                    )
                    // else
                    //   RichText(
                    //     text: TextSpan(
                    //       text: logic.getInviterNickname(),
                    //       style: Styles.ts_8443F8_14sp,
                    //       children: [
                    //         WidgetSpan(child: 2.horizontalSpace),
                    //         TextSpan(
                    //           text: StrLibrary .invite,
                    //           style: Styles.ts_999999_14sp,
                    //         ),
                    //         WidgetSpan(child: 2.horizontalSpace),
                    //         TextSpan(
                    //           text: logic.applicationInfo.nickname,
                    //           style: Styles.ts_8443F8_14sp,
                    //         ),
                    //         WidgetSpan(child: 2.horizontalSpace),
                    //         TextSpan(
                    //           text: StrLibrary .joinIn,
                    //           style: Styles.ts_999999_14sp,
                    //         ),
                    //         WidgetSpan(child: 2.horizontalSpace),
                    //         TextSpan(
                    //           text: logic.groupName,
                    //           style: Styles.ts_8443F8_14sp,
                    //         ),
                    //       ],
                    //     ),
                    //   ),
                  ],
                ),
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
                    vertical: 8.h,
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                sprintf(StrLibrary.sourceFrom, [logic.sourceFrom]).toText
                  ..style = Styles.ts_999999_14sp
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Flexible(child: _buildRejectButton()),
                12.horizontalSpace,
                Flexible(
                  child: Button(
                    onTap: logic.approve,
                    text: StrLibrary.accept,
                    textStyle: Styles.ts_FFFFFF_17sp,
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
            onTap: logic.reject,
            child: Container(
              alignment: Alignment.center,
              child: StrLibrary.reject.toText..style = Styles.ts_333333_17sp,
            ),
          ),
        ),
      );
}
