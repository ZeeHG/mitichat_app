import 'package:get/get.dart';

import 'friend_setting_logic.dart';

class FriendSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendSettingLogic());
  }
}
