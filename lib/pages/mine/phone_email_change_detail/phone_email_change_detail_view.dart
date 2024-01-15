import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/core/controller/im_controller.dart';
import 'package:miti/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'phone_email_change_detail_logic.dart';

class PhoneEmailChangeDetailPage extends StatelessWidget {
  final logic = Get.find<PhoneEmailChangeDetailLogic>();
  final imLogic = Get.find<IMController>();

  PhoneEmailChangeDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(hideBack: logic.success.value),
          backgroundColor: Styles.c_FFFFFF,
          body: Container(
            width: 1.sw,
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!logic.success.value) ...[
                  43.verticalSpace,
                  (logic.isPhone && (imLogic.userInfo.value.phoneNumber?.isNotEmpty ?? false)? StrRes.changePhone : 
                  logic.isPhone && (imLogic.userInfo.value.phoneNumber?.isEmpty ?? true)? StrRes.bindPhone : 
                  !logic.isPhone && (imLogic.userInfo.value.email?.isNotEmpty ?? false)? StrRes.changeEmail : 
                  StrRes.bindEmail)
                      .toText
                    ..style = Styles.ts_333333_20sp_medium,
                  26.verticalSpace,
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                        border: Border(
                            bottom:
                                BorderSide(width: 1.h, color: Styles.c_F1F2F6),
                            top: BorderSide(
                                width: 1.h, color: Styles.c_F1F2F6))),
                    child: Row(
                      children: [
                        Container(
                          width: 100.w,
                          child: (logic.isPhone? StrRes.phoneNumber : StrRes.email).toText
                            ..style = Styles.ts_333333_16sp
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis,
                        ),
                        10.horizontalSpace,
                        Expanded(
                            child: InputBox.account(
                                label: logic.type.value.name,
                                hintText: logic.type.value.hintText,
                                code: logic.areaCode.value,
                                onAreaCode: logic.isPhone
                                    ? logic.openCountryCodePicker
                                    : null,
                                controller: logic.isPhone
                                    ? logic.phoneCtrl
                                    : logic.emailCtrl,
                                border: false))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 1.h, color: Styles.c_F1F2F6),
                    )),
                    child: Row(
                      children: [
                        Container(
                          width: 100.w,
                          child: StrRes.verificationCode.toText
                            ..style = Styles.ts_333333_16sp
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis,
                        ),
                        10.horizontalSpace,
                        Expanded(
                            child: InputBox.verificationCode(
                                label: StrRes.verificationCode,
                                hintText: StrRes.verificationCode,
                                controller: logic.verificationCodeCtrl,
                                onSendVerificationCode:
                                    logic.getVerificationCode,
                                border: false))
                      ],
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 10.h),
                    decoration: BoxDecoration(
                        border: Border(
                      bottom: BorderSide(width: 1.h, color: Styles.c_F1F2F6),
                    )),
                    child: Row(
                      children: [
                        Container(
                          width: 100.w,
                          child: StrRes.password.toText
                            ..style = Styles.ts_333333_16sp
                            ..maxLines = 1
                            ..overflow = TextOverflow.ellipsis,
                        ),
                        10.horizontalSpace,
                        Expanded(
                            child: InputBox.password(
                                label: StrRes.password,
                                hintText: StrRes.curPwd,
                                controller: logic.pwdCtrl,
                                inputFormatters: [
                                  IMUtils.getPasswordFormatter()
                                ],
                                border: false))
                      ],
                    ),
                  ),
                  49.verticalSpace,
                  Button(
                    width: 1.sw - 86.w,
                    text: StrRes.confirm,
                    onTap: logic.updateInfo,
                  )
                ],
                if (logic.success.value) ...[
                  45.verticalSpace,
                  ImageRes.appSuccess.toImage
                    ..width = 60.w
                    ..height = 60.h,
                  25.verticalSpace,
                  StrRes.success.toText
                    ..style = Styles.ts_333333_20sp_medium,
                  10.verticalSpace,
                  StrRes.changeSuccessTips.toText
                    ..style = Styles.ts_999999_16sp,
                  45.verticalSpace,
                  Button(
                    width: 1.sw - 86.w,
                    text: StrRes.backLogin,
                    onTap: logic.goLogin,
                  )
                ]
              ],
            ),
          ),
        ));
  }
}
