import 'package:get/get.dart';

import 'invite_friends_history_logic.dart';

class InviteFriendsHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteFriendsHistoryLogic());
  }
}
