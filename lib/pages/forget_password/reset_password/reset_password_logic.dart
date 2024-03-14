import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class ResetPasswordLogic extends GetxController {
  final pwdCtrl = TextEditingController();
  final pwdAgainCtrl = TextEditingController();
  final enabled = false.obs;
  String? phoneNumber;
  String? email;
  late String areaCode;
  late int usedFor;
  late String verificationCode;
  String? invitationCode;

  @override
  void onClose() {
    pwdCtrl.dispose();
    pwdAgainCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    email = Get.arguments['email'];
    areaCode = Get.arguments['areaCode'];
    verificationCode = Get.arguments['verificationCode'];
    pwdCtrl.addListener(_onChanged);
    pwdAgainCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    enabled.value =
        pwdCtrl.text.trim().isNotEmpty && pwdAgainCtrl.text.trim().isNotEmpty;
  }

  bool _checkingInput() {
    if (!IMUtils.isValidPassword(pwdCtrl.text)) {
      IMViews.showToast(StrLibrary.wrongPasswordFormat);
      return false;
    } else if (pwdCtrl.text != pwdAgainCtrl.text) {
      IMViews.showToast(StrLibrary.twicePwdNoSame);
      return false;
    }
    return true;
  }

  resetPassword() => LoadingView.singleton.start(
      fn: () => Apis.resetPassword(
            areaCode: areaCode,
            phoneNumber: phoneNumber,
            email: email,
            password: pwdCtrl.text,
            verificationCode: verificationCode,
          ));

  confirmTheChanges() async {
    if (_checkingInput()) {
      await resetPassword();
      IMViews.showToast(StrLibrary.changedSuccessfully);
      AppNavigator.startBackLogin();
    }
  }
}
