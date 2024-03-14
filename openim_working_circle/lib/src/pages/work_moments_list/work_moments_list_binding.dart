import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'work_moments_list_logic.dart';

class WorkMomentsListBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(WorkMomentsListLogic());
    Get.lazyPut(() => WorkMomentsListLogic(), tag: GetTags.moments);
    // Get.create(() => WorkMomentsListLogic(), permanent: false);
  }
}
