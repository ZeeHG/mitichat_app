import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../routes/app_navigator.dart';
import 'multimedia/multimedia_logic.dart';

class SearchChatHistoryLogic extends GetxController {
  final refreshController = RefreshController();
  final searchCtrl = TextEditingController();
  final focusNode = FocusNode();
  final messageList = <Message>[].obs;
  late ConversationInfo conversationInfo;
  final searchKey = "".obs;
  int pageIndex = 1;
  int pageSize = 50;

  @override
  void onInit() {
    conversationInfo = Get.arguments['conversationInfo'];
    // searchCtrl.addListener(_changedSearch);
    super.onInit();
  }

  @override
  void dispose() {
    searchCtrl.dispose();
    focusNode.dispose();
    super.dispose();
  }

  void onChanged(String value) {
    searchKey.value = value;
    if (value.trim().isNotEmpty) {
      search();
    }
  }

  clearInput() {
    searchKey.value = "";
    focusNode.requestFocus();
    messageList.clear();
  }

  bool get isSearchNotResult => searchKey.value.isNotEmpty && messageList.isEmpty;

  bool get isNotKey => searchKey.value.isEmpty;

  void search() async {
    try {
      // searchKey.value = searchCtrl.text.trim();
      var result = await OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.conversationID,
        keywordList: [searchKey.value],
        pageIndex: pageIndex = 1,
        count: pageSize,
        messageTypeList: [MessageType.text, MessageType.atText],
      );
      if (result.totalCount == 0) {
        messageList.clear();
      } else {
        var item = result.searchResultItems!.first;
        messageList.assignAll(item.messageList!);
      }
    } finally {
      if (messageList.length < pageIndex * pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  load() async {
    try {
      var result = await OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.conversationID,
        keywordList: [searchKey.value],
        pageIndex: ++pageIndex,
        count: pageSize,
        messageTypeList: [MessageType.text, MessageType.atText],
      );
      if (result.totalCount! > 0) {
        var item = result.searchResultItems!.first;
        messageList.addAll(item.messageList!);
      }
    } finally {
      if (messageList.length < (pageSize * pageIndex)) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  String calContent(Message message) {
    String content = IMUtils.parseMsg(message, replaceIdToNickname: true);
    // 左右间距+头像跟名称的间距+头像dax
    var usedWidth = 16.w * 2 + 10.w + 44.w;
    return IMUtils.calContent(
      content: content,
      key: searchKey.value,
      style: Styles.ts_0C1C33_17sp,
      usedWidth: usedWidth,
    );
  }

  void searchChatHistoryPicture() => AppNavigator.startSearchChatHistoryMultimedia(
        conversationInfo: conversationInfo,
      );

  void searchChatHistoryVideo() => AppNavigator.startSearchChatHistoryMultimedia(
        conversationInfo: conversationInfo,
        multimediaType: MultimediaType.video,
      );

  void searchChatHistoryFile() => AppNavigator.startSearchChatHistoryFile(
        conversationInfo: conversationInfo,
      );

  void previewMessageHistory(Message message) => AppNavigator.startPreviewChatHistory(
        conversationInfo: conversationInfo,
        message: message,
      );
}
