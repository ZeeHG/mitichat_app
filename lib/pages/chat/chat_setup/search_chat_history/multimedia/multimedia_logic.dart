import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum MultimediaType { picture, video }

class ChatHistoryMultimediaLogic extends GetxController {
  final refreshController = RefreshController();
  late ConversationInfo conversationInfo;
  late MultimediaType multimediaType;
  final messageList = <Message>[];
  final groupMessage = <String, List<Message>>{}.obs;
  int pageIndex = 1;
  int pageSize = 50;

  @override
  void onInit() {
    conversationInfo = Get.arguments['conversationInfo'];
    multimediaType = Get.arguments['multimediaType'];
    super.onInit();
  }

  bool get isPicture => multimediaType == MultimediaType.picture;

  @override
  void onReady() {
    onRefresh();
    super.onReady();
  }

  void onRefresh() async {
    try {
      var result = await _search(pageIndex = 1);
      if (result.totalCount == 0) {
        messageList.clear();
        groupMessage.clear();
      } else {
        var item = result.searchResultItems!.first;
        messageList.assignAll(item.messageList!);
        groupMessage.assignAll(IMUtils.groupingMessage(item.messageList!.reversed.toList()));
      }
    } finally {
      refreshController.refreshCompleted();
      if (messageList.length < pageIndex * pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  void onLoad() async {
    try {
      var result = await _search(++pageIndex);
      if (result.totalCount! > 0) {
        var item = result.searchResultItems!.first;
        messageList.addAll(item.messageList!);
        groupMessage.addAll(IMUtils.groupingMessage(item.messageList!.reversed.toList()));
      }
    } finally {
      if (messageList.length < pageIndex * pageSize) {
        refreshController.loadNoData();
      } else {
        refreshController.loadComplete();
      }
    }
  }

  Future<SearchResult> _search(int pageIndex) {
    return OpenIM.iMManager.messageManager.searchLocalMessages(
      conversationID: conversationInfo.conversationID,
      keywordList: [],
      messageTypeList: [isPicture ? MessageType.picture : MessageType.video],
      pageIndex: pageIndex,
      count: pageSize,
    );
  }

  void viewMultimedia(Message message) {
    if (isPicture) {
      IMUtils.previewPicture(message, allList: messageList);
    } else {
      IMUtils.previewVideo(message);
    }
  }

  String getSnapshotUrl(Message message) {
    return isPicture ? message.pictureElem!.sourcePicture!.url!.thumbnailAbsoluteString : message.videoElem!.snapshotUrl!.thumbnailAbsoluteString;
  }
}
