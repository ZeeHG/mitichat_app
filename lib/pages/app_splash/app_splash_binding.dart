import 'package:get/get.dart';

import 'app_splash_logic.dart';

class AppSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AppSplashLogic());
  }
}
