import 'dart:async';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';

class MyPointsLogic extends GetxController {
  final aaa = "".obs;

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

  pointRules() => AppNavigator.startPointRules();

  pointRecords() => AppNavigator.startPointRecords();

  inviteRecords() => AppNavigator.startInviteRecords();
}
