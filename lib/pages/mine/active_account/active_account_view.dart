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
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.w),
                          child: StrLibrary.plsEnterInvitationCode2.toText..style=StylesLibrary.ts_333333_16sp,
                        ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 12.w),
                          decoration: BoxDecoration(
                            color: StylesLibrary.c_E8EAEF,
                            borderRadius: BorderRadius.circular(4.r),
                          ),
                          child: TextField(
                            controller: logic.inputCtrl,
                            style: StylesLibrary.ts_333333_16sp,
                            
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(20)
                            ],
                            decoration: InputDecoration(
                              border: InputBorder.none,
                              isDense: true,
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 10.h,
                                horizontal: 12.w,
                              ),
                            ),
                          ),
                        ),
                        30.verticalSpace,
                        Button(
                          width: 1.sw - 80.w,
                          text: StrLibrary.submit,
                          onTap: logic.confirm,
                        )
                      ]
                    : logic.status.value == "submitSuccess"
                        ? [
                            ImageLibrary.appSuccess.toImage
                              ..width = 60.w
                              ..height = 60.h,
                            30.verticalSpace,
                            StrLibrary.submitSuccess.toText
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
                                  45.verticalSpace,
                                    ImageLibrary.appSuccess.toImage
                                      ..width = 70.w
                                      ..height = 70.h,
                                    StrLibrary.activeAccountTips2.toText
                                      ..style = StylesLibrary.ts_333333_14sp
                                      ..textAlign = TextAlign.center,
                                    30.verticalSpace,
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
