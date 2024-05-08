import 'dart:convert';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';
// import 'package:openim_meeting/openim_meeting.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

import '../../core/ctrl/app_ctrl.dart';
import '../../core/ctrl/im_ctrl.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../contacts/search_add_contacts/search_add_contacts_logic.dart';
import '../home/home_logic.dart';

class ConversationLogic extends GetxController {
  final popCtrl = CustomPopupMenuController();
  final serverPopCtrl = CustomPopupMenuController();
  final list = <ConversationInfo>[].obs;
  final imCtrl = Get.find<IMCtrl>();
  final homeLogic = Get.find<HomeLogic>();
  final appCtrl = Get.find<AppCtrl>();
  final refreshController = RefreshController();
  final tempDraftText = <String, String>{};
  final pageSize = 40;
  final translateLogic = Get.find<TranslateLogic>();
  final accountUtil = Get.find<AccountUtil>();
  final tabIndex = 0.obs;
  final imStatus = IMSdkStatus.connectionSucceeded.obs;
  late AutoScrollController scrollController;
  int scrollIndex = -1;

  switchAccount(AccountLoginInfo loginInfo) async {
    if (loginInfo.id == curLoginInfoKey) return;
    LoadingView.singleton.start(
        topBarHeight: 0,
        loadingTips: StrLibrary.loading,
        fn: () async {
          await accountUtil.switchAccount(
              serverWithProtocol: loginInfo.server, userID: loginInfo.userID);
          AppNavigator.startMain();
        });
  }

  switchTab(index) {
    tabIndex.value = index;
  }

  myQrcode() {
    AppNavigator.startMyQrcode();
  }

  List<AccountLoginInfo> get loginInfoList {
    final map = DataSp.getAccountLoginInfoMap();
    if (null == map) {
      return [];
    } else {
      return map.values.toList();
    }
  }

  String get curLoginInfoKey {
    return DataSp.getCurAccountLoginInfoKey();
  }

  @override
  void onInit() {
    scrollController = AutoScrollController(axis: Axis.vertical);
    imCtrl.conversationAddedSubject.listen(onChanged);
    imCtrl.conversationChangedSubject.listen(onChanged);
    homeLogic.onscrollToUnreadConversation = scrollToUnreadConversation;

    ever(list, (_) {
      EasyDebounce.debounce('translate', const Duration(milliseconds: 500), () {
        for (var item in list) {
          translateLogic.updateLangConfigLocal(
              conversation: item,
              data: (null != item.ex && item.ex!.isNotEmpty)
                  ? json.decode(item.ex!)["langConfig"] ?? {}
                  : {});
        }
      });
    });
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    loadConversationList(true);
  }

  /// 会话列表通过回调更新
  void onChanged(newList) {
    for (var newValue in newList) {
      // promptSoundOrNotification(newValue);
      list.remove(newValue);
    }
    list.insertAll(0, newList);
    sortConversation();
  }

  /// 提示音
  void promptSoundOrNotification(ConversationInfo info) {
    if (imCtrl.userInfo.value.globalRecvMsgOpt == 0 &&
        info.recvMsgOpt == 0 &&
        info.unreadCount > 0 &&
        info.latestMsg?.sendID != OpenIM.iMManager.userID) {
      appCtrl.promptNotification(info.latestMsg!);
    }
  }

  String getConversationID(ConversationInfo info) => info.conversationID;

  /// 置顶会话
  void pinConversation(ConversationInfo info) async {
    OpenIM.iMManager.conversationManager.pinConversation(
      conversationID: info.conversationID,
      isPinned: !info.isPinned!,
    );
  }

  /// 删除会话
  void deleteConversation(ConversationInfo info) async {
    await OpenIM.iMManager.conversationManager
        .deleteConversationAndDeleteAllMsg(
      conversationID: info.conversationID,
    );
    list.remove(info);
  }

  /// 根据id移除会话
  void removeConversation(String id) {
    list.removeWhere((e) => e.conversationID == id);
  }

  /// 设置草稿
  void setConversationDraft({required String cid, required String draftText}) {
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: cid,
      draftText: draftText,
    );
  }

  /// 会话前缀标签
  String? getPrefixTag(ConversationInfo info) {
    String? prefix;
    try {
      // 草稿
      if (null != info.draftText && '' != info.draftText) {
        var map = json.decode(info.draftText!);
        String text = map['text'];
        if (text.isNotEmpty) {
          prefix = '[${StrLibrary.draftText}]';
        }
      } else {
        switch (info.groupAtType) {
          case GroupAtType.atAll:
            prefix = '[@${StrLibrary.everyone}]';
            break;
          case GroupAtType.atAllAtMe:
            prefix = '[@${StrLibrary.everyone} @${StrLibrary.you}]';
            break;
          case GroupAtType.atMe:
            prefix = '[@${StrLibrary.you}]';
            break;
          case GroupAtType.atNormal:
            break;
          case GroupAtType.groupNotification:
            prefix = '[${StrLibrary.groupAc}]';
            break;
        }
      }
    } catch (e, s) {
      myLogger.e({"message": "getPrefixTag", "error": e, "stack": s});
    }

    return prefix;
  }

  /// 解析消息内容
  String getContent(ConversationInfo info) {
    try {
      if (null != info.draftText && '' != info.draftText) {
        var map = json.decode(info.draftText!);
        String text = map['text'];
        if (text.isNotEmpty) {
          return text;
        }
      }

      if (null == info.latestMsg) return "";

      final text = MitiUtils.parseNtf(info.latestMsg!, isConversation: true);
      if (text != null) return text;
      final msgText = MitiUtils.parseMsg(info.latestMsg!, isConversation: true);
      if (info.isSingleChat ||
          info.latestMsg!.sendID == OpenIM.iMManager.userID) return msgText;

      return "${info.latestMsg!.senderNickname}: $msgText";
    } catch (e, s) {
      myLogger.e({"message": "getContent", "error": e, "stack": s});
    }
    return '[${StrLibrary.unsupportedMessage}]';
  }

  Map<String, String> getAtUserMap(ConversationInfo info) {
    if (null != info.draftText && '' != info.draftText!.trim()) {
      var map = json.decode(info.draftText!);
      var atMap = map['at'];
      if (atMap.isNotEmpty && atMap is Map) {
        var v = <String, String>{};
        atMap.forEach((key, value) {
          v.addAll({'$key': "$value"});
        });
        return v;
      }
    }
    if (info.isGroupChat) {
      final map = <String, String>{};
      var message = info.latestMsg;
      if (message?.contentType == MessageType.atText) {
        var list = message!.atTextElem!.atUsersInfo;
        list?.forEach((e) {
          map[e.atUserID!] = e.groupNickname ?? e.atUserID!;
        });
      }
      return map;
    }
    return {};
  }

  /// 头像
  String? getAvatar(ConversationInfo info) => info.faceURL;

  bool isGroupChat(ConversationInfo info) => info.isGroupChat;

  /// 显示名
  String getShowName(ConversationInfo info) {
    if (info.showName == null || info.showName.isBlank!) {
      return info.userID!;
    }
    return info.showName!;
  }

  /// 时间
  String getTime(ConversationInfo info) =>
      MitiUtils.getChatTimeline(info.latestMsgSendTime!);

  /// 未读数
  int getUnreadCount(ConversationInfo info) => info.unreadCount;

  bool existUnreadMsg(ConversationInfo info) => getUnreadCount(info) > 0;

  /// 判断置顶
  bool isPinned(ConversationInfo info) => info.isPinned!;

  bool isNotDisturb(ConversationInfo info) => info.recvMsgOpt != 0;

  bool isUserGroup(int index) => list[index].isGroupChat;

  /// 草稿
  /// 聊天页调用，不通过onWillPop事件返回，因为该事件会拦截ios的左滑返回上一页。
  void updateDartText({
    String? conversationID,
    required String text,
  }) {
    if (null != conversationID) tempDraftText[conversationID] = text;
  }

  /// 清空未读消息数
  void markMessageHasRead(ConversationInfo info) {
    OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
      conversationID: info.conversationID,
    );
  }

  /// 设置草稿
  void setDraftText({
    required String conversationID,
    required String oldDraftText,
    required String newDraftText,
  }) {
    if (oldDraftText.isEmpty && newDraftText.isEmpty) {
      return;
    }

    /// 保存草稿
    OpenIM.iMManager.conversationManager.setConversationDraft(
      conversationID: conversationID,
      draftText: newDraftText,
    );
  }

  String? get imSdkStatus {
    switch (imStatus.value) {
      case IMSdkStatus.syncStart:
      case IMSdkStatus.synchronizing:
        return StrLibrary.synchronizing;
      case IMSdkStatus.syncFailed:
        return StrLibrary.syncFailed;
      case IMSdkStatus.connecting:
        return StrLibrary.connecting;
      case IMSdkStatus.connectionFailed:
        return StrLibrary.connectionFailed;
      case IMSdkStatus.connectionSucceeded:
      case IMSdkStatus.syncEnded:
        return null;
    }
  }

  bool get isFailedSdkStatus => [
        IMSdkStatus.connectionFailed,
        IMSdkStatus.syncFailed
      ].contains(imStatus.value);

  /// 自定义会话列表排序规则
  void sortConversation() =>
      OpenIM.iMManager.conversationManager.simpleSort(list);

  void loadConversationList([bool refresh = false]) async {
    late List<ConversationInfo> list;
    try {
      if (refresh) {
        list = await getConversationList(0);
        this.list.assignAll(list);
      } else {
        list = await getConversationList(this.list.length);
        this.list.addAll(list);
      }
    } finally {
      if (list.isEmpty || list.length < pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
      if (refresh) refreshController.refreshCompleted();
    }
  }

  getConversationList(int offset) =>
      OpenIM.iMManager.conversationManager.getConversationListSplit(
        offset: offset,
        count: pageSize,
      );

  bool isValidConversation(ConversationInfo info) {
    return info.isValid;
  }

  // use this if total item count is known
  int scrollListenerWithItemCount() {
    int itemCount = list.length;
    double scrollOffset = scrollController.position.pixels;
    double viewportHeight = scrollController.position.viewportDimension;
    double scrollRange = scrollController.position.maxScrollExtent -
        scrollController.position.minScrollExtent;
    int firstVisibleItemIndex =
        (scrollOffset / (scrollRange + viewportHeight) * itemCount).floor();
    return firstVisibleItemIndex;
  }

  void scrollToUnreadConversation() {
    if (list.isEmpty) return;
    int start = scrollListenerWithItemCount();
    start = start < scrollIndex
        ? scrollIndex
        : scrollIndex == start
            ? start + 1
            : start;
    if (scrollController.offset >= scrollController.position.maxScrollExtent) {
      start = 0;
    }
    if (start > list.length - 1) return;
    final unreadItem =
        list.sublist(start).firstWhereOrNull((e) => e.unreadCount > 0);
    if (null != unreadItem) {
      final index = list.indexOf(unreadItem);
      if (start != index) {
        scrollController.scrollToIndex(
          scrollIndex = index,
          preferPosition: AutoScrollPosition.begin,
        );
      }
    } else {
      if (start > 0) {
        scrollController.scrollToIndex(
          scrollIndex = 0,
          preferPosition: AutoScrollPosition.begin,
        );
      }
    }
  }

  static Future<ConversationInfo> _createConversation({
    required String sourceID,
    required int sessionType,
  }) =>
      LoadingView.singleton.start(
          fn: () => OpenIM.iMManager.conversationManager.getOneConversation(
                sourceID: sourceID,
                sessionType: sessionType,
              ));

  /// 打开系统通知页面
  // Future<bool> _jumpOANtf(ConversationInfo info) async {
  //   if (info.conversationType == ConversationType.notification) {
  //     // 系统通知
  //     await AppNavigator.startOANtfList(info: info);
  //     // 标记已读
  //     markMessageHasRead(info);
  //     return true;
  //   }
  //   return false;
  // }

  /// 进入聊天页面
  void toChat({
    bool offUntilHome = true,
    String? userID,
    String? groupID,
    String? nickname,
    String? faceURL,
    int? sessionType,
    ConversationInfo? conversationInfo,
    Message? searchMessage,
  }) async {
    // 获取会话信息，若不存在则创建
    conversationInfo ??= await _createConversation(
      sourceID: userID ?? groupID!,
      sessionType: userID == null ? sessionType! : ConversationType.single,
    );

    // 如果是系统通知
    // if (await _jumpOANtf(conversationInfo)) return;

    if (conversationInfo.conversationType == ConversationType.notification)
      return;

    // 保存旧草稿
    updateDartText(
      conversationID: conversationInfo.conversationID,
      text: conversationInfo.draftText ?? '',
    );

    // 打开聊天窗口，关闭返回草稿
    /*var newDraftText = */
    await AppNavigator.startChat(
      offUntilHome: offUntilHome,
      draftText: conversationInfo.draftText,
      conversationInfo: conversationInfo,
      searchMessage: searchMessage,
    );

    // 读取草稿
    var newDraftText = tempDraftText[conversationInfo.conversationID];

    // 标记已读
    markMessageHasRead(conversationInfo);

    // 记录草稿
    setDraftText(
      conversationID: conversationInfo.conversationID,
      oldDraftText: conversationInfo.draftText ?? '',
      newDraftText: newDraftText!,
    );

    bool equal(e) => e.conversationID == conversationInfo?.conversationID;
    // 删除所有@标识/公告标识
    var groupAtType = list.firstWhereOrNull(equal)?.groupAtType;
    if (groupAtType != GroupAtType.atNormal) {
      OpenIM.iMManager.conversationManager.resetConversationGroupAtType(
        conversationID: conversationInfo.conversationID,
      );
    }
  }

  scan() => AppNavigator.startScan();

  addFriend() =>
      AppNavigator.startSearchAddContacts(searchType: SearchType.user);

  createGroup() => AppNavigator.startCreateGroup(
      defaultCheckedList: [OpenIM.iMManager.userInfo]);

  addGroup() =>
      AppNavigator.startSearchAddContacts(searchType: SearchType.group);

  // void videoMeeting() => MNavigator.startMeeting();

  // void viewCallRecords() => AppNavigator.startCallRecords();

  void globalSearch() => AppNavigator.startGlobalSearch();

  void viewMyInfo() => AppNavigator.startMyInfo();
}
