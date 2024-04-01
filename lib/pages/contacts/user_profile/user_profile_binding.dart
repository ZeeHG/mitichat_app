import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'user_profile_logic.dart';

class UserProfileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfileLogic(), tag: GetTags.userProfile);
  }
}
