import 'package:get/get.dart';
import 'create_bot_logic.dart';

class CreateBotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateBotLogic());
  }
}
