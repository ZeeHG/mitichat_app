import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../group_profile/group_profile_logic.dart';

class SendApplicationLogic extends GetxController {
  final inputCtrl = TextEditingController();
  String? userID;
  String? groupID;
  JoinGroupMethod? joinGroupMethod;

  bool get isEnterGroup => groupID != null;

  bool get isAddFriend => userID != null;

  @override
  void onInit() {
    super.onInit();
    userID = Get.arguments['userID'];
    groupID = Get.arguments['groupID'];
    joinGroupMethod = Get.arguments['joinGroupMethod'];
  }

  void send() async {
    if (isAddFriend) {
      _addFriend();
    } else if (isEnterGroup) {
      _enterGroup();
    }
  }

  _addFriend() async {
    try {
      await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.friendshipManager.addFriend(
          userID: userID!,
          reason: inputCtrl.text.trim(),
        ),
      );
      Get.back();
      showToast(StrLibrary.sendSuccessfully);
    } catch (e) {
      if (e is PlatformException) {
        if (e.code == '${SDKErrorCode.refuseToAddFriends}') {
          showToast(StrLibrary.canNotAddFriends);
          return;
        }
      }
      showToast(StrLibrary.sendFailed);
    }
  }

  /// By Invitation = 2 , Search = 3 , QRCode  = 4
  _enterGroup() async {
    try {
      await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.groupManager.joinGroup(
          groupID: groupID!,
          reason: inputCtrl.text.trim(),
          joinSource: joinGroupMethod == JoinGroupMethod.qrcode ? 4 : 3,
        ),
      );
      Get.back();
      showToast(StrLibrary.sendSuccessfully);
    } catch (e) {
      showToast(StrLibrary.sendFailed);
    }
  }
}
