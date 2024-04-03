import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import '../../../../routes/app_navigator.dart';
import 'media/media_logic.dart';

class ChatHistoryLogic extends GetxController {
  final refreshController = RefreshController();
  final searchCtrl = TextEditingController();
  final focusNode = FocusNode();
  final messageList = <Message>[].obs;
  late Rx<ConversationInfo> conversationInfo;
  final searchKey = "".obs;
  int pageIndex = 1;
  int pageSize = 50;

  get items => conversationInfo.value.isSingleChat
      ? [
          StrLibrary.picture, StrLibrary.video, StrLibrary.file,
          // StrLibrary .link, StrLibrary .audio
        ]
      : [
          StrLibrary.picture,
          StrLibrary.video,
          StrLibrary.file,
          // StrLibrary .groupMember,
          // StrLibrary .link,
          // StrLibrary .audio
        ];

  void clickItem(String item) {
    if (item == StrLibrary.picture) {
      chatHistoryPicture();
    } else if (item == StrLibrary.video) {
      chatHistoryVideo();
    } else if (item == StrLibrary.file) {
      chatHistoryFile();
    } else if (item == StrLibrary.groupMember) {
      showDeveloping();
    } else if (item == StrLibrary.link) {
      showDeveloping();
    } else if (item == StrLibrary.audio) {
      showDeveloping();
    }
  }

  @override
  void onInit() {
    conversationInfo = Rx(Get.arguments['conversationInfo']);
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
    } else {
      messageList.clear();
    }
  }

  clearInput() {
    searchKey.value = "";
    focusNode.requestFocus();
    messageList.clear();
  }

  bool get isSearchNotResult =>
      searchKey.value.isNotEmpty && messageList.isEmpty;

  bool get isNotKey => searchKey.value.isEmpty;

  void search() async {
    try {
      // searchKey.value = searchCtrl.text.trim();
      var result = await OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.value.conversationID,
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
      messageList.length < pageIndex * pageSize
          ? refreshController.loadNoData()
          : refreshController.loadComplete();
    }
  }

  load() async {
    try {
      var result = await OpenIM.iMManager.messageManager.searchLocalMessages(
        conversationID: conversationInfo.value.conversationID,
        keywordList: [searchKey.value],
        pageIndex: ++pageIndex,
        count: pageSize,
        messageTypeList: [MessageType.text, MessageType.atText],
      );
      if (result.totalCount! > 0) {
        final item = result.searchResultItems!.first;
        messageList.addAll(item.messageList!);
      }
    } finally {
      messageList.length < (pageSize * pageIndex)
          ? refreshController.loadNoData()
          : refreshController.loadComplete();
    }
  }

  String calContent(Message message) {
    String content = MitiUtils.parseMsg(message, replaceIdToNickname: true);
    // 左右间距+头像跟名称的间距+头像dax
    final usedWidth = 16.w * 2 + 10.w + 44.w;
    return MitiUtils.calContent(
      content: content,
      key: searchKey.value,
      style: StylesLibrary.ts_333333_16sp,
      usedWidth: usedWidth,
    );
  }

  void chatHistoryPicture() => AppNavigator.startChatHistoryMedia(
        conversationInfo: conversationInfo.value,
      );

  void chatHistoryVideo() => AppNavigator.startChatHistoryMedia(
        conversationInfo: conversationInfo.value,
        multimediaType: MultimediaType.video,
      );

  void chatHistoryFile() => AppNavigator.startChatHistoryFile(
        conversationInfo: conversationInfo.value,
      );

  void previewMessageHistory(Message message) =>
      AppNavigator.startPreviewChatHistory(
        conversationInfo: conversationInfo.value,
        message: message,
      );
}
