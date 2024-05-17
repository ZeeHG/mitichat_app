import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/app_ctrl.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import 'login_logic.dart';

class LoginPage extends StatelessWidget {
  final logic = Get.find<LoginLogic>();
  final accountUtil = Get.find<AccountUtil>();
  final appCtrl = Get.find<AppCtrl>();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Material(
          child: KeyboardDismissOnTap(
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      50.verticalSpace,
                      ImageLibrary.logo2.toImage
                        ..width = 89.w
                        ..height = 81.h,
                      // ..onDoubleTap = logic.configService,
                      20.verticalSpace,
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 36.w),
                        child: Obx(() => Column(
                              children: [
                                Stack(
                                  alignment: Alignment.centerRight,
                                  children: [
                                    InputBox.account(
                                        autofocus: false,
                                        hintText:
                                            logic.loginType.value.hintText,
                                        code: logic.areaCode.value,
                                        onAreaCode: logic.loginType.value ==
                                                LoginType.phone
                                            ? logic.openCountryCodePicker
                                            : null,
                                        controller: logic.phoneEmailCtrl,
                                        focusNode: logic.phoneEmailFocusNode,
                                        onFocusChanged: (isFocused) {
                                          if (isFocused) {
                                            // logic.filteredAccounts
                                            //     .assignAll(logic.historyAccounts);
                                            // print(
                                            //     "view中更新后的账户列表: ${logic.filteredAccounts.map((acc) => acc.username).toList()}");
                                            logic.showOverlay();
                                          } else {
                                            logic.hideOverlay();
                                          }
                                        },
                                        keyBoardType: logic.loginType.value ==
                                                LoginType.phone
                                            ? TextInputType.phone
                                            : TextInputType.text,
                                        onChanged: (text) =>
                                            logic.filterHistoryAccounts(text)),
                                  ],
                                ),
                                15.verticalSpace,
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
                                    hintText:
                                        StrLibrary.plsEnterVerificationCode,
                                    controller: logic.verificationCodeCtrl,
                                    onSendVerificationCode:
                                        logic.getVerificationCode,
                                  ),
                                ),
                                15.verticalSpace,
                                Row(
                                  children: [
                                    Expanded(
                                      flex: 3,
                                      child: InputBox(
                                        readOnly: true,
                                        controller: logic.onlyReadServerCtrl,
                                        showClearBtn: false,
                                      ),
                                    ),
                                    Expanded(
                                      flex: 2,
                                      child: GestureDetector(
                                        onTap: logic.switchServer,
                                        child: Text(
                                          StrLibrary.switchServer,
                                          style: StylesLibrary.ts_8443F8_14sp,
                                          textAlign: TextAlign.right,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                10.verticalSpace,
                                Row(
                                  children: [
                                    Row(
                                      children: [
                                        Transform.translate(
                                          offset: Offset(-11.w, 0),
                                          child: Transform.translate(
                                            offset: Offset(0, 0),
                                            child: Transform.scale(
                                              scale: 0.75,
                                              child: Checkbox(
                                                visualDensity:
                                                    VisualDensity.compact,
                                                fillColor: MaterialStateProperty
                                                    .resolveWith(
                                                  (Set<MaterialState> states) =>
                                                      states.contains(
                                                              MaterialState
                                                                  .selected)
                                                          ? StylesLibrary
                                                              .c_8443F8
                                                          : null,
                                                ),
                                                value: logic
                                                    .rememberPassword.value,
                                                onChanged: logic
                                                    .changeRememberPassword,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Transform.translate(
                                          offset: Offset(-7.w, 0),
                                          child: Container(
                                            constraints:
                                                BoxConstraints(maxWidth: 270.w),
                                            child: RichText(
                                              text: TextSpan(
                                                children: [
                                                  TextSpan(
                                                    text: StrLibrary
                                                        .rememberPassword,
                                                    style: StylesLibrary
                                                        .ts_8443F8_14sp,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    10.horizontalSpace,
                                    Expanded(
                                        flex: 1,
                                        child: Container(
                                          alignment: Alignment.topRight,
                                          child: RichText(
                                            text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text:
                                                      StrLibrary.forgetPassword,
                                                  style: StylesLibrary
                                                      .ts_8443F8_14sp,
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
                                15.verticalSpace,
                                Button(
                                  text: StrLibrary.login,
                                  enabled: logic.enabled.value,
                                  onTap: () => logic.login(context),
                                ),
                              ],
                            )),
                      ),
                      10.verticalSpace,
                      Obx(() => Padding(
                          padding: EdgeInsets.symmetric(horizontal: 36.w),
                          child: Row(
                            children: [
                              Expanded(
                                child: Button(
                                  text:
                                      '${logic.loginType.value.exclusiveName} ${StrLibrary.login}',
                                  enabledColor:
                                      StylesLibrary.c_D9DCE3_opacity40,
                                  textStyle: StylesLibrary.ts_8443F8_16sp,
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
                                            style:
                                                StylesLibrary.ts_333333_14sp),
                                        TextSpan(
                                          text: StrLibrary.registerNow,
                                          style: StylesLibrary.ts_8443F8_14sp,
                                          recognizer: TapGestureRecognizer()
                                            ..onTap = logic.registerNow,
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ],
                        ),
                      ),
                       20.verticalSpace,
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 36.w),
                        child: Row(
                          mainAxisAlignment: (appCtrl.useFacebookLogin &&
                                  appCtrl.useGoogleLogin &&
                                  appCtrl.useAppleLogin)
                              ? MainAxisAlignment.spaceBetween
                              : MainAxisAlignment.spaceAround,
                          children: [
                            if (appCtrl.useFacebookLogin)
                              ImageLibrary.fb.toImage
                                ..width = 56.w
                                ..height = 56.h
                                ..onTap = logic.loginFb,
                            if (appCtrl.useGoogleLogin)
                              ImageLibrary.google.toImage
                                ..width = 56.w
                                ..height = 56.h
                                ..onTap = logic.loginGoogle,
                            if (appCtrl.useAppleLogin)
                              ImageLibrary.apple.toImage
                                ..width = 56.w
                                ..height = 56.h
                                ..onTap = logic.loginApple,
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
                          offset: Offset(0, -12.h),
                          child: Transform.scale(
                              scale: 0.75,
                              child: Checkbox(
                                visualDensity: VisualDensity.compact,
                                // activeColor: StylesLibrary.c_8443F8,
                                fillColor: MaterialStateProperty.resolveWith(
                                    (Set<MaterialState> states) =>
                                        states.contains(MaterialState.selected)
                                            ? StylesLibrary.c_8443F8
                                            : null),
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
                                style: StylesLibrary.ts_656565_12sp),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => AppNavigator.startTermsOfServer(),
                                text: StrLibrary.privacyPolicyDescriptionP2,
                                style: StylesLibrary.ts_333333_12sp),
                            TextSpan(
                                text: StrLibrary.privacyPolicyDescriptionP3,
                                style: StylesLibrary.ts_656565_12sp),
                            TextSpan(
                                recognizer: TapGestureRecognizer()
                                  ..onTap =
                                      () => AppNavigator.startPrivacyPolicy(),
                                text: StrLibrary.privacyPolicyDescriptionP4,
                                style: StylesLibrary.ts_333333_12sp),
                            // TextSpan(
                            //     text: StrLibrary.privacyPolicyDescriptionP5,
                            //     style: StylesLibrary.ts_656565_12sp),
                          ])),
                        )
                      ],
                    ),
                  ),
                ),
                if (logic.isAddAccount.value)
                  Padding(
                    padding: EdgeInsets.only(left: 12.w, top: 54.h),
                    child: ImageLibrary.backBlack.toImage
                      ..width = 24.w
                      ..height = 24.h
                      ..onTap = () => logic.cusBack(),
                  ),
              ],
            ),
          ),
        )) ;
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
