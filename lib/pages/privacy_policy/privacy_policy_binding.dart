import 'package:get/get.dart';

import 'privacy_policy_logic.dart';

class PrivacyPolicyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => PrivacyPolicyLogic());
  }
}
