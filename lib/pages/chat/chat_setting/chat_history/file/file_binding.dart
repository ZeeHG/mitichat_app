import 'package:get/get.dart';

import 'file_logic.dart';

class ChatHistoryFileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatHistoryFileLogic());
  }
}
