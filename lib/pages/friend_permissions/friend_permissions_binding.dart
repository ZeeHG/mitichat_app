import 'package:get/get.dart';

import 'friend_permissions_logic.dart';

class FriendPermissionsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FriendPermissionsLogic());
  }
}
