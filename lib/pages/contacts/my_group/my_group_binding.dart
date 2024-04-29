import 'package:get/get.dart';

import 'my_group_logic.dart';

class MyGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyGroupLogic());
  }
}
