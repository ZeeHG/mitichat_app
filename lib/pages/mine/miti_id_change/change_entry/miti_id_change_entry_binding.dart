import 'package:get/get.dart';

import 'miti_id_change_entry_logic.dart';

class MitiIDChangeEntryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MitiIDChangeEntryLogic());
  }
}
