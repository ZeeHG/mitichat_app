import 'package:get/get.dart';

import 'multimedia_logic.dart';

class ChatHistoryMultimediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChatHistoryMultimediaLogic());
  }
}
