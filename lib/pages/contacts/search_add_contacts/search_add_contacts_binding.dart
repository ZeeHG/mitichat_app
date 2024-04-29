import 'package:get/get.dart';

import 'search_add_contacts_logic.dart';

class SearchAddContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchAddContactsLogic());
  }
}
