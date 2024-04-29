import 'package:get/get.dart';

import 'preview_selected_picture_logic.dart';

class PreviewSelectedPictureBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviewSelectedPictureLogic());
  }
}
