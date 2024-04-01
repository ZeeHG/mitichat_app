import 'package:get/get.dart';
// import 'package:miti/pages/contacts/friend_requests/friend_requests_logic.dart';
// import 'package:miti/pages/contacts/group_requests/group_requests_logic.dart';

import 'request_records_logic.dart';

class RequestRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestRecordsLogic());
    // Get.lazyPut(() => FriendRequestsLogic());
    // Get.lazyPut(() => GroupRequestsLogic());
  }
}
