import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/core/controller/push_controller.dart';
import 'package:openim/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

class PhoneEmailChangeDetailLogic extends GetxController {
  late Rx<UserFullInfo> userInfo;
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final type = PhoneEmailChangeType.phone.obs;
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final verificationCodeCtrl = TextEditingController();
  final areaCode = "+1".obs;
  final enabled = false.obs;
  final success = false.obs;

  get isPhone => type == PhoneEmailChangeType.phone;
  String? get email => !isPhone ? emailCtrl.text.trim() : null;
  String? get phone => isPhone ? phoneCtrl.text.trim() : null;
  String? get areaCodeValue => isPhone ? areaCode.value : null;
  String get verificationCode => verificationCodeCtrl.text.trim();
  String get password => pwdCtrl.text.trim();

  @override
  void onInit() {
    _initData();
    type.value = Get.arguments['type'];
    phoneCtrl.addListener(_onChanged);
    emailCtrl.addListener(_onChanged);
    verificationCodeCtrl.addListener(_onChanged);
    pwdCtrl.addListener(_onChanged);
    super.onInit();
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    emailCtrl.dispose();
    pwdCtrl.dispose();
    verificationCodeCtrl.dispose();
    super.onClose();
  }

  _initData() async {
    var map = DataSp.getMainLoginAccount();
    if (map is Map) {
      String? areaCode = map["areaCode"];
      if (areaCode != null && areaCode.isNotEmpty) {
        this.areaCode.value = areaCode;
      }
    }
  }

  _onChanged() {
    final accountValid = isPhone
        ? phoneCtrl.text.trim().isNotEmpty
        : emailCtrl.text.trim().isNotEmpty;
    enabled.value = accountValid &&
        verificationCodeCtrl.text.trim().isNotEmpty &&
        pwdCtrl.text.trim().isNotEmpty;
  }

  bool _checkingInput() {
    if (isPhone && !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return false;
    }
    if (!isPhone && !IMUtils.isEmail(emailCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return false;
    }
    if (verificationCodeCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrRes.plsEnterVerificationCode);
      return false;
    }
    return true;
  }

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  Future<bool> getVerificationCode() async {
    if (isPhone) {
      if (phone?.isEmpty == true) {
        IMViews.showToast(StrRes.plsEnterPhoneNumber);
        return false;
      }
      if (phone?.isNotEmpty == true &&
          !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
        IMViews.showToast(StrRes.plsEnterRightPhone);
        return false;
      }
    } else {
      if (email?.isEmpty == true) {
        IMViews.showToast(StrRes.plsEnterEmail);
        return false;
      }
      if (email?.isNotEmpty == true && !email!.isEmail) {
        IMViews.showToast(StrRes.plsEnterRightEmail);
        return false;
      }
    }
    return await LoadingView.singleton.wrap(
      asyncFunction: () => requestVerificationCode(),
    );
  }

  Future<bool> requestVerificationCode() => Apis.requestVerificationCode(
        areaCode: areaCodeValue,
        phoneNumber: phone,
        email: email,
        usedFor: isPhone ? 4 : 5,
      );

  void updateInfo() async {
    if (_checkingInput()) {
      await LoadingView.singleton.wrap(asyncFunction: () async {
        final data = !isPhone
            ? await Apis.updateEmail(
                email: email,
                password: pwdCtrl.text,
                verificationCode: verificationCode,
              )
            : await Apis.updatePhone(
                areaCode: areaCodeValue,
                phoneNumber: phone,
                password: pwdCtrl.text,
                verificationCode: verificationCode,
              );
      });
      await imLogic.logout();
      await DataSp.removeLoginCertificate();
      pushLogic.logout();
      success.value = true;
    }
  }

  void goLogin() async {
    AppNavigator.startLogin();
  }
}
