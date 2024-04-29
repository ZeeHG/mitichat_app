import 'package:get/get.dart';

import 'user_black_list_logic.dart';

class UserBlacklistBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserBlacklistLogic());
  }
}
