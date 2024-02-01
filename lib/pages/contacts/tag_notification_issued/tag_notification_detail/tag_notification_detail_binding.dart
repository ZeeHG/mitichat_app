import 'package:get/get.dart';

import 'tag_notification_detail_logic.dart';

class TagNotificationDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TagNotificationDetailLogic());
  }
}
