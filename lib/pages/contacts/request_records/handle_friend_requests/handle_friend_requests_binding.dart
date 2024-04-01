import 'package:get/get.dart';

import 'handle_friend_requests_logic.dart';

class HandleFriendRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HandleFriendRequestsLogic());
  }
}
