import 'package:get/get.dart';

import 'edit_announcement_logic.dart';

class EditGroupAnnouncementBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditGroupAnnouncementLogic());
  }
}
