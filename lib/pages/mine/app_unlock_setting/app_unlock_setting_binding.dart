import 'package:get/get.dart';

import 'app_unlock_setting_logic.dart';

class AppUnlockSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppUnlockSettingLogic());
  }
}
