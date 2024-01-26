import 'package:get/get.dart';

import 'point_rules_logic.dart';

class PointRulesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PointRulesLogic());
  }
}
