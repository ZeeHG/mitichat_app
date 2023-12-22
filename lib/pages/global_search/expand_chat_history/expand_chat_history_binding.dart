import 'package:get/get.dart';

import 'expand_chat_history_logic.dart';

class ExpandChatHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ExpandChatHistoryLogic());
  }
}
