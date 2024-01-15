import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../login/login_logic.dart';

class ForgetPasswordLogic extends GetxController {
  final phoneCtrl = TextEditingController();
  final verificationCodeCtrl = TextEditingController();
  final areaCode = "+1".obs;
  final enabled = false.obs;
  final loginController = Get.find<LoginLogic>();
  String? get email => loginController.operateType == LoginType.email
      ? phoneCtrl.text.trim()
      : null;
  String? get phone => loginController.operateType == LoginType.phone
      ? phoneCtrl.text.trim()
      : null;
  @override
  void onClose() {
    phoneCtrl.dispose();
    verificationCodeCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    _initData();
    phoneCtrl.addListener(_onChanged);
    verificationCodeCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    enabled.value = phoneCtrl.text.trim().isNotEmpty &&
        verificationCodeCtrl.text.trim().isNotEmpty;
  }

  _initData() async {
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
        !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return false;
    }

    if (email?.isNotEmpty == true && !phoneCtrl.text.isEmail) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return false;
    }

    final success = await sendVerificationCode();
    return success;
  }

  /// [usedFor] 1：注册，2：重置密码 3：登录
  Future<bool> sendVerificationCode() => LoadingView.singleton.wrap(
      asyncFunction: () => Apis.requestVerificationCode(
            areaCode: areaCode.value,
            phoneNumber: phone,
            email: email,
            usedFor: 2,
          ));

  checkVerificationCode() => LoadingView.singleton.wrap(
      asyncFunction: () => Apis.checkVerificationCode(
            areaCode: areaCode.value,
            phoneNumber: phone,
            email: email,
            verificationCode: verificationCodeCtrl.text,
            usedFor: 2,
          ));

  void nextStep() async {
    await checkVerificationCode();
    AppNavigator.startResetPassword(
      areaCode: areaCode.value,
      phoneNumber: phone,
      email: email,
      verificationCode: verificationCodeCtrl.text,
    );
  }
}
