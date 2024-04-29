import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'point_rules_logic.dart';

class PointRulesPage extends StatelessWidget {
  final logic = Get.find<PointRulesLogic>();

  PointRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrLibrary.newFriend),
      backgroundColor: StylesLibrary.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            10.verticalSpace,
            Row(
              children: [
                15.horizontalSpace,
                StrLibrary.whatAreMitiToken.toText
                  ..style = StylesLibrary.ts_333333_16sp_medium
              ],
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: StrLibrary.welcomeMessage.toText
                ..style = StylesLibrary.ts_666666_14sp,
            ),
            20.verticalSpace,
            Row(
              children: [
                ImageLibrary.appSemicircle.toImage..width = 5.w,
                10.horizontalSpace,
                StrLibrary.earningTitle2.toText
                  ..style = StylesLibrary.ts_333333_16sp_medium
              ],
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "- ", style: StylesLibrary.ts_8443F8_14sp_medium),
                    TextSpan(
                        text: StrLibrary.dailyPlatform,
                        style: StylesLibrary.ts_666666_14sp),
                    TextSpan(
                        text: StrLibrary.signInBracket,
                        style: StylesLibrary.ts_8443F8_14sp),
                  ])),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "- ", style: StylesLibrary.ts_8443F8_14sp_medium),
                    TextSpan(
                        text: StrLibrary.engageAI,
                        style: StylesLibrary.ts_666666_14sp),
                    TextSpan(
                        text: StrLibrary.effectiveInteraction,
                        style: StylesLibrary.ts_8443F8_14sp),
                  ])),
                  RichText(
                      text: TextSpan(children: [
                    TextSpan(
                        text: "- ", style: StylesLibrary.ts_8443F8_14sp_medium),
                    TextSpan(
                        text: StrLibrary.successful,
                        style: StylesLibrary.ts_666666_14sp),
                    TextSpan(
                        text: StrLibrary.inviteBracket,
                        style: StylesLibrary.ts_8443F8_14sp),
                    TextSpan(
                        text: StrLibrary.newUsers,
                        style: StylesLibrary.ts_666666_14sp),
                  ]))
                ],
              ),
            ),
            20.verticalSpace,
            Row(
              children: [
                ImageLibrary.appSemicircle.toImage..width = 5.w,
                10.horizontalSpace,
                StrLibrary.consumingMitiToken.toText
                  ..style = StylesLibrary.ts_333333_16sp_medium
              ],
            ),
            Row(
              children: [
                ImageLibrary.appSemicircle.toImage..width = 5.w,
                10.horizontalSpace,
                StrLibrary.earningTable.toText
                  ..style = StylesLibrary.ts_333333_16sp_medium
              ],
            ),
          ],
        ),
      ),
    );
  }
}
