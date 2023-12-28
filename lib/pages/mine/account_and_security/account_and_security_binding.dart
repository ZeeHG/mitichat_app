import 'package:get/get.dart';

import 'account_and_security_logic.dart';

class AccountAndSecurityBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountAndSecurityLogic());
  }
}
