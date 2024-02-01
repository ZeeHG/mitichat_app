import 'package:get/get.dart';

import 'my_points_logic.dart';

class MyPointsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyPointsLogic());
  }
}
