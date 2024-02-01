import 'package:get/get.dart';
import 'training_bot_logic.dart';

class TrainingBotBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainingBotLogic());
  }
}
