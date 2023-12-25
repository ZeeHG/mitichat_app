import 'package:get/get.dart';

import 'follow_list_logic.dart';

class FollowListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => FollowListLogic());
  }
}
