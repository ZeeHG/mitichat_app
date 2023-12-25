import 'package:get/get.dart';

import '../discover_list/discover_list_logic.dart';
import '../follow_list/follow_list_logic.dart';
import 'new_discover_logic.dart';

class NewDiscoverBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NewDiscoverLogic());
    Get.lazyPut(() => DiscoverListLogic());
    Get.lazyPut(() => FollowListLogic());
  }
}
