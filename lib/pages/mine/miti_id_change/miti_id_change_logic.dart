import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class MitiIDChangeLogic extends GetxController {
  final TextEditingController inputCtrl = TextEditingController(text: "");
  final agree = false.obs;
  final imCtrl = Get.find<IMCtrl>();

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  confirm() {
    FocusManager.instance.primaryFocus?.unfocus();
    final text = inputCtrl.text;
    if (!RegExp(r'^[a-zA-Z_][a-zA-Z0-9_-]{5,19}$').hasMatch(text)) {
      showToast(StrLibrary.enterRightMitiID);
    } else {
      Future.delayed(Duration(milliseconds: 300), () {
        IMViews.openChangeMitiIDSheet(
            mitiID: text,
            onSubmit: save,
            agree: agree,
            onChangeAgree: (newValue) => agree.value = !agree.value,
            onTapRule: () {
              AppNavigator.startMitiIDChangeRule();
            });
      });
    }
  }

  void save() async {
    await LoadingView.singleton.start(fn: () async {
      await ClientApis.updateMitiID(mitiID: inputCtrl.text);
      imCtrl.userInfo.update((val) {
        val?.mitiID = inputCtrl.text;
      });
      showToast(StrLibrary.success);
      AppNavigator.offUntilMyInfo();
    });
  }
}
