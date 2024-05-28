import 'package:get/get.dart';

import 'dev_entry_logic.dart';

class DevEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => DevEntryLogic());
  }
}
