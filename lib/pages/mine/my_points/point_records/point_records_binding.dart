import 'package:get/get.dart';

import 'point_records_logic.dart';

class RecentRequestsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PointRecordsLogic());
  }
}
