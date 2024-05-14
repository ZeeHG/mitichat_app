import 'package:get/get.dart';

import 'active_account_entry_logic.dart';

class ActiveAccountEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ActiveAccountEntryLogic());
  }
}
