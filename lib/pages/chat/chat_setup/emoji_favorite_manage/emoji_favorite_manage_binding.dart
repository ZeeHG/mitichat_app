import 'package:get/get.dart';

import 'emoji_favorite_manage_logic.dart';

class EmojiFavoriteManageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmojiFavoriteManageLogic());
  }
}
