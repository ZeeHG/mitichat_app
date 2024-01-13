import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/core/controller/push_controller.dart';
import 'package:openim/pages/login/login_logic.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim/utils/misc_util.dart';
import 'package:openim_common/openim_common.dart';

import '../../core/controller/app_controller.dart';

class RegisterLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final invitationCodeCtrl = TextEditingController();
  final areaCode = "+1".obs;
  final enabled = false.obs;
  final loginController = Get.find<LoginLogic>();
  final verificationCodeCtrl = TextEditingController();
  final nicknameCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final pwdAgainCtrl = TextEditingController();
  final operateType = LoginType.phone.obs;
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final isAddAccount = false.obs;
  final miscUtil = Get.find<MiscUtil>();
  final server = Config.host.obs;

  bool get phoneRegister => operateType.value == LoginType.phone;
  String? get email => !phoneRegister ? emailCtrl.text.trim() : null;
  String? get phone => phoneRegister ? phoneCtrl.text.trim() : null;
  String? get areaCodeValue => phoneRegister ? areaCode.value : null;
  String get verificationCode => verificationCodeCtrl.text.trim();
  String get nickname => nicknameCtrl.text.trim();
  String get password => pwdCtrl.text.trim();
  String? get invitationCode => IMUtils.emptyStrToNull(invitationCodeCtrl.text);

  @override
  void onClose() {
    phoneCtrl.dispose();
    emailCtrl.dispose();
    verificationCodeCtrl.dispose();
    nicknameCtrl.dispose();
    pwdCtrl.dispose();
    pwdAgainCtrl.dispose();
    invitationCodeCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    isAddAccount.value = Get.arguments['isAddAccount'] ?? false;
    server.value = Get.arguments['server'] ?? false;
    _initData();
    phoneCtrl.addListener(_onChanged);
    emailCtrl.addListener(_onChanged);
    verificationCodeCtrl.addListener(_onChanged);
    nicknameCtrl.addListener(_onChanged);
    pwdCtrl.addListener(_onChanged);
    pwdAgainCtrl.addListener(_onChanged);
    invitationCodeCtrl.addListener(_onChanged);
    super.onInit();
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
    final accountValid = phoneRegister
        ? phoneCtrl.text.trim().isNotEmpty
        : emailCtrl.text.trim().isNotEmpty;
    final invitationCodeValid = needInvitationCodeRegister
        ? invitationCodeCtrl.text.trim().isNotEmpty
        : true;
    enabled.value = accountValid &&
        invitationCodeValid &&
        verificationCodeCtrl.text.trim().isNotEmpty &&
        nicknameCtrl.text.trim().isNotEmpty &&
        pwdCtrl.text.trim().isNotEmpty &&
        pwdAgainCtrl.text.trim().isNotEmpty;
  }

  bool _checkingInput() {
    if (phoneRegister && !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return false;
    }
    if (!phoneRegister && !IMUtils.isEmail(emailCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return false;
    }
    if (verificationCodeCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrRes.plsEnterVerificationCode);
      return false;
    }
    if (nicknameCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrRes.plsEnterYourNickname);
      return false;
    }
    if (!IMUtils.isValidPassword(pwdCtrl.text)) {
      IMViews.showToast(StrRes.wrongPasswordFormat);
      return false;
    } else if (pwdCtrl.text != pwdAgainCtrl.text) {
      IMViews.showToast(StrRes.twicePwdNoSame);
      return false;
    }
    if (needInvitationCodeRegister && invitationCodeCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrRes.plsEnterInvitationCode2);
      return false;
    }
    return true;
  }

  bool get needInvitationCodeRegister =>
      null != appLogic.clientConfigMap['needInvitationCodeRegister'] &&
      appLogic.clientConfigMap['needInvitationCodeRegister'] != '0';

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  /// [usedFor] 1：注册，2：重置密码
  Future<bool> requestVerificationCode() => Apis.requestVerificationCode(
        areaCode: areaCodeValue,
        phoneNumber: phone,
        email: email,
        usedFor: 1,
        invitationCode: invitationCode,
      );

  Future<bool> getVerificationCode() async {
    if (needInvitationCodeRegister && invitationCodeCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrRes.plsEnterInvitationCode2);
      return false;
    }
    if (phoneRegister) {
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

  void switchType() {
    phoneCtrl.text = "";
    emailCtrl.text = "";
    verificationCodeCtrl.text = "";
    nicknameCtrl.text = "";
    pwdCtrl.text = "";
    pwdAgainCtrl.text = "";
    invitationCodeCtrl.text = "";
    if (phoneRegister) {
      operateType.value = LoginType.email;
    } else {
      operateType.value = LoginType.phone;
    }
  }

  void next() async {
    if (loginController.operateType == LoginType.phone &&
        !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return;
    }

    if (loginController.operateType == LoginType.email &&
        !phoneCtrl.text.isEmail) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return;
    }
    final success = await LoadingView.singleton.wrap(
      asyncFunction: () => requestVerificationCode(),
    );
    if (success) {
      AppNavigator.startVerifyPhone(
        areaCode: areaCode.value,
        phoneNumber: phone,
        email: email,
        usedFor: 1,
        invitationCode: invitationCode,
      );
    }
  }

  void register() async {
    if (_checkingInput()) {
      await LoadingView.singleton.wrap(asyncFunction: () async {
        if (!isAddAccount.value) {
          final data = await Apis.register(
            nickname: nickname,
            areaCode: areaCodeValue,
            phoneNumber: phone,
            email: email,
            password: pwdCtrl.text,
            verificationCode: verificationCode,
            invitationCode: invitationCode,
          );
          if (null == IMUtils.emptyStrToNull(data.imToken) ||
              null == IMUtils.emptyStrToNull(data.chatToken)) {
            AppNavigator.startLogin();
            return;
          }
          final account = {
            "areaCode": areaCodeValue,
            "phoneNumber": phone,
            'email': email
          };
          await DataSp.putLoginCertificate(data);
          // await DataSp.putMainLoginAccount(account);
          DataSp.putLoginType(email != null ? 1 : 0);
          await imLogic.login(data.userID, data.imToken);
          await setAccountLoginInfo(
              userID: data.userID,
              imToken: data.imToken,
              chatToken: data.chatToken,
              email: email,
              phoneNumber: phone,
              areaCode: areaCodeValue,
              password: IMUtils.generateMD5(pwdCtrl.text)!,
              faceURL: imLogic.userInfo.value.faceURL,
              nickname: imLogic.userInfo.value.nickname);
          Logger.print('---------im login success-------');
          translateLogic.init(data.userID);
          ttsLogic.init(data.userID);
          pushLogic.login(data.userID);
          Logger.print('---------jpush login success----');
          AppNavigator.startMain();
        } else {
          final isOk = await miscUtil.registerAccount(
            switchBack: false,
            server: server.value,
            nickname: nickname,
            areaCode: areaCodeValue,
            phoneNumber: phone,
            email: email,
            password: pwdCtrl.text,
            verificationCode: verificationCode,
            invitationCode: invitationCode,
          );
          if (isOk) AppNavigator.startMain();
        }
      });
    }
  }
}
