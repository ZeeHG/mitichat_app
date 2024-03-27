import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/core/ctrl/push_ctrl.dart';
import 'package:miti/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';

class PhoneEmailChangeDetailLogic extends GetxController {
  late Rx<UserFullInfo> userInfo;
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  final type = PhoneEmailChangeType.phone.obs;
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final verificationCodeCtrl = TextEditingController();
  final areaCode = "+1".obs;
  final enabled = false.obs;
  final success = false.obs;
  final accountUtil = Get.find<AccountUtil>();

  get isPhone => type.value == PhoneEmailChangeType.phone;
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
    if (isPhone && !MitiUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrLibrary.plsEnterRightPhone);
      return false;
    }
    if (!isPhone && !MitiUtils.isEmail(emailCtrl.text)) {
      IMViews.showToast(StrLibrary.plsEnterRightEmail);
      return false;
    }
    if (verificationCodeCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrLibrary.plsEnterVerificationCode);
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
        IMViews.showToast(StrLibrary.plsEnterPhoneNumber);
        return false;
      }
      if (phone?.isNotEmpty == true &&
          !MitiUtils.isMobile(areaCode.value, phoneCtrl.text)) {
        IMViews.showToast(StrLibrary.plsEnterRightPhone);
        return false;
      }
    } else {
      if (email?.isEmpty == true) {
        IMViews.showToast(StrLibrary.plsEnterEmail);
        return false;
      }
      if (email?.isNotEmpty == true && !email!.isEmail) {
        IMViews.showToast(StrLibrary.plsEnterRightEmail);
        return false;
      }
    }
    return await LoadingView.singleton.start(
      fn: () => requestVerificationCode(),
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
      await LoadingView.singleton.start(fn: () async {
        !isPhone
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
      accountUtil.tryLogout();
      success.value = true;
    }
  }

  void goLogin() async {
    AppNavigator.startLogin();
  }
}
