import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class TtsLogic extends GetxController {
  String userID = "";
  RxMap<String, dynamic> msgTts = <String, dynamic>{}.obs;

  init(String id) {
    userID = id;

    Map<String, dynamic>? _msgTts = getMsgTts();
    if (null == _msgTts) {
      setMsgTts({});
    } else {
      for (var item in _msgTts.values) {
        if (item?["status"] == "loading") {
          item.remove("status");
        }
      }
      msgTts.addAll(_msgTts);
    }

    msgTts.refresh();
  }

  getMsgTts() {
    return SpUtil().getObject("${userID}_msgTts");
  }

  setMsgTts(Map<String, dynamic> data) {
    SpUtil().putObject("${userID}_msgTts", data);
  }

  // {clientMsgID, origin, status/hide/show/loading/fail, ttsText}
  updateMsgLocalTts(String clientMsgID, Map<String, String> data) {
    final item = msgTts[clientMsgID];
    if (null == item) {
      msgTts.addAll({clientMsgID: data});
    } else {
      item.addAll(data);
      msgTts.addAll({clientMsgID: item});
    }
    msgTts.refresh();
    setMsgTts(msgTts);
    myLogger.i({
      "message": "本地tts更新, clientMsgID=$clientMsgID",
      "data": msgTts[clientMsgID]
    });
  }

  updateMsgAllTts(Message message, Map<String, String> data) {
    if (null != message.clientMsgID) {
      updateMsgLocalTts(message.clientMsgID!, data);
    }
  }

  clearAllTtsMsgCache() {
    msgTts.value = {};
    setMsgTts({});
    showToast(StrLibrary.success);
  }
}
