import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';

class DevEntryLogic extends GetxController {
  final TextEditingController inputCtrl = TextEditingController(text: "");
  final accountUtil = Get.find<AccountUtil>();
  final ver = "1.0.0".obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  tempLogin() {
    accountUtil.tempLogin(inputCtrl.text);
  }
}
