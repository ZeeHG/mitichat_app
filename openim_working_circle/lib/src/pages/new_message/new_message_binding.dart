import 'package:get/get.dart';

import 'new_message_logic.dart';

class NewMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewMessageLogic());
  }
}
