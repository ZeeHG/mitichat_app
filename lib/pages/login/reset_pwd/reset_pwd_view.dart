import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../widgets/gradient__scroll_view.dart';
import 'reset_pwd_logic.dart';

class ResetPwdPage extends StatelessWidget {
  final logic = Get.find<ResetPwdLogic>();

  ResetPwdPage({super.key});

  @override
  Widget build(BuildContext context) => GradientScrollView(
        child: Obx(() => Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                StrLibrary.forgetPassword.toText
                  ..style = StylesLibrary.ts_8443F8_22sp_semibold,
                29.verticalSpace,
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
