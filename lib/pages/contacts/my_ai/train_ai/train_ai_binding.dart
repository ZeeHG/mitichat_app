import 'package:get/get.dart';
import 'train_ai_logic.dart';

class TrainAiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => TrainAiLogic());
  }
}
