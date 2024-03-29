import 'package:get/get.dart';
import 'package:miti/pages/conversation/conversation_logic.dart';

import 'contacts_logic.dart';

class ContactsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ContactsLogic());
    Get.lazyPut(() => ConversationLogic());
  }
}
