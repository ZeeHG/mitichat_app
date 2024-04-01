import 'package:get/get.dart';

import 'handle_group_requests_logic.dart';

class HandleGroupRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HandleGroupRequestsLogic());
  }
}
