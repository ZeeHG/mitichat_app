import 'package:get/get.dart';

import 'my_profile_logic.dart';

class MyProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyProfileLogic());
  }
}
