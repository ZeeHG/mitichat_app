import 'package:get/get.dart';

import 'my_ai_logic.dart';

class MyAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyAiLogic());
  }
}
