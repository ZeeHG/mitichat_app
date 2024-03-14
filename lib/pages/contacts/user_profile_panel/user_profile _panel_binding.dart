import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'user_profile _panel_logic.dart';

class UserProfilePanelBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => UserProfilePanelLogic(), tag: GetTags.userProfile);
  }
}
