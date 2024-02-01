import 'package:get/get.dart';

import 'preview_picture_logic.dart';

class PreviewPictureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviewPictureLogic());
  }
}
