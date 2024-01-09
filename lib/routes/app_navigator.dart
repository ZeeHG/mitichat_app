import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/pages/mine/phone_email_change/phone_email_change_logic.dart';
import 'package:openim_common/openim_common.dart';

import '../pages/chat/chat_setup/search_chat_history/multimedia/multimedia_logic.dart';
import '../pages/chat/group_setup/edit_name/edit_name_logic.dart';
import '../pages/chat/group_setup/group_member_list/group_member_list_logic.dart';
import '../pages/contacts/add_by_search/add_by_search_logic.dart';
import '../pages/contacts/group_profile_panel/group_profile_panel_logic.dart';
import '../pages/contacts/select_contacts/select_contacts_logic.dart';
import '../pages/mine/edit_my_info/edit_my_info_logic.dart';
import 'app_pages.dart';

class AppNavigator {
  AppNavigator._();

  static void startLogin() {
    Get.offAllNamed(AppRoutes.login);
  }

  static void startBackLogin() {
    Get.until((route) => Get.currentRoute == AppRoutes.login);
  }

  static void startMain({bool isAutoLogin = false, int index = 0}) {
    Get.offAllNamed(
      AppRoutes.home,
      arguments: {'isAutoLogin': isAutoLogin, 'index': index},
    );
  }

  static void startSplashToMain({bool isAutoLogin = false}) {
    Get.offAndToNamed(
      AppRoutes.home,
      arguments: {'isAutoLogin': isAutoLogin},
    );
  }

  static void startBackMain() {
    Get.until((route) => Get.currentRoute == AppRoutes.home);
  }

  static startOANtfList({required ConversationInfo info}) {
    return Get.toNamed(AppRoutes.oaNotificationList, arguments: info);
  }

  /// 聊天页
  static Future<T?>? startChat<T>({
    required ConversationInfo conversationInfo,
    bool offUntilHome = true,
    String? draftText,
    Message? searchMessage,
  }) async {
    GetTags.createChatTag();

    final arguments = {
      'draftText': draftText,
      'conversationInfo': conversationInfo,
      'searchMessage': searchMessage,
    };

    return offUntilHome
        ? Get.offNamedUntil(
            AppRoutes.chat,
            (route) => route.settings.name == AppRoutes.home,
            arguments: arguments,
          )
        : Get.toNamed(
            AppRoutes.chat,
            arguments: arguments,
            preventDuplicates: false,
          );
  }

  static startMyQrcode() => Get.toNamed(AppRoutes.myQrcode);

  static startFavoriteMange() => Get.toNamed(AppRoutes.favoriteManage);

  static startAddContactsMethod() => Get.toNamed(AppRoutes.addContactsMethod);

  static startScan() => Permissions.camera(() => Get.to(
        () => const QrcodeView(),
        transition: Transition.cupertino,
        popGesture: true,
      ));

  static startAddContactsBySearch(
          {required SearchType searchType, String? appBarTitle}) =>
      Get.toNamed(
        AppRoutes.addContactsBySearch,
        arguments: {"searchType": searchType, appBarTitle: appBarTitle},
      );

  static startUserProfilePane({
    required String userID,
    String? groupID,
    String? nickname,
    String? faceURL,
    bool offAllWhenDelFriend = false,
    bool offAndToNamed = false,
  }) {
    GetTags.createUserProfileTag();

    final arguments = {
      'groupID': groupID,
      'userID': userID,
      'nickname': nickname,
      'faceURL': faceURL,
      'offAllWhenDelFriend': offAllWhenDelFriend,
    };

    return offAndToNamed
        ? Get.offAndToNamed(AppRoutes.userProfilePanel, arguments: arguments)
        : Get.toNamed(
            AppRoutes.userProfilePanel,
            arguments: arguments,
            preventDuplicates: false,
          );
  }

  static startPersonalInfo({
    required String userID,
  }) =>
      Get.toNamed(AppRoutes.personalInfo, arguments: {
        'userID': userID,
      });

  static startFriendSetup({
    required String userID,
  }) =>
      Get.toNamed(AppRoutes.friendSetup, arguments: {
        'userID': userID,
      });

  static startSetFriendRemark() =>
      Get.toNamed(AppRoutes.setFriendRemark, arguments: {});

  static startSendVerificationApplication({
    String? userID,
    String? groupID,
    JoinGroupMethod? joinGroupMethod,
  }) =>
      Get.toNamed(AppRoutes.sendVerificationApplication, arguments: {
        'joinGroupMethod': joinGroupMethod,
        'userID': userID,
        'groupID': groupID,
      });

  static startGroupProfilePanel({
    required String groupID,
    required JoinGroupMethod joinGroupMethod,
    bool offAndToNamed = false,
  }) =>
      offAndToNamed
          ? Get.offAndToNamed(AppRoutes.groupProfilePanel, arguments: {
              'joinGroupMethod': joinGroupMethod,
              'groupID': groupID,
            })
          : Get.toNamed(AppRoutes.groupProfilePanel, arguments: {
              'joinGroupMethod': joinGroupMethod,
              'groupID': groupID,
            });

  static startSetMuteForGroupMember({
    required String groupID,
    required String userID,
  }) =>
      Get.toNamed(AppRoutes.setMuteForGroupMember, arguments: {
        'groupID': groupID,
        'userID': userID,
      });

  static startMyInfo() => Get.toNamed(AppRoutes.myInfo);

  static startEditMyInfo({
    EditAttr attr = EditAttr.nickname,
  }) =>
      Get.toNamed(AppRoutes.editMyInfo, arguments: {'editAttr': attr});

  static startAccountSetup() => Get.toNamed(AppRoutes.accountSetup);

  static startBlacklist() => Get.toNamed(AppRoutes.blacklist);

  static startLanguageSetup() => Get.toNamed(AppRoutes.languageSetup);

  static startUnlockSetup() => Get.toNamed(AppRoutes.unlockSetup);

  static startChangePassword() => Get.toNamed(AppRoutes.changePassword);

  static startDeleteUser() => Get.toNamed(AppRoutes.deleteUser);

  static startAccountAndSecurity() => Get.toNamed(AppRoutes.accountAndSecurity);

  static startPhoneEmailChange({
    PhoneEmailChangeType type = PhoneEmailChangeType.phone,
  }) =>
      Get.toNamed(AppRoutes.phoneEmailChange, arguments: {'type': type});

  static startPhoneEmailChangeDetail({
    PhoneEmailChangeType type = PhoneEmailChangeType.phone,
  }) =>
      Get.toNamed(AppRoutes.phoneEmailChangeDetail, arguments: {'type': type});

  static startAboutUs() => Get.toNamed(AppRoutes.aboutUs);

  static startChatSetup({
    required ConversationInfo conversationInfo,
  }) =>
      Get.toNamed(AppRoutes.chatSetup, arguments: {
        'conversationInfo': conversationInfo,
      });

  static startSetBackgroundImage() => Get.toNamed(AppRoutes.setBackgroundImage);

  static startSetFontSize() => Get.toNamed(AppRoutes.setFontSize);

  static startSearchChatHistory({
    required ConversationInfo conversationInfo,
  }) =>
      Get.toNamed(AppRoutes.searchChatHistory, arguments: {
        'conversationInfo': conversationInfo,
      });

  static startSearchChatHistoryMultimedia({
    required ConversationInfo conversationInfo,
    MultimediaType multimediaType = MultimediaType.picture,
  }) =>
      Get.toNamed(AppRoutes.searchChatHistoryMultimedia, arguments: {
        'conversationInfo': conversationInfo,
        'multimediaType': multimediaType,
      });

  static startSearchChatHistoryFile({
    required ConversationInfo conversationInfo,
  }) =>
      Get.toNamed(AppRoutes.searchChatHistoryFile, arguments: {
        'conversationInfo': conversationInfo,
      });

  static startPreviewChatHistory({
    required ConversationInfo conversationInfo,
    required Message message,
  }) =>
      Get.toNamed(AppRoutes.previewChatHistory, arguments: {
        'conversationInfo': conversationInfo,
        'message': message,
      });

  static startGroupChatSetup({
    required ConversationInfo conversationInfo,
  }) =>
      Get.toNamed(AppRoutes.groupChatSetup, arguments: {
        'conversationInfo': conversationInfo,
      });

  static startGroupManage({
    required GroupInfo groupInfo,
  }) =>
      Get.toNamed(AppRoutes.groupManage, arguments: {
        'groupInfo': groupInfo,
      });

  static startEditGroupName({
    required EditNameType type,
  }) =>
      Get.toNamed(AppRoutes.editGroupName, arguments: {
        'type': type,
      });

  static startEditGroupAnnouncement({required String groupID}) =>
      Get.toNamed(AppRoutes.editGroupAnnouncement, arguments: groupID);

  static Future<T?>? startGroupMemberList<T>({
    required GroupInfo groupInfo,
    GroupMemberOpType opType = GroupMemberOpType.view,
  }) =>
      Get.toNamed(AppRoutes.groupMemberList, arguments: {
        'groupInfo': groupInfo,
        'opType': opType,
      });

  static startSearchGroupMember({
    required GroupInfo groupInfo,
    GroupMemberOpType opType = GroupMemberOpType.view,
  }) =>
      Get.toNamed(AppRoutes.searchGroupMember, arguments: {
        'groupInfo': groupInfo,
        'opType': opType,
      });

  static startGroupQrcode() => Get.toNamed(AppRoutes.groupQrcode);

  static startFriendRequests() => Get.toNamed(AppRoutes.friendRequests);

  static startProcessFriendRequests({
    required FriendApplicationInfo applicationInfo,
  }) =>
      Get.toNamed(AppRoutes.processFriendRequests, arguments: {
        'applicationInfo': applicationInfo,
      });

  static startGroupRequests() => Get.toNamed(AppRoutes.groupRequests);

  static startProcessGroupRequests({
    required GroupApplicationInfo applicationInfo,
  }) =>
      Get.toNamed(AppRoutes.processGroupRequests, arguments: {
        'applicationInfo': applicationInfo,
      });

  static startFriendList() => Get.toNamed(AppRoutes.friendList);

  static startGroupList() => Get.toNamed(AppRoutes.groupList);

  static startGroupReadList(String conversationID, String clientMsgID) =>
      Get.toNamed(AppRoutes.groupReadList, arguments: {
        "conversationID": conversationID,
        "clientMsgID": clientMsgID
      });

  static startSearchFriend() => Get.toNamed(AppRoutes.searchFriend);

  static startSearchGroup() => Get.toNamed(AppRoutes.searchGroup);

  static startSelectContacts({
    required SelAction action,
    List<String>? defaultCheckedIDList,
    List<dynamic>? checkedList,
    List<String>? excludeIDList,
    bool openSelectedSheet = false,
    String? groupID,
    String? ex,
    String? appBarTitle,
  }) =>
      Get.toNamed(AppRoutes.selectContacts, arguments: {
        'action': action,
        'defaultCheckedIDList': defaultCheckedIDList,
        'checkedList': IMUtils.convertCheckedListToMap(checkedList),
        'excludeIDList': excludeIDList,
        'openSelectedSheet': openSelectedSheet,
        'groupID': groupID,
        'ex': ex,
        "appBarTitle": appBarTitle
      });

  static startSelectContactsFromFriends() =>
      Get.toNamed(AppRoutes.selectContactsFromFriends);

  static startSelectContactsFromGroup() =>
      Get.toNamed(AppRoutes.selectContactsFromGroup);

  static startSelectContactsFromSearchFriends() =>
      Get.toNamed(AppRoutes.selectContactsFromSearchFriends);

  static startSelectContactsFromSearchGroup() =>
      Get.toNamed(AppRoutes.selectContactsFromSearchGroup);

  static startSelectContactsFromSearch() =>
      Get.toNamed(AppRoutes.selectContactsFromSearch);

  static startCreateGroup({
    List<UserInfo> defaultCheckedList = const [],
    String? appBarTitle,
  }) async {
    final result = await startSelectContacts(
        action: SelAction.crateGroup,
        defaultCheckedIDList: defaultCheckedList.map((e) => e.userID!).toList(),
        appBarTitle: appBarTitle);
    final list = IMUtils.convertSelectContactsResultToUserInfo(result);
    if (list is List<UserInfo>) {
      return Get.toNamed(
        AppRoutes.createGroup,
        arguments: {
          'checkedList': list,
          'defaultCheckedList': defaultCheckedList
        },
      );
    }
    return null;
  }

  static startGlobalSearch() => Get.toNamed(AppRoutes.globalSearch);

  static startExpandChatHistory({
    required SearchResultItems searchResultItems,
    required String defaultSearchKey,
  }) =>
      Get.toNamed(AppRoutes.expandChatHistory, arguments: {
        'searchResultItems': searchResultItems,
        'defaultSearchKey': defaultSearchKey,
      });

  static startCallRecords() => Get.toNamed(AppRoutes.callRecords);

  static startRegister() => Get.toNamed(AppRoutes.register);

  static void startVerifyPhone({
    String? phoneNumber,
    String? email,
    required String areaCode,
    required int usedFor,
    String? invitationCode,
  }) =>
      Get.toNamed(AppRoutes.verifyPhone, arguments: {
        'phoneNumber': phoneNumber,
        'email': email,
        'areaCode': areaCode,
        'usedFor': usedFor,
        'invitationCode': invitationCode
      });

  /// [usedFor] 1：注册，2：重置密码
  static void startSetPassword({
    String? phoneNumber,
    String? email,
    required String areaCode,
    required int usedFor,
    required String verificationCode,
    String? invitationCode,
  }) =>
      Get.toNamed(AppRoutes.setPassword, arguments: {
        'phoneNumber': phoneNumber,
        'email': email,
        'areaCode': areaCode,
        'usedFor': usedFor,
        'verificationCode': verificationCode,
        'invitationCode': invitationCode
      });

  static void startSetSelfInfo({
    required String phoneNumber,
    required String areaCode,
    required password,
    required int usedFor,
    required String verificationCode,
    String? invitationCode,
  }) =>
      Get.toNamed(AppRoutes.setSelfInfo, arguments: {
        'phoneNumber': phoneNumber,
        'areaCode': areaCode,
        'password': password,
        'usedFor': usedFor,
        'verificationCode': verificationCode,
        'invitationCode': invitationCode
      });

  static startForgetPassword() => Get.toNamed(AppRoutes.forgetPassword);

  /// [usedFor] 1：注册，2：重置密码 3：登录
  static void startResetPassword({
    String? phoneNumber,
    String? email,
    required String areaCode,
    required String verificationCode,
  }) =>
      Get.toNamed(AppRoutes.resetPassword, arguments: {
        'phoneNumber': phoneNumber,
        'email': email,
        'areaCode': areaCode,
        'usedFor': 2,
        'verificationCode': verificationCode,
      });

  static startTagGroup() => Get.toNamed(AppRoutes.tagGroup);

  static startCreateBot() => Get.toNamed(AppRoutes.createBot);

  static startBot() => Get.toNamed(AppRoutes.bot);

  static startChangeBotInfo() => Get.toNamed(AppRoutes.changeBotInfo);

  static startTrainingBot() => Get.toNamed(AppRoutes.trainingBot);

  static startCreateTagGroup({TagInfo? tagInfo}) =>
      Get.toNamed(AppRoutes.createTagGroup, arguments: {'tagInfo': tagInfo});

  static startSelectContactsFromTag() =>
      Get.toNamed(AppRoutes.selectContactsFromTag);

  static startNotificationIssued() =>
      Get.toNamed(AppRoutes.tagNotificationIssued);

  static startNewBuildNotification() =>
      Get.toNamed(AppRoutes.buildTagNotification);

  static startNotificationDetail({required TagNotification notification}) =>
      Get.toNamed(
        AppRoutes.tagNotificationDetail,
        arguments: {"notification": notification},
      );

  static startDiscover() => Get.toNamed(AppRoutes.discover);

  static startComplaint({
    required String userID,
  }) =>
      Get.toNamed(
        AppRoutes.complaint,
        arguments: {"userID": userID},
      );

  static startPreviewSelectedAssetsPage({
    required dynamic assetsLogic,
    required int currentIndex,
  }) =>
      Get.toNamed(
        AppRoutes.previewSelectedAssets,
        arguments: {"assetsLogic": assetsLogic, "currentIndex": currentIndex},
      );

  static startTermsOfServer() => Get.toNamed(AppRoutes.termsOfServer);

  static startPrivacyPolicy() => Get.toNamed(AppRoutes.privacyPolicy);

  static startFriendPermissions({required String userID}) =>
      Get.toNamed(AppRoutes.friendPermissions, arguments: {"userID": userID});

  static startRecentRequests() => Get.toNamed(AppRoutes.recentRequests);
}
