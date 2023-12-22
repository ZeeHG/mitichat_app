import 'package:get/get.dart';

import 'search_chat_history_logic.dart';

class SearchChatHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchChatHistoryLogic());
  }
}
