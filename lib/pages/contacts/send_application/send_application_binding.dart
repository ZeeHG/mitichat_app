import 'package:get/get.dart';

import 'send_application_logic.dart';

class SendApplicationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SendApplicationLogic());
  }
}
