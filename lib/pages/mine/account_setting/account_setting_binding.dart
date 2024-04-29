import 'package:get/get.dart';

import 'account_setting_logic.dart';

class AccountSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AccountSettingLogic());
  }
}
