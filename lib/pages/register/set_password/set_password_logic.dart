import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/controller/im_ctrl.dart';
import '../../../core/controller/push_ctrl.dart';
import '../../../routes/app_navigator.dart';

class SetPasswordLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  final nicknameCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final pwdAgainCtrl = TextEditingController();
  final enabled = false.obs;
  String? phoneNumber;
  String? email;
  late String areaCode;
  late int usedFor;
  late String verificationCode;
  String? invitationCode;
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();

  @override
  void onClose() {
    nicknameCtrl.dispose();
    pwdCtrl.dispose();
    pwdAgainCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    phoneNumber = Get.arguments['phoneNumber'];
    email = Get.arguments['email'];
    areaCode = Get.arguments['areaCode'];
    usedFor = Get.arguments['usedFor'];
    verificationCode = Get.arguments['verificationCode'];
    invitationCode = Get.arguments['invitationCode'];
    nicknameCtrl.addListener(_onChanged);
    pwdCtrl.addListener(_onChanged);
    pwdAgainCtrl.addListener(_onChanged);
    super.onInit();
  }

  _onChanged() {
    enabled.value = nicknameCtrl.text.trim().isNotEmpty &&
        pwdCtrl.text.trim().isNotEmpty &&
        pwdAgainCtrl.text.trim().isNotEmpty;
  }

  bool _checkingInput() {
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
    return true;
  }

  void nextStep() {
    if (_checkingInput()) {
      register();
    }
    // if (usedFor == 1) {
    //   // 注册
    //
    //   AppNavigator.startSetSelfInfo(
    //     areaCode: areaCode,
    //     phoneNumber: phoneNumber,
    //     password: pwdCtrl.text.trim(),
    //     usedFor: usedFor,
    //     verificationCode: verificationCode,
    //     invitationCode: invitationCode,
    //   );
    // } else if (usedFor == 2) {
    //   //重置密码
    // }
  }

  void register() async {
    await LoadingView.singleton.start(fn: () async {
      final data = await Apis.register(
        nickname: nicknameCtrl.text.trim(),
        areaCode: areaCode,
        phoneNumber: phoneNumber,
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
        "areaCode": areaCode,
        "phoneNumber": phoneNumber,
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
          phoneNumber: phoneNumber,
          areaCode: areaCode,
          password: IMUtils.generateMD5(pwdCtrl.text)!,
          faceURL: imCtrl.userInfo.value.faceURL,
          nickname: imCtrl.userInfo.value.nickname);
      Logger.print('---------im login success-------');
      translateLogic.init(data.userID);
      ttsLogic.init(data.userID);
      pushCtrl.login(data.userID);
      Logger.print('---------jpush login success----');
    });
    AppNavigator.startMain();
  }
}
