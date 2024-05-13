import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti_common/miti_common.dart';

class ActiveAccountLogic extends GetxController {
  final TextEditingController inputCtrl = TextEditingController(text: "");
  // input, submitSuccess, waitingAgree, activeSuccess
  final status = "".obs;
  final imCtrl = Get.find<IMCtrl>();

  get userID => imCtrl.userInfo.value.userID;

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      await imCtrl.queryMyFullInfo();
      if (imCtrl.userInfo.value.isAlreadyActive == true) {
        status.value = "activeSuccess";
        return;
      }
      final res = await ClientApis.querySelfApplyActive();
      status.value = res.isNotEmpty
              ? "waitingAgree"
              : "input";
    });
  }

  confirm() {
    if (inputCtrl.text.trim().isEmpty) {
      showToast(StrLibrary.plsEnterRightInvitationCode);
      return;
    }
    LoadingView.singleton.start(fn: () async {
      await ClientApis.applyActive(inviteMitiID: inputCtrl.text);
      status.value = "submitSuccess";
      showToast(StrLibrary.submitSuccess);
    });
  }
}
