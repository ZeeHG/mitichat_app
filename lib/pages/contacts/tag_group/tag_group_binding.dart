import 'package:get/get.dart';

import 'tag_group_logic.dart';

class TagGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TagGroupLogic());
  }
}
