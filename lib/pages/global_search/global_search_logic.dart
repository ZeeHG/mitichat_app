import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../conversation/conversation_logic.dart';

class GlobalSearchLogic extends CommonSearchLogic {
  final conversationLogic = Get.find<ConversationLogic>();
  final textMessageRefreshCtrl = RefreshController();
  final fileMessageRefreshCtrl = RefreshController();
  final contactsList = <UserInfo>[].obs;
  final groupList = <GroupInfo>[].obs;
  final textMessageList = <SearchResultItems>[].obs;
  String curSearchText = "";

  // final fileSearchResultItems = <SearchResultItems>[].obs;
  final fileMessageList = <Message>[].obs;
  final index = 0.obs;
  final tabs = [
    StrLibrary.globalSearchAll,
    StrLibrary.globalSearchContacts,
    StrLibrary.globalSearchGroup,
    StrLibrary.globalSearchChatHistory,
    StrLibrary.globalSearchChatFile,
  ];

  int textMessagePageIndex = 1;
  int fileMessagePageIndex = 1;
  int count = 20;

  switchTab(int index) {
    this.index.value = index;
  }

  @override
  void clearList() {
    contactsList.clear();
    groupList.clear();
    textMessageList.clear();
    fileMessageList.clear();
  }

  bool get isAllEmpty =>
      searchKey.isNotEmpty &&
      contactsList.isEmpty &&
      groupList.isEmpty &&
      textMessageList.isEmpty &&
      fileMessageList.isEmpty;

  search() async {
    searchKey.value = searchCtrl.text.trim();
    curSearchText = searchKey.value;
    final textBeforeSearch = curSearchText;
    if (curSearchText.isEmpty) {
      return clearList();
    }
    final result = await LoadingView.singleton.start(
        fn: () => Future.wait([
              searchFriend(),
              searchGroup(),
              searchMessage(
                typeList: [MessageType.text, MessageType.atText],
                pageIndex: textMessagePageIndex = 1,
                count: count,
              ),
              searchMessage(
                typeList: [MessageType.file],
                pageIndex: fileMessagePageIndex = 1,
                count: count,
              ),
            ]));
    if (curSearchText != textBeforeSearch) return;
    final friendList = (result[0] as List<FriendInfo>).map((e) =>
        UserInfo(userID: e.userID, nickname: (e.remark !=null && e.remark!.isNotEmpty)? e.remark : e.nickname, faceURL: e.faceURL));
    final gList = result[1] as List<GroupInfo>;
    final textMessageResult = (result[2] as SearchResult).searchResultItems;
    final fileMessageResult = (result[3] as SearchResult).searchResultItems;

    clearList();

    contactsList.assignAll(friendList);
    groupList.assignAll(gList);
    textMessageList.assignAll(textMessageResult ?? []);
    fileMessageList.clear();
    if (null != fileMessageResult && fileMessageResult.isNotEmpty) {
      for (var element in fileMessageResult) {
        fileMessageList.addAll(element.messageList!);
      }
    }
    if ((textMessageResult ?? []).length < count) {
      textMessageRefreshCtrl.loadNoData();
    } else {
      textMessageRefreshCtrl.loadComplete();
    }
    if ((fileMessageResult ?? []).length < count) {
      fileMessageRefreshCtrl.loadNoData();
    } else {
      fileMessageRefreshCtrl.loadComplete();
    }
  }

  void loadTextMessage() async {
    final result = await searchMessage(
        typeList: [MessageType.text, MessageType.atText],
        pageIndex: ++textMessagePageIndex,
        count: count);
    final textMessageResult = result.searchResultItems;
    textMessageList.addAll(textMessageResult ?? []);
    if ((textMessageResult ?? []).length < count) {
      textMessageRefreshCtrl.loadNoData();
    } else {
      textMessageRefreshCtrl.loadComplete();
    }
  }

  void loadFileMessage() async {
    final result = await searchMessage(
        typeList: [MessageType.file],
        pageIndex: ++fileMessagePageIndex,
        count: count);
    final fileMessageResult = result.searchResultItems;
    if (null != fileMessageResult && fileMessageResult.isNotEmpty) {
      for (var element in fileMessageResult) {
        fileMessageList.addAll(element.messageList!);
      }
    }
    if ((fileMessageResult ?? []).length < count) {
      fileMessageRefreshCtrl.loadNoData();
    } else {
      fileMessageRefreshCtrl.loadComplete();
    }
  }

  /// 最多显示3条
  List<T> subList<T>(List<T> list) =>
      list.sublist(0, list.length > 3 ? 3 : list.length).toList();

  String calContent(Message message) => MitiUtils.calContent(
        content: MitiUtils.parseMsg(message, replaceIdToNickname: true),
        key: searchKey.value,
        style: StylesLibrary.ts_999999_14sp,
        usedWidth: 80.w + 26.w,
      );

  void viewUserProfile(UserInfo info) => AppNavigator.startUserProfilePane(
        userID: info.userID!,
        nickname: info.nickname,
        faceURL: info.faceURL,
      );

  void viewFile(Message message) => MitiUtils.previewFile(message);

  void viewGroup(GroupInfo groupInfo) {
    conversationLogic.toChat(
      groupID: groupInfo.groupID,
      nickname: groupInfo.groupName,
      faceURL: groupInfo.faceURL,
      sessionType: groupInfo.sessionType,
    );
  }

  void viewMessage(SearchResultItems item) {
    if (item.messageCount! > 1) {
      AppNavigator.startGlobalSearchChatHistory(
        searchResultItems: item,
        defaultSearchKey: searchKey.value,
      );
    } else {
      AppNavigator.startPreviewChatHistory(
        conversationInfo: ConversationInfo(
          conversationID: item.conversationID!,
          showName: item.showName,
          faceURL: item.faceURL,
        ),
        message: item.messageList!.first,
      );
    }
  }
}

abstract class CommonSearchLogic extends GetxController {
  final searchCtrl = TextEditingController();
  final focusNode = FocusNode();
  final searchKey = "".obs;

  void clearList();

  @override
  void onInit() {
    searchCtrl.addListener(_clearInput);
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  _clearInput() {
    if (searchKey.isEmpty) {
      clearList();
    }
  }

  Future<List<FriendInfo>> searchFriend() async {
    final keyword = searchCtrl.text.trim().toLowerCase();

    final list = await OpenIM.iMManager.friendshipManager.getFriendList();
    // 昵称，备注，id
    final result1 = list
        .where((element) =>
            element.friendInfo != null &&
            (element.showName.toLowerCase().contains(keyword) ||
                (element.friendInfo!.remark ?? "")
                    .toLowerCase()
                    .contains(keyword) ||
                element.userID == keyword))
        .map((e) => e.friendInfo!)
        .toList();
    myLogger.e(result1[0].toJson());
    List<FriendInfo> result2 = [];
    final result1IdList = result1.map((e) => e.userID).toList();
    final fullUserInfoList = await ClientApis.getUserFullInfo(
        userIDList: list.map((e) => e.userID).toList());
    // 手机, 邮箱
    if (fullUserInfoList != null) {
      result2 = fullUserInfoList
          .where((element) =>
              (element.phoneNumber == keyword ||
                  element.email?.toLowerCase() == keyword) &&
              !result1IdList.contains(element.userID))
          .map((e) => FriendInfo.fromJson(e.toJson()))
          .toList();
    }
    return [...result1, ...result2];
  }

  Future<List<GroupInfo>> searchGroup() =>
      OpenIM.iMManager.groupManager.searchGroups(
          keywordList: [searchCtrl.text.trim()],
          isSearchGroupName: true,
          isSearchGroupID: true);

  Future<SearchResult> searchMessage(
          {int pageIndex = 1, int count = 20, required List<int> typeList}) =>
      OpenIM.iMManager.messageManager.searchLocalMessages(
        keywordList: [searchKey.value],
        messageTypeList: typeList,
        pageIndex: pageIndex,
        count: count,
      );

  String? parseID(e) {
    if (e is ConversationInfo) {
      return e.isSingleChat ? e.userID : e.groupID;
    } else if (e is GroupInfo) {
      return e.groupID;
    } else if (e is UserInfo) {
      return e.userID;
    } else if (e is FriendInfo) {
      return e.userID;
    } else {
      return null;
    }
  }

  String? parseNickname(e) {
    if (e is ConversationInfo) {
      return e.showName;
    } else if (e is GroupInfo) {
      return e.groupName;
    } else if (e is UserInfo) {
      return e.nickname;
    } else if (e is FriendInfo) {
      return e.nickname;
    } else {
      return null;
    }
  }

  String? parseFaceURL(e) {
    if (e is ConversationInfo) {
      return e.faceURL;
    } else if (e is GroupInfo) {
      return e.faceURL;
    } else if (e is UserInfo) {
      return e.faceURL;
    } else if (e is FriendInfo) {
      return e.faceURL;
    } else {
      return null;
    }
  }
}
