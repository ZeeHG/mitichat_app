import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/controller/push_ctrl.dart';
import '../../../routes/app_navigator.dart';

class ChangePwdLogic extends GetxController {
  final pushCtrl = Get.find<PushCtrl>();
  final oldPwdCtrl = TextEditingController();
  final newPwdCtrl = TextEditingController();
  final againPwdCtrl = TextEditingController();
  final enabled = true.obs();

  @override
  void onClose() {
    oldPwdCtrl.dispose();
    newPwdCtrl.dispose();
    againPwdCtrl.dispose();
    super.onClose();
  }

  void confirm() async {
    if (oldPwdCtrl.text.isEmpty) {
      IMViews.showToast(StrLibrary.plsEnterOldPwd);
      return;
    }
    if (!IMUtils.isValidPassword(newPwdCtrl.text)) {
      IMViews.showToast(StrLibrary.wrongPasswordFormat);
      return;
    }
    if (newPwdCtrl.text.isEmpty) {
      IMViews.showToast(StrLibrary.plsEnterNewPwd);
      return;
    }
    if (againPwdCtrl.text.isEmpty) {
      IMViews.showToast(StrLibrary.plsEnterConfirmPwd);
      return;
    }
    if (newPwdCtrl.text != againPwdCtrl.text) {
      IMViews.showToast(StrLibrary.twicePwdNoSame);
      return;
    }

    final result = await LoadingView.singleton.start(
      fn: () => Apis.changePassword(
        userID: OpenIM.iMManager.userID,
        newPassword: newPwdCtrl.text,
        currentPassword: oldPwdCtrl.text,
      ),
    );
    if (result) {
      IMViews.showToast(StrLibrary.changedSuccessfully);
      await LoadingView.singleton.start(fn: () async {
        await OpenIM.iMManager.logout();
        await DataSp.removeLoginCertificate();
        pushCtrl.logout();
      });
      AppNavigator.startLogin();
    }
  }
}
