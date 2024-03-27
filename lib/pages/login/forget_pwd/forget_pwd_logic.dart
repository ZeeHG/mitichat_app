import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

import '../login_logic.dart';

class ForgetPwdLogic extends GetxController {
  final phoneEmailCtrl = TextEditingController();
  final verificationCodeCtrl = TextEditingController();
  final areaCode = "+1".obs;
  final enabled = false.obs;
  final loginController = Get.find<LoginLogic>();
  String? get email => loginController.operateType == LoginType.email
      ? phoneEmailCtrl.text.trim()
      : null;
  String? get phone => loginController.operateType == LoginType.phone
      ? phoneEmailCtrl.text.trim()
      : null;

  @override
  void onClose() {
    phoneEmailCtrl.dispose();
    verificationCodeCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    _init();
    phoneEmailCtrl.addListener(handleFormChange);
    verificationCodeCtrl.addListener(handleFormChange);
    super.onInit();
  }

  handleFormChange() {
    enabled.value = phoneEmailCtrl.text.trim().isNotEmpty &&
        verificationCodeCtrl.text.trim().isNotEmpty;
  }

  _init() async {
    var map = DataSp.getLoginAccount();
    if (map is Map) {
      String? areaCode = map["areaCode"];
      if (areaCode != null && areaCode.isNotEmpty) {
        this.areaCode.value = areaCode;
      }
    }
  }

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  Future<bool> getVerificationCode() async {
    if (phone?.isNotEmpty == true &&
        !MitiUtils.isMobile(areaCode.value, phoneEmailCtrl.text)) {
      showToast(StrLibrary.plsEnterRightPhone);
      return false;
    }

    if (email?.isNotEmpty == true && !phoneEmailCtrl.text.isEmail) {
      showToast(StrLibrary.plsEnterRightEmail);
      return false;
    }

    final success = await LoadingView.singleton.start(
        fn: () => Apis.requestVerificationCode(
              areaCode: areaCode.value,
              phoneNumber: phone,
              email: email,
              usedFor: 2,
            ));
    return success;
  }

  checkVerificationCode() => LoadingView.singleton.start(
      fn: () => Apis.checkVerificationCode(
            areaCode: areaCode.value,
            phoneNumber: phone,
            email: email,
            verificationCode: verificationCodeCtrl.text,
            usedFor: 2,
          ));

  void nextStep() async {
    await checkVerificationCode();
    AppNavigator.startResetPwd(
      areaCode: areaCode.value,
      phoneNumber: phone,
      email: email,
      verificationCode: verificationCodeCtrl.text,
    );
  }
}
