import 'package:get/get.dart';

import 'group_setting_logic.dart';

class GroupChatSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupChatSettingLogic());
  }
}
