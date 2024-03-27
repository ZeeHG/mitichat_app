import 'package:get/get.dart';

import '../../../routes/app_navigator.dart';

class CreateBotLogic extends GetxController {
  void changeBotInfo() => AppNavigator.startChangeBotInfo();
  void trainBot() => AppNavigator.startTrainingBot();
}
