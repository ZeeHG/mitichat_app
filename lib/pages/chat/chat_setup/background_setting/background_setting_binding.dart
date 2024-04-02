import 'package:get/get.dart';

import 'background_setting_logic.dart';

class BackgroundSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BackgroundSettingLogic());
  }
}
