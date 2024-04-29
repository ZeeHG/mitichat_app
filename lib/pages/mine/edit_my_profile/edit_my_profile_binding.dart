import 'package:get/get.dart';

import 'edit_my_profile_logic.dart';

class EditMyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditMyProfileLogic());
  }
}
