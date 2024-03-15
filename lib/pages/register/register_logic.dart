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
  final loginController = Get.find<LoginLogic>();
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
    LoadingView.singleton.start(
      fn: () async {
        await appCtrl.queryClientConfig();
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
      IMViews.showToast(StrLibrary.plsEnterRightPhone);
      return false;
    }
    if (!phoneRegister && !IMUtils.isEmail(emailCtrl.text)) {
      IMViews.showToast(StrLibrary.plsEnterRightEmail);
      return false;
    }
    if (verificationCodeCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrLibrary.plsEnterVerificationCode);
      return false;
    }
    if (nicknameCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrLibrary.plsEnterYourNickname);
      return false;
    }
    if (!IMUtils.isValidPassword(pwdCtrl.text)) {
      IMViews.showToast(StrLibrary.wrongPasswordFormat);
      return false;
    } else if (pwdCtrl.text != pwdAgainCtrl.text) {
      IMViews.showToast(StrLibrary.twicePwdNoSame);
      return false;
    }
    if (needInvitationCodeRegister && invitationCodeCtrl.text.trim().isEmpty) {
      IMViews.showToast(StrLibrary.plsEnterInvitationCode2);
      return false;
    }
    return true;
  }

  bool get needInvitationCodeRegister =>
      null != appCtrl.clientConfigMap['needInvitationCodeRegister'] &&
      appCtrl.clientConfigMap['needInvitationCodeRegister'] != '0';

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
      IMViews.showToast(StrLibrary.plsEnterInvitationCode2);
      return false;
    }
    if (phoneRegister) {
      if (phone?.isEmpty == true) {
        IMViews.showToast(StrLibrary.plsEnterPhoneNumber);
        return false;
      }
      if (phone?.isNotEmpty == true &&
          !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
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
      IMViews.showToast(StrLibrary.plsEnterRightPhone);
      return;
    }

    if (loginController.operateType == LoginType.email &&
        !phoneCtrl.text.isEmail) {
      IMViews.showToast(StrLibrary.plsEnterRightEmail);
      return;
    }
    final success = await LoadingView.singleton.start(
      fn: () => requestVerificationCode(),
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
      await LoadingView.singleton.start(fn: () async {
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
          await imCtrl.login(data.userID, data.imToken);
          await setAccountLoginInfo(
              userID: data.userID,
              imToken: data.imToken,
              chatToken: data.chatToken,
              email: email,
              phoneNumber: phone,
              areaCode: areaCodeValue,
              password: IMUtils.generateMD5(pwdCtrl.text)!,
              faceURL: imCtrl.userInfo.value.faceURL,
              nickname: imCtrl.userInfo.value.nickname);
          Logger.print('---------im login success-------');
          translateLogic.init(data.userID);
          ttsLogic.init(data.userID);
          pushCtrl.login(data.userID);
          Logger.print('---------jpush login success----');
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
