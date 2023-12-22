import 'package:get/get.dart';

import 'preview_chat_history_logic.dart';

class PreviewChatHistoryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviewChatHistoryLogic());
  }
}
