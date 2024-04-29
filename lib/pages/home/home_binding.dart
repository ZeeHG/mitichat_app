import 'package:get/get.dart';
import 'package:miti/pages/xhs/xhs_logic.dart';
import '../contacts/contacts_logic.dart';
import '../conversation/conversation_logic.dart';
import '../mine/mine_logic.dart';
import 'home_logic.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic(), fenix: true);
    Get.lazyPut(() => ConversationLogic(), fenix: true);
    Get.lazyPut(() => ContactsLogic(), fenix: true);
    Get.lazyPut(() => MineLogic(), fenix: true);
    Get.lazyPut(() => XhsLogic(), fenix: true);
  }
}
