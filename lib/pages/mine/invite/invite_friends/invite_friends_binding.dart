import 'package:get/get.dart';

import 'invite_friends_logic.dart';

class InviteFriendsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteFriendsLogic());
  }
}
