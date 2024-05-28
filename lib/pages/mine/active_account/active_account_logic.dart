import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class ActiveAccountLogic extends GetxController {
  final TextEditingController inputCtrl = TextEditingController(text: "");
  // input, submitSuccess, waitingAgree, activeSuccess
  final status = "".obs;
  final isValid = false.obs;
  final imCtrl = Get.find<IMCtrl>();

  @override
  void onInit() {
    inputCtrl.addListener(() {
      isValid.value = inputCtrl.text != "";
    });
    loadingData();
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  loadingData() async {
    await ClientApis.querySelfApplyActive();
    LoadingView.singleton.start(fn: () async {
      await imCtrl.queryMyFullInfo();
      if (imCtrl.userInfo.value.isAlreadyActive == true) {
        status.value = "activeSuccess";
        return;
      }
      final res = await ClientApis.querySelfApplyActive();
      status.value =
          (res == null || res.result == 2) ? "input" : "waitingAgree";
    });
  }

  confirm() {
    if (inputCtrl.text.trim().isEmpty) {
      showToast(StrLibrary.plsEnterRightInvitationCode);
      return;
    }
    submitActive(inputCtrl.text);
  }

  submitActive(String inviteMitiID) async {
    LoadingView.singleton.start(fn: () async {
      await ClientApis.applyActive(inviteMitiID: inviteMitiID);
      status.value = "submitSuccess";
      showToast(StrLibrary.submitSuccess);
    });
  }

  scan() async {
    final Map<String, dynamic> result = await AppNavigator.startScan(qrFutureList: [QrFuture.invite]);
    if (result["autoHandle"] == true) {
      status.value = "submitSuccess";
    }
  }
}
