import 'package:get/get.dart';

import 'reset_pwd_logic.dart';

class ResetPwdBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ResetPwdLogic());
  }
}
