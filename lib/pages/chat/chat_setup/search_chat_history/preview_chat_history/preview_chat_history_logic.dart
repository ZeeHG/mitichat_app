import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class PreviewChatHistoryLogic extends GetxController {
  late CustomChatListViewController<Message> controller;
  final scrollController = AutoScrollController();
  late ConversationInfo conversationInfo;
  late Message searchMessage;

  final copyTextMap = <String?, String?>{};

  List<Message> get messageList => controller.list;

  int? upLastMinSeq;
  int? downLostMinSeq;

  @override
  void onReady() {
    scrollToTopLoad();
    scrollToBottomLoad();
    super.onReady();
  }

  @override
  void onInit() {
    var arguments = Get.arguments;
    conversationInfo = arguments['conversationInfo'];
    searchMessage = arguments['message'];
    controller = CustomChatListViewController<Message>([searchMessage]);
    super.onInit();
  }

  Future<bool> scrollToTopLoad() async {
    var result = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
      startMsg: messageList.first,
      conversationID: conversationInfo.conversationID,
      count: 20,
      lastMinSeq: upLastMinSeq,
    );

    upLastMinSeq = result.lastMinSeq;
    var list = result.messageList ?? [];

    final hasMore = list.length == 20;
    controller.insertAllToTop(list);
    IMUtils.calChatTimeInterval(controller.list);
    controller.topLoadCompleted(hasMore);
    return hasMore;
  }

  Future<bool> scrollToBottomLoad() async {
    var result = await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageListReverse(
      startMsg: messageList.last,
      conversationID: conversationInfo.conversationID,
      count: 20,
      lastMinSeq: downLostMinSeq,
    );
    downLostMinSeq = result.lastMinSeq;
    var list = result.messageList ?? [];

    final hasMore = list.length == 20;

    controller.insertAllToBottom(list);
    IMUtils.calChatTimeInterval(controller.list);
    controller.bottomLoadCompleted(hasMore);
    return hasMore;
  }

  /// 处理消息点击事件
  void parseClickEvent(Message msg) async {
    log('parseClickEvent:${jsonEncode(msg)}');
    if (msg.contentType == MessageType.custom) {
      var data = msg.customElem!.data;
      var map = json.decode(data!);
      var customType = map['customType'];
      if (CustomMessageType.call == customType) {
        var type = map['data']['type'];
      } else if (CustomMessageType.meeting == customType) {
        var data = msg.customElem!.data;
        var map = json.decode(data!);
      }
      return;
    }
    if (msg.contentType == MessageType.voice) {}
    IMUtils.parseClickEvent(msg, messageList: messageList);
  }

  /// 点击引用消息
  void onTapQuoteMsg(Message message) {
    if (message.contentType == MessageType.quote) {
      parseClickEvent(message.quoteElem!.quoteMessage!);
    } else if (message.contentType == MessageType.atText) {
      parseClickEvent(message.atTextElem!.quoteMessage!);
    }
  }

  void copy(Message message) {
    IMUtils.copy(text: copyTextMap[message.clientMsgID] ?? message.textElem!.content!);
  }

  ValueKey itemKey(Message message) => ValueKey(message.clientMsgID!);

  @override
  void onClose() {
    super.onClose();
  }

  String? getShowTime(Message message) {
    if (message.exMap['showTime'] == true) {
      return IMUtils.getChatTimeline(message.sendTime!);
    }
    return null;
  }

  /// 搜索定位消息位置
  void lockMessageLocation(Message message) {
    // var upList = list.sublist(0, 15);
    // var downList = list.sublist(15);
    // messageList.assignAll(downList);
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent - 50);
    //   messageList.insertAll(0, upList);
    // });
  }
}

/// 新版聊天列表控件
mixin ListViewDataCtrl {
  final controller = CustomChatListViewController<Message>([]).obs;
  final scrollController = AutoScrollController();

  List<Message> get messageList => controller.value.list;

  bool get isScrollBottom => scrollController.offset == scrollController.position.maxScrollExtent;

  final newMessageCount = 0.obs;
  int newMessageStartPosition = -1;

  add(Message message, {bool scrollToBottom = false}) {
    controller.update((val) {
      val?.insertToBottom(message);
    });
    _scrollToBottom(scroll: scrollToBottom, count: 1);
  }

  addAll(List<Message> iterable, {bool scrollToBottom = false}) {
    controller.update((val) {
      // if (scrollToBottom) {
      //   if (iterable.length > 10) {
      //     val?.insertAllToTop(iterable);
      //     val?.insertAllToBottom([iterable.last]);
      //   }
      // }
      val?.insertAllToBottom(iterable);
    });
    _scrollToBottom(scroll: scrollToBottom, count: iterable.length);
  }

  insert(Message message) {
    controller.update((val) {
      val?.insertToTop(message);
    });
  }

  insertAll(List<Message> iterable) {
    controller.value.insertAllToTop(iterable);
  }

  void jumpToTop() async {
    await scrollController.scrollToTop();
  }

  void jumpToBottom() async {
    await scrollController.scrollToBottom(() {});
  }

  _scrollToBottom({
    bool scroll = false,
    int count = 0,
  }) {
    if (scroll) {
      newMessageCount.value = 0;
      newMessageStartPosition = -1;
      jumpToBottom();
    } else {
      if (newMessageStartPosition == -1) {
        newMessageStartPosition = messageList.length - 1;
        Logger.print('newMessageStartPosition: $newMessageStartPosition');
      }
      newMessageCount.value += count;
    }
  }

  scrollToIndex() {
    scrollController.scrollToIndex(
      newMessageStartPosition,
      duration: const Duration(milliseconds: 10),
    );
    newMessageCount.value = 0;
    newMessageStartPosition = -1;
  }
}
