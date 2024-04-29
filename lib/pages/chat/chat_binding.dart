import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'chat_logic.dart';

class ChatBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatLogic(), tag: GetTags.chat);
    // Get.put(ChatLogic(), tag: ChatGetTags.caches.last, permanent: false);
  }
}
