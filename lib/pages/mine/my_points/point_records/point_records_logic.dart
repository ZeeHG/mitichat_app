import 'dart:async';
import 'package:get/get.dart';

class PointRecordsLogic extends GetxController {
  final pointRecords = [{
    "name": "签到",
    "time": "2024-01-01",
    "point": 5
  },
    {"name": "签到", "time": "2024-01-01", "point": -5}
  ,
    {"name": "签到", "time": "2024-01-01", "point": 5}
  ,
    {"name": "签到", "time": "2024-01-01", "point": 5}
  ].obs;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
