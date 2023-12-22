import 'package:get/get.dart';

import 'set_background_logic.dart';

class SetBackgroundImageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetBackgroundImageLogic());
  }
}
