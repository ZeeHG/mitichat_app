import 'package:get/get.dart';

import 'delete_user_logic.dart';

class DeleteUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DeleteUserLogic());
  }
}
