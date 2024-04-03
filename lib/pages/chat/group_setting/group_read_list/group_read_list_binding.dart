import 'package:get/get.dart';

import 'group_read_list_logic.dart';

class GroupReadListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupReadListLogic());
  }
}
