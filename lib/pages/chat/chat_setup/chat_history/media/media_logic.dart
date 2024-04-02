import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

enum MultimediaType { picture, video }

class ChatHistoryMediaLogic extends GetxController {
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
    onRefresh();
    super.onInit();
  }

  bool get isPicture => multimediaType == MultimediaType.picture;

  void onRefresh() async {
    try {
      var result = await _search(pageIndex = 1);
      if (result.totalCount == 0) {
        messageList.clear();
        groupMessage.clear();
      } else {
        var item = result.searchResultItems!.first;
        messageList.assignAll(item.messageList!);
        groupMessage.assignAll(
            MitiUtils.groupingMessage(item.messageList!.reversed.toList()));
      }
    } finally {
      refreshController.refreshCompleted();
      messageList.length < pageIndex * pageSize? refreshController.loadNoData(): refreshController.loadComplete();
    }
  }

  void onLoad() async {
    try {
      var result = await _search(++pageIndex);
      if (result.totalCount! > 0) {
        var item = result.searchResultItems!.first;
        messageList.addAll(item.messageList!);
        groupMessage.addAll(
            MitiUtils.groupingMessage(item.messageList!.reversed.toList()));
      }
    } finally {
      messageList.length < pageIndex * pageSize
          ? refreshController.loadNoData()
          : refreshController.loadComplete();
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
      MitiUtils.previewPicture(message, allList: messageList);
    } else {
      MitiUtils.previewVideo(message);
    }
  }

  String getSnapshotUrl(Message message) {
    return isPicture
        ? message.pictureElem!.sourcePicture!.url!.thumbnailAbsoluteString
        : message.videoElem!.snapshotUrl!.thumbnailAbsoluteString;
  }
}
