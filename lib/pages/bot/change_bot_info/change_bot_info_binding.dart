import 'package:get/get.dart';
import 'change_bot_info_logic.dart';

class ChangeBotInfoBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChangeBotInfoLogic());
  }
}
