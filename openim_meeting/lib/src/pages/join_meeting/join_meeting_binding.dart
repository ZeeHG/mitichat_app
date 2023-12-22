import 'package:get/get.dart';

import 'join_meeting_logic.dart';

class JoinMeetingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => JoinMeetingLogic());
  }
}
