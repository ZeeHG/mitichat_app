import 'package:get/get.dart';

import 'meeting_detail_logic.dart';

class MeetingDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MeetingDetailLogic());
  }
}
