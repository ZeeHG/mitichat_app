import 'package:get/get.dart';

import 'active_account_logic.dart';

class ActiveAccountBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActiveAccountLogic());
  }
}
