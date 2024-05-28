import 'package:get/get.dart';

import 'invite_friends _qrcode_logic.dart';

class InviteFriendsQrcodeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => InviteFriendsQrcodeLogic());
  }
}
