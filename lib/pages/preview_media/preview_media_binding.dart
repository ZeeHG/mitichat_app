import 'package:get/get.dart';

import 'preview_media_logic.dart';

class PreviewMediaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviewMediaLogic());
  }
}
