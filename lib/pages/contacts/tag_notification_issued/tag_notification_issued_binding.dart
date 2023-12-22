import 'package:get/get.dart';

import 'tag_notification_issued_logic.dart';

class TagNotificationIssuedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TagNotificationIssuedLogic());
  }
}
