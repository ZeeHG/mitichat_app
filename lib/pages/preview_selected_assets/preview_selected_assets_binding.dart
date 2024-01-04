import 'package:get/get.dart';

import 'preview_selected_assets_logic.dart';

class PreviewSelectedAssetsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PreviewSelectedAssetsLogic());
  }
}
