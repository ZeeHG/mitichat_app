import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../widgets/gradient__scroll_view.dart';
import 'reset_password_logic.dart';

class ResetPasswordPage extends StatelessWidget {
  final logic = Get.find<ResetPasswordLogic>();

  ResetPasswordPage({super.key});

  @override
  Widget build(BuildContext context) => GradientScrollView(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StrLibrary.forgetPassword.toText
                  ..style = Styles.ts_8443F8_22sp_semibold,
                29.verticalSpace,
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
                Button(
                  text: StrLibrary.confirmTheChanges,
                  enabled: logic.enabled.value,
                  onTap: logic.confirmTheChanges,
                ),
              ],
            )),
      );
}
