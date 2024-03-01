import 'package:get/get.dart';

import 'xhs_moment_detail_logic.dart';

class XhsMomentDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => XhsMomentDetailLogic());
  }
}
