import 'package:get/get.dart';

import 'search_ai_friend_logic.dart';

class SearchAiFriendBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => SearchAiFriendLogic());
  }
}
