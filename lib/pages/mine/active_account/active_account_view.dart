import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

import 'active_account_logic.dart';

class ActiveAccountPage extends StatelessWidget {
  final logic = Get.find<ActiveAccountLogic>();

  ActiveAccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(title: ""),
      backgroundColor: StylesLibrary.c_FFFFFF,
      body: SingleChildScrollView(
        child: Obx(() => Container(
              width: 1.sw,
              padding: EdgeInsets.symmetric(vertical: 12.h),
              child: Column(
                children: logic.status.value == "input"
                    ? [
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          padding: EdgeInsets.symmetric(horizontal: 16.w),
                          decoration: BoxDecoration(
                            color: StylesLibrary.c_F7F8FA,
                            borderRadius: BorderRadius.circular(46.r),
                          ),
                          child: Row(children: [
                            Expanded(child: InputBox(
                                hintText: StrLibrary.enterInviterId,
                                controller: logic.inputCtrl,
                                border: false),),
                                10.horizontalSpace,
                            ImageLibrary.appPopMenuScan.toImage..width=16.w..height=16.h..onTap=logic.scan
                          ]),
                        ),
                        20.verticalSpace,
                        Button(
                          width: 1.sw - 80.w,
                          text: StrLibrary.submit,
                          onTap: logic.confirm,
                          enabled: logic.isValid.value,
                        )
                      ]
                    : logic.status.value == "submitSuccess"
                        ? [
                            180.verticalSpace,
                            ImageLibrary.appSuccess.toImage
                              ..width = 60.w
                              ..height = 60.h,
                            25.verticalSpace,
                            StrLibrary.submitSuccess.toText
                              ..style = StylesLibrary.ts_333333_20sp_medium,
                            7.verticalSpace,
                            StrLibrary.submitMitiIDSuccess.toText
                              ..style = StylesLibrary.ts_999999_16sp
                              ..textAlign = TextAlign.center,
                          ]
                        : logic.status.value == "waitingAgree"
                            ? [
                                100.verticalSpace,
                                ImageLibrary.mitiidBg.toImage
                                  ..width = 224.w
                                  ..height = 224.h,
                                15.verticalSpace,
                                Button(
                                  width: 1.sw - 80.w,
                                  text: StrLibrary.changeInviter,
                                  onTap: () {
                                    logic.status.value = "input";
                                  },
                                )
                              ]
                            : logic.status.value == "activeSuccess"
                                ? [
                                    180.verticalSpace,
                                    ImageLibrary.appSuccess.toImage
                                      ..width = 60.w
                                      ..height = 60.h,
                                    25.verticalSpace,
                                    StrLibrary.activeAccountTips2.toText
                                      ..style = StylesLibrary.ts_999999_16sp
                                      ..textAlign = TextAlign.center,
                                    25.verticalSpace,
                                    Button(
                                      width: 1.sw - 80.w,
                                      text: StrLibrary.goHome,
                                      onTap: () {
                                        AppNavigator.startMain();
                                      },
                                    )
                                  ]
                                : [],
              ),
            )),
      ),
    );
  }
}
