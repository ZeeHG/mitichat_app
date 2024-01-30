import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'point_rules_logic.dart';

class PointRulesPage extends StatelessWidget {
  final logic = Get.find<PointRulesLogic>();

  PointRulesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: StrRes.newFriend),
      backgroundColor: Styles.c_F8F9FA,
      body: SingleChildScrollView(
        child: Column(
          children: [
            10.verticalSpace,
            Row(
              children: [
                15.horizontalSpace,
                StrRes.whatAreMitiToken.toText
                  ..style = Styles.ts_333333_16sp_medium
              ],
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: StrRes.welcomeMessage.toText
                ..style = Styles.ts_666666_14sp,
            ),
            20.verticalSpace,
            Row(
              children: [
                ImageRes.appSemicircle.toImage..width = 5.w,
                10.horizontalSpace,
                StrRes.earningTitle2.toText
                  ..style = Styles.ts_333333_16sp_medium
              ],
            ),
            10.verticalSpace,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.w),
              child: ,
            ),
            Column(
              children: [
                RichText(
                    text: TextSpan(children: [
                  TextSpan(text: "- ", style: Styles.ts_8443F8_14sp_medium),
                  TextSpan(
                      text: StrRes.dailyPlatform, style: Styles.ts_666666_14sp),
                  TextSpan(
                      text: StrRes.signInBracket, style: Styles.ts_8443F8_14sp),
                ]))
              ],
            ),
            Row(
              children: [
                ImageRes.appSemicircle.toImage..width = 5.w,
                10.horizontalSpace,
                StrRes.consumingMitiToken.toText
                  ..style = Styles.ts_333333_16sp_medium
              ],
            ),
            Row(
              children: [
                ImageRes.appSemicircle.toImage..width = 5.w,
                10.horizontalSpace,
                StrRes.earningTable.toText..style = Styles.ts_333333_16sp_medium
              ],
            ),
          ],
        ),
      ),
    );
  }
}
