import 'package:get/get.dart';
import 'bot_logic.dart';

class BotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => BotLogic());
  }
}
