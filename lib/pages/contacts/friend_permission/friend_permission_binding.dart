import 'package:get/get.dart';

import 'friend_permission_logic.dart';

class FriendPermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendPermissionLogic());
  }
}
