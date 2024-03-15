import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti/core/controller/im_ctrl.dart';
import 'package:miti/core/controller/push_ctrl.dart';
import 'package:miti/pages/mine/mine_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class DeleteUserLogic extends GetxController {
  final success = false.obs;
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  final mineLogic = Get.find<MineLogic>();
  final pwdCtrl = TextEditingController();
  final enabled = false.obs;

  showDeleteUserModal() async {
    final confirm = await Get.dialog(CustomDialog(
      bigTitle: StrLibrary.deleteUserModalTitle,
      leftText: StrLibrary.deleteUserModalBtn1,
      rightText: StrLibrary.deleteUserModalBtn2,
      title: StrLibrary.deleteUserModalTips,
      onTapLeft: () => Get.back(result: true),
      onTapRight: () => Get.back(result: false),
    ));
    if (confirm) {
      mineLogic.kickedOfflineSub.cancel();
      try {
        await LoadingView.singleton.start(
          fn: () => Apis.deleteUser(password: pwdCtrl.text.trim()),
        );
        success.value = true;
      } catch (e) {
        mineLogic.kickedOfflineSubInit();
      }
    }
  }

  logout() async {
    // 自动踢出
    // await imCtrl.logout();
    await DataSp.removeLoginCertificate();
    pushCtrl.logout();
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
