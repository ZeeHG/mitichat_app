import 'package:get/get.dart';

import 'chat_setting_logic.dart';

class ChatSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatSetupLogic());
  }
}
