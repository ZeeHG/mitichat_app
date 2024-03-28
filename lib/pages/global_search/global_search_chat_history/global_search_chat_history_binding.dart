import 'package:get/get.dart';

import 'global_search_chat_history_logic.dart';

class GlobalSearchChatHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => GlobalSearchChatHistoryLogic());
  }
}
