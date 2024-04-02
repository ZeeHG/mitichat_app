import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class ResetPwdLogic extends GetxController {
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
    pwdCtrl.addListener(handleFormChange);
    pwdAgainCtrl.addListener(handleFormChange);
    super.onInit();
  }

  handleFormChange() {
    enabled.value =
        pwdCtrl.text.trim().isNotEmpty && pwdAgainCtrl.text.trim().isNotEmpty;
  }

  bool checkForm() {
    if (!MitiUtils.isValidPassword(pwdCtrl.text)) {
      showToast(StrLibrary.wrongPasswordFormat);
      return false;
    } else if (pwdCtrl.text != pwdAgainCtrl.text) {
      showToast(StrLibrary.twicePwdNoSame);
      return false;
    }
    return true;
  }

  confirmTheChanges() async {
    if (checkForm()) {
      await LoadingView.singleton.start(
          fn: () => ClientApis.resetPassword(
                areaCode: areaCode,
                phoneNumber: phoneNumber,
                email: email,
                password: pwdCtrl.text,
                verificationCode: verificationCode,
              ));
      showToast(StrLibrary.changedSuccessfully);
      AppNavigator.startBackLogin();
    }
  }
}
