import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/login/login_logic.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../widgets/register_page_bg.dart';
import 'register_logic.dart';

class RegisterPage extends StatelessWidget {
  final logic = Get.find<RegisterLogic>();

  RegisterPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
          child: Obx(
        () => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            (logic.phoneRegister
                    ? StrLibrary.phoneRegister
                    : StrLibrary.emailRegister)
                .toText
              ..style = Styles.ts_333333_24sp_medium,
            21.verticalSpace,
            InputBox.invitationCode(
              label: StrLibrary.invitationCode,
              hintText: sprintf(StrLibrary.plsEnterInvitationCode, [
                logic.needInvitationCodeRegister
                    ? '(${StrLibrary.required})'
                    : '(${StrLibrary.optional})'
              ]),
              controller: logic.invitationCodeCtrl,
            ),
            16.verticalSpace,
            InputBox(
              label: StrLibrary.nickname,
              hintText: StrLibrary.plsEnterYourNickname,
              controller: logic.nicknameCtrl,
            ),
            16.verticalSpace,
            InputBox.password(
              label: StrLibrary.password,
              hintText: StrLibrary.plsEnterPassword,
              controller: logic.pwdCtrl,
              formatHintText: StrLibrary.loginPwdFormat,
              inputFormatters: [IMUtils.getPasswordFormatter()],
            ),
            16.verticalSpace,
            InputBox.password(
              label: StrLibrary.confirmPassword,
              hintText: StrLibrary.plsConfirmPasswordAgain,
              controller: logic.pwdAgainCtrl,
              inputFormatters: [IMUtils.getPasswordFormatter()],
            ),
            16.verticalSpace,
            InputBox.account(
              label: logic.operateType.value.name,
              hintText: logic.operateType.value.hintText,
              code: logic.areaCode.value,
              onAreaCode:
                  logic.phoneRegister ? logic.openCountryCodePicker : null,
              controller:
                  logic.phoneRegister ? logic.phoneCtrl : logic.emailCtrl,
            ),
            16.verticalSpace,
            InputBox.verificationCode(
              label: StrLibrary.verificationCode,
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
              text: logic.phoneRegister
                  ? StrLibrary.useEmailRegister
                  : StrLibrary.usePhoneRegister,
              enabledColor: Styles.c_D9DCE3_opacity40,
              textStyle: Styles.ts_8443F8_16sp,
              onTap: logic.switchType,
            )
          ],
        ),
      ));
}
