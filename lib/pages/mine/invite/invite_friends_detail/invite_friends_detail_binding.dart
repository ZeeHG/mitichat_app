import 'package:get/get.dart';

import 'invite_friends_detail_logic.dart';

class InviteFriendsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteFriendsDetailLogic());
  }
}
