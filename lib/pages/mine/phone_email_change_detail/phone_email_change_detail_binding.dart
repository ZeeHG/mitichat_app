import 'package:get/get.dart';

import 'phone_email_change_detail_logic.dart';

class PhoneEmailChangeDetailBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PhoneEmailChangeDetailLogic());
  }
}
