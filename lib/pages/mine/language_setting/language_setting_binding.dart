import 'package:get/get.dart';

import 'language_setting_logic.dart';

class LanguageSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageSettingLogic());
  }
}
