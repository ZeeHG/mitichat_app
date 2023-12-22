import 'package:get/get.dart';

import 'preview_selected_video_logic.dart';

class PreviewSelectedVideoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviewSelectedVideoLogic());
  }
}
