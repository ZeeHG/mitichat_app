import 'package:get/get.dart';

import 'inviting_friends_logic.dart';

class InvitingFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InvitingFriendsLogic());
  }
}
