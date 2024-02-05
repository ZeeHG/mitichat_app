import 'package:get/get.dart';

import 'search_my_ai_logic.dart';

class SearchMyAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchMyAiLogic());
  }
}
