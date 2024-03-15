import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pin_code_fields/pin_code_fields.dart';
import 'package:sprintf/sprintf.dart';

import '../../../widgets/gradient__scroll_view.dart';
import 'verify_phone_logic.dart';

class VerifyPhonePage extends StatelessWidget {
  final logic = Get.find<VerifyPhoneLogic>();

  VerifyPhonePage({super.key});

  @override
  Widget build(BuildContext context) => GradientScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            sprintf(StrLibrary.enterVerificationCode, [
              logic.email?.isNotEmpty == true
                  ? StrLibrary.email
                  : StrLibrary.phoneNumber
            ]).toText
              ..style = Styles.ts_8443F8_22sp_semibold,
            10.verticalSpace,
            '${logic.account}'.toText..style = Styles.ts_999999_12sp,
            35.verticalSpace,
            PinCodeTextField(
              appContext: context,
              controller: logic.codeEditCtrl,
              autoFocus: true,
              textStyle: Styles.ts_333333_20sp_semibold,
              length: 6,
              obscureText: false,
              blinkWhenObscuring: true,
              animationType: AnimationType.fade,
              validator: (v) {
                return null;
                // if (v!.length < 3) {
                //   return "I'm from validator";
                // } else {
                //   return null;
                // }
              },
              pinTheme: PinTheme(
                shape: PinCodeFieldShape.box,
                activeColor: Styles.c_8443F8,
                selectedColor: Styles.c_8443F8,
                inactiveColor: Styles.c_E8EAEF,
                disabledColor: Styles.c_E8EAEF,
                activeFillColor: Styles.c_E8EAEF,
                selectedFillColor: Styles.c_E8EAEF,
                inactiveFillColor: Styles.c_E8EAEF,
                borderRadius: BorderRadius.circular(8.r),
                borderWidth: 1,
                fieldHeight: 42.w,
                fieldWidth: 42.h,
                // activeFillColor: Colors.white,
              ),
              cursorColor: Colors.black,
              animationDuration: 300.milliseconds,
              // enableActiveFill: true,
              errorAnimationController: logic.codeErrorCtrl,
              // controller: logic.codeEditCtrl,
              keyboardType: TextInputType.number,
              onCompleted: (v) {
                logic.completed(v);
              },
              onSubmitted: (v) {
                logic.completed(v);
              },
              // onTap: () {
              //   print("Pressed");
              // },
              onChanged: (v) {
                // logic.onCompleted(v);
              },
              beforeTextPaste: (text) {
                //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                //but you can show anything you want here, like your pop up saying wrong paste format or etc
                return true;
              },
            ),
            VerifyCodeSendButton(
              sec: 300,
              onTapCallback: () => logic.requestVerificationCode(),
            ),
            170.verticalSpace,
            Obx(() => Button(
                  text: StrLibrary.nextStep,
                  enabled: logic.enabled.value,
                  onTap: () => logic.completed(logic.codeEditCtrl.text),
                )),
          ],
        ),
      );
}
