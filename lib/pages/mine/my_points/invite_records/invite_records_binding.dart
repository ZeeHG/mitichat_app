import 'package:get/get.dart';

import 'invite_records_logic.dart';

class InviteRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteRecordsLogic());
  }
}
