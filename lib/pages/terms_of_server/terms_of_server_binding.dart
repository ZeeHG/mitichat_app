import 'package:get/get.dart';

import 'terms_of_server_logic.dart';

class TermsOfServerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TermsOfServerLogic());
  }
}
