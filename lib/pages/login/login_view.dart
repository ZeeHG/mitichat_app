import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: TouchCloseSoftKeyboard(
        isGradientBg: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              138.verticalSpace,
              ImageRes.logo2.toImage
                ..width = 89.w
                ..height = 81.h,
              // ..onDoubleTap = logic.configService,
              70.verticalSpace,
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 36.w),
                child: Obx(() => Column(
                      children: [
                        InputBox.account(
                          label: logic.loginType.value.name,
                          hintText: logic.loginType.value.hintText,
                          code: logic.areaCode.value,
                          onAreaCode: logic.loginType.value == LoginType.phone
                              ? logic.openCountryCodePicker
                              : null,
                          controller: logic.phoneCtrl,
                          keyBoardType: logic.loginType.value == LoginType.phone
                              ? TextInputType.phone
                              : TextInputType.text,
                        ),
                        29.verticalSpace,
                        Offstage(
                          offstage: !logic.isPasswordLogin.value,
                          child: InputBox.password(
                            label: StrRes.password,
                            hintText: StrRes.plsEnterPassword,
                            controller: logic.pwdCtrl,
                          ),
                        ),
                        Offstage(
                          offstage: logic.isPasswordLogin.value,
                          child: InputBox.verificationCode(
                            label: StrRes.verificationCode,
                            hintText: StrRes.plsEnterVerificationCode,
                            controller: logic.verificationCodeCtrl,
                            onSendVerificationCode: logic.getVerificationCode,
                          ),
                        ),
                        10.verticalSpace,
                        Row(
                          children: [
                            StrRes.forgetPassword.toText
                              ..style = Styles.ts_999999_12sp
                              ..onTap = _showForgetPasswordBottomSheet,
                            const Spacer(),
                            (logic.isPasswordLogin.value
                                    ? StrRes.verificationCodeLogin
                                    : StrRes.passwordLogin)
                                .toText
                              ..style = Styles.ts_8443F8_12sp
                              ..onTap = logic.togglePasswordType,
                          ],
                        ),
                        46.verticalSpace,
                        Button(
                          text: StrRes.login,
                          enabled: logic.enabled.value,
                          onTap: logic.login,
                        ),
                      ],
                    )),
              ),
              // Divider(
              //   color: Styles.c_707070.withOpacity(0.12),
              //   height: 56,
              // ),
              20.verticalSpace,
              Obx(() => Padding(
                  padding: EdgeInsets.symmetric(horizontal: 36.w),
                  child: Row(
                    children: [
                      Expanded(
                        child: CupertinoButton(
                          onPressed: logic.toggleLoginType,
                          color: CupertinoColors.systemGrey6,
                          minSize: 42.h,
                          child: Text(
                            '${logic.loginType.value.exclusiveName} ${StrRes.login}',
                            style: Styles.ts_8443F8_17sp,
                          ),
                        ),
                      )
                    ],
                  ))),
              32.verticalSpace,
              RichText(
                text: TextSpan(
                  // text: StrRes.noAccountYet,
                  // style: Styles.ts_999999_12sp,
                  children: [
                    TextSpan(
                      text: StrRes.registerNow,
                      style: Styles.ts_8443F8_12sp,
                      recognizer: TapGestureRecognizer()
                        ..onTap = logic.registerNow,
                    )
                  ],
                ),
              ),
              130.verticalSpace,
              Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Checkbox(
                      // activeColor: Styles.c_8443F8,
                      fillColor: MaterialStateProperty.resolveWith(
                          (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected))
                          return Styles.c_8443F8;
                        return null;
                      }),
                      value: logic.agree.value,
                      onChanged: logic.changeAgree,
                    ),
                    Container(
                      constraints:BoxConstraints(maxWidth: 270.w),
                      child: RichText(
                        text: TextSpan(children: [
                      TextSpan(
                          text: StrRes.privacyPolicyDescriptionP1,
                          style: Styles.ts_656565_12sp),
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () => AppNavigator.startTermsOfServer(),
                          text: StrRes.privacyPolicyDescriptionP2,
                          style: Styles.ts_333333_12sp),
                      TextSpan(
                          text: StrRes.privacyPolicyDescriptionP3,
                          style: Styles.ts_656565_12sp),
                      TextSpan(
                          recognizer: TapGestureRecognizer()..onTap = () => AppNavigator.startPrivacyPolicy(),
                          text: StrRes.privacyPolicyDescriptionP4,
                          style: Styles.ts_333333_12sp),
                    ])),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  void _showRegisterBottomSheet() {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.email;
                logic.registerNow();
              },
              child: Text('${StrRes.email} ${StrRes.registerNow}'),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.phone;
                logic.registerNow();
              },
              child: Text('${StrRes.phoneNumber} ${StrRes.registerNow}'),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(StrRes.cancel),
          ),
        );
      },
    );
  }

  void _showForgetPasswordBottomSheet() {
    showCupertinoModalPopup(
      context: Get.context!,
      builder: (BuildContext context) {
        return CupertinoActionSheet(
          actions: [
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.email;
                logic.forgetPassword();
              },
              child: Text(sprintf(StrRes.through, [StrRes.email])),
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.phone;
                logic.forgetPassword();
              },
              child: Text(sprintf(StrRes.through, [StrRes.phoneNumber])),
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text(StrRes.cancel),
          ),
        );
      },
    );
  }
}
