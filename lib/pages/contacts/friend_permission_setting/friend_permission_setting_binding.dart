import 'package:get/get.dart';

import 'friend_permission_setting_logic.dart';

class FriendPermissionSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendPermissionSettingLogic());
  }
}
