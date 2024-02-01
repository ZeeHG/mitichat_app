import 'package:get/get.dart';

import 'create_tag_group_logic.dart';

class CreateTagGroupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateTagGroupLogic());
  }
}
