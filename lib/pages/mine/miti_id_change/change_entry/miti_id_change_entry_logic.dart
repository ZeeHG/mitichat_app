import 'dart:async';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';

class MitiIDChangeEntryLogic extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  mitiIDChange() {
    AppNavigator.startMitiIDChange();
  }
}
