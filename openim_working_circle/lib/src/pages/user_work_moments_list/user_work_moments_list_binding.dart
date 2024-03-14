import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'user_work_moments_list_logic.dart';

class UserWorkMomentsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserWorkMomentsListLogic(), tag: GetTags.userMoments);
  }
}
