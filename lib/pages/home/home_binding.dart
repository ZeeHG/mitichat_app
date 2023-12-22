import 'package:get/get.dart';

import '../contacts/contacts_logic.dart';
import '../conversation/conversation_logic.dart';
import '../mine/mine_logic.dart';
import '../workbench/workbench_logic.dart';
import 'home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => ConversationLogic());
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => WorkbenchLogic());
  }
}
