import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/login/login_logic.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../widgets/gradient__scroll_view.dart';
import 'register_logic.dart';

class RegisterPage extends StatelessWidget {
  final logic = Get.find<RegisterLogic>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => GradientScrollView(
          scrollCtrl: logic.scrollCtrl,
          child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (logic.isPhoneRegister
                    ? StrLibrary.phoneRegister
                    : StrLibrary.emailRegister)
                .toText
              ..style = StylesLibrary.ts_333333_24sp_medium,
            21.verticalSpace,
            InputBox.invitationCode(
              showScanIcon: true,
              scan: logic.scan,
              hintText: sprintf(StrLibrary.plsEnterInvitationCode, [
                logic.needInvitationCode
                    ? '(${StrLibrary.required})'
                    : '(${StrLibrary.optional})'
              ]),
              controller: logic.invitationCodeCtrl,
            ),
            16.verticalSpace,
            InputBox(
              hintText: StrLibrary.plsEnterYourNickname,
              controller: logic.nicknameCtrl,
            ),
            16.verticalSpace,
            InputBox.password(
              hintText: StrLibrary.plsEnterPassword,
              controller: logic.pwdCtrl,
              formatHintText: StrLibrary.loginPwdFormat,
              inputFormatters: [MitiUtils.getPasswordFormatter()],
            ),
            16.verticalSpace,
            InputBox.password(
              hintText: StrLibrary.plsConfirmPasswordAgain,
              controller: logic.pwdAgainCtrl,
              inputFormatters: [MitiUtils.getPasswordFormatter()],
            ),
            16.verticalSpace,
            InputBox.account(
              hintText: logic.operateType.value.hintText,
              code: logic.areaCode.value,
              onAreaCode:
                  logic.isPhoneRegister ? logic.openCountryPicker : null,
              controller:
                  logic.isPhoneRegister ? logic.phoneCtrl : logic.emailCtrl,
            ),
            16.verticalSpace,
            InputBox.verificationCode(
              hintText: StrLibrary.plsEnterVerificationCode,
              controller: logic.verificationCodeCtrl,
              onSendVerificationCode: logic.getVerificationCode,
            ),
            40.verticalSpace,
            Button(
              text: StrLibrary.register,
              enabled: logic.enabled.value,
              onTap: logic.register,
            ),
            10.verticalSpace,
            Button(
              text: logic.isPhoneRegister
                  ? StrLibrary.useEmailRegister
                  : StrLibrary.usePhoneRegister,
              enabledColor: StylesLibrary.c_D9DCE3_opacity40,
              textStyle: StylesLibrary.ts_8443F8_16sp,
              onTap: logic.switchType,
            ),
            10.verticalSpace,
          ],
        ),
      ));
}
