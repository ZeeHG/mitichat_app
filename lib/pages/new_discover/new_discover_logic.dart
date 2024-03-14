import 'dart:io';
import 'package:get/get.dart';
import 'package:miti/core/controller/app_controller.dart';
import 'package:miti_common/miti_common.dart';

import '../../routes/app_navigator.dart';

class NewDiscoverLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final popCtrl = CustomPopupMenuController();
  final index = 1.obs;

  get showBottom => index.value == 1;

  void switchTab(i) {
    index.value = i;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  scan() => AppNavigator.startScan();
}
