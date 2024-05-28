import 'package:get/get.dart';

import 'miti_id_change_rule_logic.dart';

class MitiIDChangeRuleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MitiIDChangeRuleLogic());
  }
}
