import 'package:get/get.dart';

import 'who_can_watch_logic.dart';

class WhoCanWatchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WhoCanWatchLogic());
  }
}
