import 'package:get/get.dart';

import 'miti_id_change_logic.dart';

class MitiIDChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MitiIDChangeLogic());
  }
}
