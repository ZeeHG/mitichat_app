import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'detail_logic.dart';

class MomentsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MomentsDetailLogic(), tag: GetTags.momentsDetail);
  }
}
