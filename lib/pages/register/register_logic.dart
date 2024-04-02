import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/core/ctrl/push_ctrl.dart';
import 'package:miti/pages/login/login_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';

import '../../core/ctrl/app_ctrl.dart';

class RegisterLogic extends GetxController {
  final appCtrl = Get.find<AppCtrl>();
  final phoneCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final invitationCodeCtrl = TextEditingController();
  final areaCode = "+1".obs;
  final enabled = false.obs;
  final loginCtrl = Get.find<LoginLogic>();
  final verificationCodeCtrl = TextEditingController();
  final nicknameCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final pwdAgainCtrl = TextEditingController();
  final operateType = LoginType.phone.obs;
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final isAddAccount = false.obs;
  final accountUtil = Get.find<AccountUtil>();
  final server = Config.hostWithProtocol.obs;

  bool get isPhoneRegister => operateType.value == LoginType.phone;
  String? get email => !isPhoneRegister ? emailCtrl.text.trim() : null;
  String? get phone => isPhoneRegister ? phoneCtrl.text.trim() : null;
  String? get areaCodeValue => isPhoneRegister ? areaCode.value : null;
  String get verificationCode => verificationCodeCtrl.text.trim();
  String get nickname => nicknameCtrl.text.trim();
  String get password => pwdCtrl.text.trim();
  String? get invitationCode =>
      MitiUtils.emptyStrToNull(invitationCodeCtrl.text);

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
    LoadingView.singleton.start(
      fn: () async {
        await appCtrl.getClientConfig();
      },
    );
    isAddAccount.value = Get.arguments?['isAddAccount'] ?? false;
    server.value = Get.arguments?['server'] ?? server.value;
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
    final accountValid = isPhoneRegister
        ? phoneCtrl.text.trim().isNotEmpty
        : emailCtrl.text.trim().isNotEmpty;
    enabled.value = accountValid &&
        checkInvitationCodeValid() &&
        verificationCodeCtrl.text.trim().isNotEmpty &&
        nicknameCtrl.text.trim().isNotEmpty &&
        pwdCtrl.text.trim().isNotEmpty &&
        pwdAgainCtrl.text.trim().isNotEmpty;
  }

  bool checkInput() {
    if (isPhoneRegister &&
        !MitiUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      showToast(StrLibrary.plsEnterRightPhone);
      return false;
    }
    if (!isPhoneRegister && !MitiUtils.isEmail(emailCtrl.text)) {
      showToast(StrLibrary.plsEnterRightEmail);
      return false;
    }
    if (verificationCodeCtrl.text.trim().isEmpty) {
      showToast(StrLibrary.plsEnterVerificationCode);
      return false;
    }
    if (nicknameCtrl.text.trim().isEmpty) {
      showToast(StrLibrary.plsEnterYourNickname);
      return false;
    }
    if (!MitiUtils.isValidPassword(pwdCtrl.text)) {
      showToast(StrLibrary.wrongPasswordFormat);
      return false;
    } else if (pwdCtrl.text != pwdAgainCtrl.text) {
      showToast(StrLibrary.twicePwdNoSame);
      return false;
    }
    if (checkInvitationCodeValid()) {
      showToast(StrLibrary.plsEnterInvitationCode2);
      return false;
    }
    return true;
  }

  bool get needInvitationCode =>
      null != appCtrl.clientConfig['needInvitationCode'] &&
      appCtrl.clientConfig['needInvitationCode'] != '0';

  bool checkInvitationCodeValid() =>
      needInvitationCode ? invitationCodeCtrl.text.trim().isNotEmpty : true;

  void openCountryPicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  Future<bool> requestVerificationCode() => ClientApis.requestVerificationCode(
        areaCode: areaCodeValue,
        phoneNumber: phone,
        email: email,
        usedFor: 1,
        invitationCode: invitationCode,
      );

  Future<bool> getVerificationCode() async {
    if (checkInvitationCodeValid()) {
      showToast(StrLibrary.plsEnterInvitationCode2);
      return false;
    }
    if (isPhoneRegister) {
      if (phone?.isEmpty == true) {
        showToast(StrLibrary.plsEnterPhoneNumber);
        return false;
      }
      if (phone?.isNotEmpty == true &&
          !MitiUtils.isMobile(areaCode.value, phoneCtrl.text)) {
        showToast(StrLibrary.plsEnterRightPhone);
        return false;
      }
    } else {
      if (email?.isEmpty == true) {
        showToast(StrLibrary.plsEnterEmail);
        return false;
      }
      if (email?.isNotEmpty == true && !email!.isEmail) {
        showToast(StrLibrary.plsEnterRightEmail);
        return false;
      }
    }
    return await LoadingView.singleton.start(
      fn: () => requestVerificationCode(),
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
    if (isPhoneRegister) {
      operateType.value = LoginType.email;
    } else {
      operateType.value = LoginType.phone;
    }
  }

  void register() async {
    if (checkInput()) {
      await LoadingView.singleton.start(fn: () async {
        if (!isAddAccount.value) {
          final data = await ClientApis.register(
            nickname: nickname,
            areaCode: areaCodeValue,
            phoneNumber: phone,
            email: email,
            password: pwdCtrl.text,
            verificationCode: verificationCode,
            invitationCode: invitationCode,
          );
          if (null == MitiUtils.emptyStrToNull(data.imToken) ||
              null == MitiUtils.emptyStrToNull(data.chatToken)) {
            AppNavigator.startLogin();
            return;
          }
          await DataSp.putLoginCertificate(data);
          DataSp.putLoginType(!isPhoneRegister ? 1 : 0);
          await imCtrl.login(data.userID, data.imToken);
          await setAccountLoginInfo(
              userID: data.userID,
              imToken: data.imToken,
              chatToken: data.chatToken,
              email: email,
              phoneNumber: phone,
              areaCode: areaCodeValue,
              password: MitiUtils.generateMD5(pwdCtrl.text)!,
              faceURL: imCtrl.userInfo.value.faceURL,
              nickname: imCtrl.userInfo.value.nickname);
          translateLogic.init(data.userID);
          ttsLogic.init(data.userID);
          pushCtrl.login(data.userID);
          AppNavigator.startMain();
        } else {
          final isOk = await accountUtil.registerAccount(
            switchBack: false,
            serverWithProtocol: server.value,
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
