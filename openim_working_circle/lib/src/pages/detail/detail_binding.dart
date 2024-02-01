import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'detail_logic.dart';

class WorkMomentsDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => WorkMomentsDetailLogic(), tag: GetTags.momentsDetail);
  }
}
