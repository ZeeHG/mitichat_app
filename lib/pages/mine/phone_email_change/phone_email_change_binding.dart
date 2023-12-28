import 'package:get/get.dart';

import 'phone_email_change_logic.dart';

class PhoneEmailChangeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhoneEmailChangeLogic());
  }
}
