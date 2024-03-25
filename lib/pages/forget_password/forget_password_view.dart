import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/login/login_logic.dart';
import 'package:miti/widgets/gradient__scroll_view.dart';
import 'package:miti_common/miti_common.dart';

import 'forget_password_logic.dart';

class ForgetPasswordPage extends StatelessWidget {
  final logic = Get.find<ForgetPasswordLogic>();

  ForgetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => GradientScrollView(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StrLibrary.forgetPassword.toText
                  ..style = Styles.ts_8443F8_22sp_semibold,
                29.verticalSpace,
                InputBox.account(
                  hintText: logic.loginController.operateType.hintText,
                  code: logic.areaCode.value,
                  onAreaCode:
                      logic.loginController.operateType == LoginType.phone
                          ? logic.openCountryCodePicker
                          : null,
                  controller: logic.phoneCtrl,
                ),
                16.verticalSpace,
                InputBox.verificationCode(
                  hintText: StrLibrary.plsEnterVerificationCode,
                  controller: logic.verificationCodeCtrl,
                  onSendVerificationCode: logic.getVerificationCode,
                ),
                130.verticalSpace,
                Button(
                  text: StrLibrary.nextStep,
                  enabled: logic.enabled.value,
                  onTap: logic.nextStep,
                ),
              ],
            )),
      );
}
