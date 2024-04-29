import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

class UserBlacklistLogic extends GetxController {
  final blacklist = <BlacklistInfo>[].obs;

  void _getUserBlacklist() async {
    var list = await OpenIM.iMManager.friendshipManager.getBlacklist();
    blacklist.addAll(list);
  }

  removeUser(BlacklistInfo info) async {
    await OpenIM.iMManager.friendshipManager.removeBlacklist(
      userID: info.userID!,
    );
    blacklist.remove(info);
  }

  @override
  void onReady() {
    _getUserBlacklist();
    super.onReady();
  }
}
