import 'package:get/get.dart';

import 'set_mute_for_member_logic.dart';

class SetMuteForGroupMemberBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SetMuteForGroupMemberLogic());
  }
}
