import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:openim_common/openim_common.dart';

class ConversationUtil extends GetxController {
  final accountUtil = Get.find<AccountUtil>();

  String get accountKey => DataSp.getCurAccountLoginInfoKey();

  String getKey(String conversationID) => accountKey + "__" + conversationID;

  updateStore(String conversationID, {int? waitingST = -1}) {
    final key = getKey(conversationID);
    DataSp.putConversationStore({
      key: ConversationConfig.fromJson({"key": key, "conversationID": conversationID, "waitingST": waitingST})
    });
  }

  getConversationStoreById(String conversationID) {
    return DataSp.getConversationStore()?[getKey(conversationID)];
  }
}
