import 'package:get/get.dart';

import 'ai_friend_list_logic.dart';

class AiFriendListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AiFriendListLogic());
  }
}
