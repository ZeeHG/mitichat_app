import 'package:get/get.dart';

import 'circle_message_logic.dart';

class CircleMessageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CircleMessageLogic());
  }
}
