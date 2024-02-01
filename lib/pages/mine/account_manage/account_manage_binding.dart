import 'package:get/get.dart';

import 'account_manage_logic.dart';

class AccountManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountManageLogic());
  }
}
