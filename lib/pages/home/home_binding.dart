import 'package:get/get.dart';
import 'package:miti/pages/xhs/xhs_logic.dart';

import '../contacts/contacts_logic.dart';
import '../conversation/conversation_logic.dart';
import '../mine/mine_logic.dart';
import '../new_discover/new_discover_logic.dart';
import '../workbench/workbench_logic.dart';
import 'home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
    Get.lazyPut(() => ConversationLogic());
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => MineLogic());
    Get.lazyPut(() => NewDiscoverLogic());
    Get.lazyPut(() => WorkbenchLogic());
    Get.lazyPut(() => XhsLogic());
  }
}
