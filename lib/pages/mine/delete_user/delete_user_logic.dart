import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/im_controller.dart';
import 'package:openim/core/controller/push_controller.dart';
import 'package:openim/pages/mine/mine_logic.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

class DeleteUserLogic extends GetxController {
  final success = false.obs;
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final mineLogic = Get.find<MineLogic>();
  final pwdCtrl = TextEditingController();
  final enabled = false.obs;

  showDeleteUserModal() async {
    final confirm = await Get.dialog(CustomDialog(
      bigTitle: StrRes.deleteUserModalTitle,
      leftText: StrRes.deleteUserModalBtn1,
      rightText: StrRes.deleteUserModalBtn2,
      title: StrRes.deleteUserModalTips,
      onTapLeft: () => Get.back(result: true),
      onTapRight: () => Get.back(result: false),
    ));
    if (confirm) {
      mineLogic.kickedOfflineSub.cancel();
      try {
        await LoadingView.singleton.wrap(
          asyncFunction: () => Apis.deleteUser(password: pwdCtrl.text.trim()),
        );
        success.value = true;
      } catch (e) {
        mineLogic.kickedOfflineSubInit();
      }
    }
  }

  logout() async {
    // 自动踢出
    // await imLogic.logout();
    await DataSp.removeLoginCertificate();
    pushLogic.logout();
    AppNavigator.startLogin();
  }

  _onChanged() {
    enabled.value = pwdCtrl.text.trim().isNotEmpty;
  }

  @override
  void onInit() {
    pwdCtrl.addListener(_onChanged);
    super.onInit();
  }

  @override
  void onClose() {
    pwdCtrl.dispose();
    super.onClose();
  }
}
