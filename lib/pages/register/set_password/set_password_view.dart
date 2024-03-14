import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../widgets/register_page_bg.dart';
import 'set_password_logic.dart';

class SetPasswordPage extends StatelessWidget {
  final logic = Get.find<SetPasswordLogic>();

  SetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => RegisterBgView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            StrLibrary.setInfo.toText..style = Styles.ts_8443F8_22sp_semibold,
            29.verticalSpace,
            InputBox(
              label: StrLibrary.nickname,
              hintText: StrLibrary.plsEnterYourNickname,
              controller: logic.nicknameCtrl,
            ),
            17.verticalSpace,
            InputBox.password(
              label: StrLibrary.password,
              hintText: StrLibrary.plsEnterPassword,
              controller: logic.pwdCtrl,
              formatHintText: StrLibrary.loginPwdFormat,
              inputFormatters: [IMUtils.getPasswordFormatter()],
            ),
            17.verticalSpace,
            InputBox.password(
              label: StrLibrary.confirmPassword,
              hintText: StrLibrary.plsConfirmPasswordAgain,
              controller: logic.pwdAgainCtrl,
              inputFormatters: [IMUtils.getPasswordFormatter()],
            ),
            129.verticalSpace,
            Obx(() => Button(
                  text: StrLibrary.registerNow,
                  enabled: logic.enabled.value,
                  onTap: logic.nextStep,
                )),
          ],
        ),
      );
}
