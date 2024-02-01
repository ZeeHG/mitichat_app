import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../../routes/app_navigator.dart';
import '../../../chat/chat_logic.dart';
import '../../../conversation/conversation_logic.dart';
import '../../select_contacts/select_contacts_logic.dart';
import '../user_profile _panel_logic.dart';

class FriendSetupLogic extends GetxController {
  final conversationLogic = Get.find<ConversationLogic>();
  final userProfilesLogic = Get.find<UserProfilePanelLogic>(tag: GetTags.userProfile);
  late String userID;

  @override
  void onInit() {
    userID = Get.arguments['userID'];
    super.onInit();
  }

  void toggleBlacklist() {
    if (userProfilesLogic.userInfo.value.isBlacklist == true) {
      removeBlacklist();
    } else {
      addBlacklist();
    }
  }

  /// 加入黑名单
  void addBlacklist() async {
    var confirm = await Get.dialog(CustomDialog(title: StrRes.areYouSureAddBlacklist));
    if (confirm == true) {
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
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.areYouSureDelFriend,
      rightText: StrRes.delete,
    ));
    if (confirm) {
      await LoadingView.singleton.wrap(asyncFunction: () async {
        await OpenIM.iMManager.friendshipManager.deleteFriend(
          userID: userProfilesLogic.userInfo.value.userID!,
        );
        userProfilesLogic.userInfo.update((val) {
          val?.isFriendship = false;
        });
        // final conversationID = await OpenIM.iMManager.conversationManager
        //     .getConversationIDBySessionType(
        //   sourceID: userInfo.value.userID!,
        //   sessionType: ConversationType.single,
        // );
        final userIDList = [
          userProfilesLogic.userInfo.value.userID,
          OpenIM.iMManager.userID,
        ];
        userIDList.sort();
        final conversationID = 'si_${userIDList.join('_')}';
        // 删除会话
        await OpenIM.iMManager.conversationManager.deleteConversationAndDeleteAllMsg(conversationID: conversationID);
        // 删除会话列表数据
        conversationLogic.list.removeWhere((e) => e.conversationID == conversationID);
      });
      // 如果从聊天窗口查看用户资料
      if (userProfilesLogic.offAllWhenDelFriend == true) {
        AppNavigator.startBackMain();
      } else {
        Get.back();
      }
    }
  }

  recommendToFriend() async {
    final isRegistered = Get.isRegistered<ChatLogic>(tag: GetTags.chat);
    if (isRegistered) {
      final logic = Get.find<ChatLogic>(tag: GetTags.chat);
      logic.recommendFriendCarte(UserInfo.fromJson(userProfilesLogic.userInfo.value.toJson()));
      return;
    }
    final result = await AppNavigator.startSelectContacts(
      action: SelAction.recommend,
      ex: '[${StrRes.carte}]${userProfilesLogic.userInfo.value.nickname}',
    );
    if (null != result) {
      final customEx = result['customEx'];
      final checkedList = result['checkedList'];
      for (var info in checkedList) {
        final userID = IMUtils.convertCheckedToUserID(info);
        final groupID = IMUtils.convertCheckedToGroupID(info);
        if (customEx is String && customEx.isNotEmpty) {
          // 推荐备注消息
          OpenIM.iMManager.messageManager.sendMessage(
            message: await OpenIM.iMManager.messageManager.createTextMessage(
              text: customEx,
            ),
            userID: userID,
            groupID: groupID,
            offlinePushInfo: Config.offlinePushInfo,
          );
        }
        // 名片消息
        OpenIM.iMManager.messageManager.sendMessage(
          message: await OpenIM.iMManager.messageManager.createCardMessage(
            userID: userProfilesLogic.userInfo.value.userID!,
            nickname: userProfilesLogic.userInfo.value.showName,
            faceURL: userProfilesLogic.userInfo.value.faceURL,
          ),
          userID: userID,
          groupID: groupID,
          offlinePushInfo: Config.offlinePushInfo,
        );
      }
    }
  }

  void setFriendRemark() => AppNavigator.startSetFriendRemark();
}
