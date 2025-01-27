import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../../routes/app_navigator.dart';
// import '../../../chat/chat_logic.dart';
import '../../../conversation/conversation_logic.dart';
import '../../select_contacts/select_contacts_logic.dart';
import '../user_profile_logic.dart';

class FriendSettingLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  final userProfilesLogic =
      Get.find<UserProfileLogic>(tag: GetTags.userProfile);
  late String userID;

  @override
  void onInit() {
    super.onInit();
    userID = Get.arguments['userID'];
  }

  void toggleBlacklist() {
    userProfilesLogic.userInfo.value.isBlacklist == true
        ? removeBlacklist()
        : addBlacklist();
  }

  /// 加入黑名单
  void addBlacklist() async {
    final confirm = await Get.dialog(
        CustomDialog(title: StrLibrary.areYouSureAddBlacklist));
    if (confirm) {
      await OpenIM.iMManager.friendshipManager.addBlacklist(
        userID: userProfilesLogic.userInfo.value.userID!,
      );
      userProfilesLogic.userInfo.update((val) {
        val?.isBlacklist = true;
      });
    }
  }

  /// 从黑名单移除
  void removeBlacklist() async {
    await OpenIM.iMManager.friendshipManager.removeBlacklist(
      userID: userProfilesLogic.userInfo.value.userID!,
    );
    userProfilesLogic.userInfo.update((val) {
      val?.isBlacklist = false;
    });
  }

  /// 解除好友关系
  void deleteFromFriendList() async {
    final confirm = await Get.dialog(CustomDialog(
      title: StrLibrary.areYouSureDelFriend,
      rightText: StrLibrary.delete,
    ));
    if (confirm) {
      await LoadingView.singleton.start(fn: () async {
        await OpenIM.iMManager.friendshipManager.deleteFriend(
          userID: userProfilesLogic.userInfo.value.userID!,
        );
        userProfilesLogic.userInfo.update((val) {
          val?.isFriendship = false;
        });
        final userIDList = [
          userProfilesLogic.userInfo.value.userID,
          OpenIM.iMManager.userID,
        ];
        userIDList.sort();
        final conversationID = 'si_${userIDList.join('_')}';
        // 删除会话
        await OpenIM.iMManager.conversationManager
            .deleteConversationAndDeleteAllMsg(conversationID: conversationID);
        // 删除会话列表数据
        conversationLogic.list
            .removeWhere((e) => e.conversationID == conversationID);

        userProfilesLogic.offAllWhenDelFriend == true
            ? AppNavigator.startBackMain()
            : Get.back();
      });
    }
  }

  recommendToFriend() async {
    // final isRegistered = Get.isRegistered<ChatLogic>(tag: GetTags.chat);
    // if (isRegistered) {
    //   final logic = Get.find<ChatLogic>(tag: GetTags.chat);
    //   logic.recommendFriendCarte(
    //       UserInfo.fromJson(userProfilesLogic.userInfo.value.toJson()));
    //   return;
    // }
    final result = await AppNavigator.startSelectContacts(
      action: SelAction.recommend,
      ex: '[${StrLibrary.carte}]${userProfilesLogic.userInfo.value.nickname}',
    );
    if (null != result) {
      final customEx = result['customEx'];
      final checkedList = result['checkedList'];
      for (var info in checkedList) {
        final userID = MitiUtils.convertCheckedToUserID(info);
        final groupID = MitiUtils.convertCheckedToGroupID(info);
        // 名片消息
        OpenIM.iMManager.messageManager.sendMessage(
          message: await OpenIM.iMManager.messageManager.createCardMessage(
            userID: userProfilesLogic.userInfo.value.userID!,
            nickname: userProfilesLogic.userInfo.value.showName,
            faceURL: userProfilesLogic.userInfo.value.faceURL,
          ),
          userID: userID,
          groupID: groupID,
          offlinePushInfo: Config.offlinePushInfo
            ..title = OpenIM.iMManager.userInfo.nickname ?? StrLibrary.friend
            ..desc = StrLibrary.defaultCardNotification,
        );
      }
    }
  }

  void setFriendRemark() => AppNavigator.startSetRemark();
}
