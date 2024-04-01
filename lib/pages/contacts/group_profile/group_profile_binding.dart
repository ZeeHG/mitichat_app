import 'package:get/get.dart';

import 'group_profile_logic.dart';

class GroupProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GroupProfileLogic());
  }
}
