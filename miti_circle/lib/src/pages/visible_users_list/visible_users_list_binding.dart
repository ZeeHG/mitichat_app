import 'package:get/get.dart';

import 'visible_users_list_logic.dart';

class VisibleUsersListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => VisibleUsersListLogic());
  }
}
