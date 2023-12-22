import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'user_work_moments_list_logic.dart';

class UserWorkMomentsListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserWorkMomentsListLogic(), tag: GetTags.userMoments);
  }
}
