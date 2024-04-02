import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';
import '../../../core/ctrl/push_ctrl.dart';
import '../../../routes/app_navigator.dart';

class ChangePwdLogic extends GetxController {
  final pushCtrl = Get.find<PushCtrl>();
  final oldPwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController();
  final againPwdCtrl = TextEditingController();
  final enabled = true.obs();
  final accountUtil = Get.find<AccountUtil>();

  @override
  void onClose() {
    oldPwdCtrl.dispose();
    newPwdCtrl.dispose();
    againPwdCtrl.dispose();
    super.onClose();
  }

  void confirm() async {
    if (newPwdCtrl.text.isEmpty) {
      showToast(StrLibrary.plsEnterNewPwd);
      return;
    }
    if (!MitiUtils.isValidPassword(newPwdCtrl.text)) {
      showToast(StrLibrary.wrongPasswordFormat);
      return;
    }
    if (oldPwdCtrl.text.isEmpty) {
      showToast(StrLibrary.plsEnterOldPwd);
      return;
    }
    if (againPwdCtrl.text.isEmpty) {
      showToast(StrLibrary.plsEnterConfirmPwd);
      return;
    }
    if (newPwdCtrl.text != againPwdCtrl.text) {
      showToast(StrLibrary.twicePwdNoSame);
      return;
    }

    final result = await LoadingView.singleton.start(
      fn: () => ClientApis.changePassword(
        userID: OpenIM.iMManager.userID,
        newPassword: newPwdCtrl.text,
        currentPassword: oldPwdCtrl.text,
      ),
    );
    if (result) {
      showToast(StrLibrary.changedSuccessfully);
      await LoadingView.singleton.start(fn: () async {
        await accountUtil.tryLogout();
      });
      AppNavigator.startLogin();
    }
  }
}
