import 'package:get/get.dart';
import 'package:openim/pages/contacts/friend_requests/friend_requests_logic.dart';
import 'package:openim/pages/contacts/group_requests/group_requests_logic.dart';

import 'recent_requests_logic.dart';

class RecentRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RecentRequestsLogic());
    Get.lazyPut(() => FriendRequestsLogic());
    Get.lazyPut(() => GroupRequestsLogic());
  }
}
