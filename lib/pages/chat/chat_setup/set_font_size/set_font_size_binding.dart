import 'package:get/get.dart';

import 'set_font_size_logic.dart';

class SetFontSizeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetFontSizeLogic());
  }
}
