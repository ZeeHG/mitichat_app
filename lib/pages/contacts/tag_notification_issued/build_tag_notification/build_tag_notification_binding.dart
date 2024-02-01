import 'package:get/get.dart';

import 'build_tag_notification_logic.dart';

class BuildTagNotificationBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BuildTagNotificationLogic());
  }
}
