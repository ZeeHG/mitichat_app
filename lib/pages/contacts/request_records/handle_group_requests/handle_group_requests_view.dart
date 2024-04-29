import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'handle_group_requests_logic.dart';

class HandleGroupRequestsPage extends StatelessWidget {
  final logic = Get.find<HandleGroupRequestsLogic>();

  HandleGroupRequestsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.newGroup),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: Container(
        color: StylesLibrary.c_FFFFFF,
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
                  width: 42.w,
                  height: 42.h,
                  url: logic.applicationInfo.userFaceURL,
                  text: logic.applicationInfo.nickname,
                ),
                10.horizontalSpace,
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    (logic.applicationInfo.nickname ?? '').toText
                      ..style = StylesLibrary.ts_333333_16sp,
                    // if (!logic.isInvite)
                    RichText(
                      text: TextSpan(
                        text: StrLibrary.applyJoin,
                        style: StylesLibrary.ts_999999_14sp,
                        children: [
                          WidgetSpan(child: 2.horizontalSpace),
                          TextSpan(
                            text: logic.groupName,
                            style: StylesLibrary.ts_8443F8_14sp,
                          ),
                        ],
                      ),
                    )
                  ],
                ),
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
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                sprintf(StrLibrary.sourceFrom, [logic.sourceFrom]).toText
                  ..style = StylesLibrary.ts_999999_14sp
              ],
            ),
            12.verticalSpace,
            Row(
              children: [
                Flexible(
                    child: Button(
                        text: StrLibrary.reject,
                        textStyle: StylesLibrary.ts_333333_16sp,
                        onTap: logic.reject,
                        enabledColor: StylesLibrary.c_FFFFFF,
                        borderColor: StylesLibrary.c_CCCCCC)),
                12.horizontalSpace,
                Flexible(
                  child: Button(
                    onTap: logic.approve,
                    text: StrLibrary.accept,
                    textStyle: StylesLibrary.ts_FFFFFF_16sp,
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
