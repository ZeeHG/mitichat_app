import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class ChatHistoryFileLogic extends GetxController {
  final refreshController = RefreshController();
  late ConversationInfo conversationInfo;
  final messageList = <Message>[].obs;
  var pageIndex = 1;
  var pageSize = 50;

  @override
  void onInit() {
    conversationInfo = Get.arguments['conversationInfo'];
    onRefresh();
    super.onInit();
  }

  onRefresh() async {
    try {
      final result = await search(pageIndex = 1);
      if (result.totalCount == 0) {
        messageList.clear();
      } else {
        final item = result.searchResultItems!.first;
        messageList.assignAll(item.messageList!);
      }
    } finally {
      refreshController.refreshCompleted();
      if (messageList.length < pageIndex * pageSize) {
        refreshController.loadNoData();
      }
    }
  }

  onLoad() async {
    try {
      var result = await search(++pageIndex);
      if (result.totalCount! > 0) {
        var item = result.searchResultItems!.first;
        messageList.addAll(item.messageList!);
      }
    } finally {
      messageList.length < pageIndex * pageSize? refreshController.loadNoData() : refreshController.loadComplete();
    }
  }

  Future<SearchResult> search(int pageIndex) {
    return OpenIM.iMManager.messageManager.searchLocalMessages(
      conversationID: conversationInfo.conversationID,
      keywordList: [],
      messageTypeList: [MessageType.file],
      pageIndex: pageIndex,
      count: pageSize,
    );
  }

  void viewFile(Message message) {
    MitiUtils.previewFile(message);
  }
}
