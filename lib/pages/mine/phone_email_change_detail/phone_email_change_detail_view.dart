import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/pages/mine/phone_email_change/phone_email_change_logic.dart';
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
                  (logic.isPhone ? StrRes.changePhone : StrRes.changeEmail)
                      .toText
                    ..style = Styles.ts_333333_20sp_medium,
                  10.verticalSpace,
                  sprintf(StrRes.changePhoneEmailTips, [
                    logic.isPhone ? StrRes.phoneNumber : StrRes.email
                  ]).toText
                    ..style = Styles.ts_999999_16sp,
                  26.verticalSpace,
                  InputBox.account(
                    label: logic.type.value.name,
                    hintText: logic.type.value.hintText,
                    code: logic.areaCode.value,
                    onAreaCode:
                        logic.isPhone ? logic.openCountryCodePicker : null,
                    controller:
                        logic.isPhone ? logic.phoneCtrl : logic.emailCtrl,
                  ),
                  InputBox.verificationCode(
                    label: StrRes.verificationCode,
                    hintText: StrRes.plsEnterVerificationCode,
                    controller: logic.verificationCodeCtrl,
                    onSendVerificationCode: logic.getVerificationCode,
                  ),
                  InputBox.password(
                    label: StrRes.password,
                    hintText: StrRes.plsEnterPassword,
                    controller: logic.pwdCtrl,
                    inputFormatters: [IMUtils.getPasswordFormatter()],
                  ),
                  49.verticalSpace,
                  Button(
                    width: 1.sw - 86.w,
                    text: StrRes.confirmChange,
                    onTap: logic.updateInfo,
                  )
                ],
                if (logic.success.value) ...[
                  45.verticalSpace,
                  ImageRes.appSuccess.toImage..width=60.w..height=60.h,
                  25.verticalSpace,
                  StrRes.changeSuccess.toText..style=Styles.ts_333333_20sp_medium,
                  10.verticalSpace,
                  sprintf(StrRes.changeSuccessTips, [
                    logic.isPhone ? StrRes.phoneNumber : StrRes.email
                  ]).toText..style=Styles.ts_999999_16sp,
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
