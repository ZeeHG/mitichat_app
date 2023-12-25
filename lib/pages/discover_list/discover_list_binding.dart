import 'package:get/get.dart';

import 'discover_list_logic.dart';

class DiscoverListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DiscoverListLogic());
  }
}
