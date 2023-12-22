import 'package:get/get.dart';

import 'tag_list_logic.dart';

class SelectContactsFromTagBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SelectContactsFromTagLogic());
  }
}
