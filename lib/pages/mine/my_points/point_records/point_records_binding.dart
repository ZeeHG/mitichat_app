import 'package:get/get.dart';

import 'point_records_logic.dart';

class PointRecordsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PointRecordsLogic());
  }
}
