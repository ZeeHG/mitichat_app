import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
      child: KeyboardDismissOnTap(
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  90.verticalSpace,
                  ImageRes.logo2.toImage
                    ..width = 89.w
                    ..height = 81.h,
                  // ..onDoubleTap = logic.configService,
                  45.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    child: Obx(() => Column(
                          children: [
                            InputBox.account(
                              autofocus: false,
                              hintText: logic.loginType.value.hintText,
                              code: logic.areaCode.value,
                              onAreaCode:
                                  logic.loginType.value == LoginType.phone
                                      ? logic.openCountryCodePicker
                                      : null,
                              controller: logic.phoneEmailCtrl,
                              keyBoardType:
                                  logic.loginType.value == LoginType.phone
                                      ? TextInputType.phone
                                      : TextInputType.text,
                            ),
                            16.verticalSpace,
                            Offstage(
                              offstage: !logic.isPasswordLogin.value,
                              child: InputBox.password(
                                autofocus: false,
                                hintText: StrLibrary.plsEnterPassword,
                                controller: logic.pwdCtrl,
                              ),
                            ),
                            Offstage(
                              offstage: logic.isPasswordLogin.value,
                              child: InputBox.verificationCode(
                                autofocus: false,
                                hintText: StrLibrary.plsEnterVerificationCode,
                                controller: logic.verificationCodeCtrl,
                                onSendVerificationCode:
                                    logic.getVerificationCode,
                              ),
                            ),
                            16.verticalSpace,
                            InputBox(
                              readOnly: true,
                              controller: logic.onlyReadServerCtrl,
                              showClearBtn: false,
                            ),
                            // 10.verticalSpace,
                            // Row(
                            //   children: [
                            //     StrLibrary .forgetPassword.toText
                            //       ..style = Styles.ts_8443F8_12sp
                            //       ..onTap = _showForgetPwdBottomSheet,
                            //     const Spacer(),
                            //     // (logic.isPasswordLogin.value
                            //     //         ? StrLibrary .verificationCodeLogin
                            //     //         : StrLibrary .passwordLogin)
                            //     //     .toText
                            //     //   ..style = Styles.ts_8443F8_12sp
                            //     //   ..onTap = logic.togglePasswordType,
                            //   ],
                            // ),
                            10.verticalSpace,
                            Row(
                              children: [
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: StrLibrary.switchServer,
                                              style: Styles.ts_8443F8_14sp,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap = logic.switchServer,
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                                10.horizontalSpace,
                                Expanded(
                                    flex: 1,
                                    child: Container(
                                      alignment: Alignment.topRight,
                                      child: RichText(
                                        text: TextSpan(
                                          children: [
                                            TextSpan(
                                              text: StrLibrary.forgetPassword,
                                              style: Styles.ts_8443F8_14sp,
                                              recognizer: TapGestureRecognizer()
                                                ..onTap =
                                                    _showForgetPwdBottomSheet,
                                            )
                                          ],
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                            30.verticalSpace,
                            Button(
                              text: StrLibrary.login,
                              enabled: logic.enabled.value,
                              onTap: () => logic.login(context),
                            ),
                          ],
                        )),
                  ),
                  // Divider(
                  //   color: Styles.c_707070.withOpacity(0.12),
                  //   height: 56,
                  // ),
                  10.verticalSpace,
                  Obx(() => Padding(
                      padding: EdgeInsets.symmetric(horizontal: 36.w),
                      child: Row(
                        children: [
                          Expanded(
                            child: Button(
                              text:
                                  '${logic.loginType.value.exclusiveName} ${StrLibrary.login}',
                              enabledColor: Styles.c_D9DCE3_opacity40,
                              textStyle: Styles.ts_8443F8_16sp,
                              onTap: logic.toggleLoginType,
                            ),
                          )
                        ],
                      ))),
                  20.verticalSpace,
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 36.w),
                    child: Row(
                      children: [
                        Expanded(
                            flex: 1,
                            child: Container(
                              alignment: Alignment.topCenter,
                              child: RichText(
                                text: TextSpan(
                                  children: [
                                    TextSpan(
                                        text: StrLibrary.noAccount,
                                        style: Styles.ts_333333_14sp),
                                    TextSpan(
                                      text: StrLibrary.registerNow,
                                      style: Styles.ts_8443F8_14sp,
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = logic.registerNow,
                                    )
                                  ],
                                ),
                              ),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            ),
            Positioned(
              bottom: 15.h,
              left: 36.w,
              child: Obx(
                () => Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Transform.translate(
                      offset: Offset(0, -7.h),
                      child: Transform.scale(
                          scale: 0.75,
                          child: Checkbox(
                            visualDensity: VisualDensity.compact,
                            // activeColor: Styles.c_8443F8,
                            fillColor: MaterialStateProperty.resolveWith(
                                (Set<MaterialState> states) => states.contains(MaterialState.selected)? Styles.c_8443F8: null),
                            value: logic.agree.value,
                            onChanged: logic.changeAgree,
                          )),
                    ),
                    Container(
                      constraints: BoxConstraints(maxWidth: 270.w),
                      child: RichText(
                          text: TextSpan(children: [
                        TextSpan(
                            text: StrLibrary.privacyPolicyDescriptionP1,
                            style: Styles.ts_656565_12sp),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => AppNavigator.startTermsOfServer(),
                            text: StrLibrary.privacyPolicyDescriptionP2,
                            style: Styles.ts_333333_12sp),
                        TextSpan(
                            text: StrLibrary.privacyPolicyDescriptionP3,
                            style: Styles.ts_656565_12sp),
                        TextSpan(
                            recognizer: TapGestureRecognizer()
                              ..onTap = () => AppNavigator.startPrivacyPolicy(),
                            text: StrLibrary.privacyPolicyDescriptionP4,
                            style: Styles.ts_333333_12sp),
                        TextSpan(
                            text: StrLibrary.privacyPolicyDescriptionP5,
                            style: Styles.ts_656565_12sp),
                      ])),
                    )
                  ],
                ),
              ),
            ),
            if (logic.isAddAccount.value)
              Padding(
                padding: EdgeInsets.only(left: 12.w, top: 54.h),
                child: ImageRes.backBlack.toImage
                  ..width = 24.w
                  ..height = 24.h
                  ..onTap = () => logic.cusBack(),
              ),
          ],
        ),
      ),
    );
  }

  void _showForgetPwdBottomSheet() {
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
              child: sprintf(StrLibrary.through, [StrLibrary.email]).toText,
            ),
            CupertinoActionSheetAction(
              onPressed: () {
                Navigator.pop(context);
                logic.operateType = LoginType.phone;
                logic.forgetPassword();
              },
              child:
                  sprintf(StrLibrary.through, [StrLibrary.phoneNumber]).toText,
            ),
          ],
          cancelButton: CupertinoActionSheetAction(
            onPressed: () {
              Navigator.pop(context);
            },
            child: StrLibrary.cancel.toText,
          ),
        );
      },
    );
  }
}
