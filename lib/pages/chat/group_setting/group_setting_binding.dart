import 'package:get/get.dart';

import 'group_setting_logic.dart';

class ChatSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatSettingLogic());
  }
}
