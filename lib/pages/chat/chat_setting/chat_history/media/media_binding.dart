import 'package:get/get.dart';

import 'media_logic.dart';

class ChatHistoryMediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatHistoryMediaLogic());
  }
}
