import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../group_profile_panel/group_profile_panel_logic.dart';

class SendVerificationApplicationLogic extends GetxController {
  final inputCtrl = TextEditingController();
  String? userID;
  String? groupID;
  JoinGroupMethod? joinGroupMethod;

  bool get isEnterGroup => groupID != null;

  bool get isAddFriend => userID != null;

  @override
  void onInit() {
    userID = Get.arguments['userID'];
    groupID = Get.arguments['groupID'];
    joinGroupMethod = Get.arguments['joinGroupMethod'];
    super.onInit();
  }

  void send() async {
    if (isAddFriend) {
      _applyAddFriend();
    } else if (isEnterGroup) {
      _applyEnterGroup();
    }
  }

  _applyAddFriend() async {
    try {
      await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.friendshipManager.addFriend(
          userID: userID!,
          reason: inputCtrl.text.trim(),
        ),
      );
      Get.back();
      IMViews.showToast(StrLibrary.sendSuccessfully);
    } catch (_) {
      if (_ is PlatformException) {
        if (_.code == '${SDKErrorCode.refuseToAddFriends}') {
          IMViews.showToast(StrLibrary.canNotAddFriends);
          return;
        }
      }
      IMViews.showToast(StrLibrary.sendFailed);
    }
  }

  /// By Invitation = 2 , Search = 3 , QRCode  = 4
  _applyEnterGroup() {
    LoadingView.singleton
        .start(
          fn: () => OpenIM.iMManager.groupManager.joinGroup(
            groupID: groupID!,
            reason: inputCtrl.text.trim(),
            joinSource: joinGroupMethod == JoinGroupMethod.qrcode ? 4 : 3,
          ),
        )
        .then((value) => IMViews.showToast(StrLibrary.sendSuccessfully))
        .then((value) => Get.back())
        .catchError((e) => IMViews.showToast(StrLibrary.sendFailed));
  }
}
