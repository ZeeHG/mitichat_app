import 'package:get/get.dart';

import 'preview_video_logic.dart';

class PreviewVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviewVideoLogic());
  }
}
