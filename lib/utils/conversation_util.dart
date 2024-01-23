import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:openim_common/openim_common.dart';

class ConversationUtil extends GetxController {
  final accountUtil = Get.find<AccountUtil>();

  String get accountKey => DataSp.getCurAccountLoginInfoKey();

  String getKey(String conversationId) =>
      accountKey + "__" + conversationId;

  updateStore(String conversationId, {int? waitingST = -1}) {
    final key = getKey(conversationId);
    DataSp.putConversationStore({
      key: ConversationConfig.fromJson({"waitingST": waitingST})
    });
  }

  getConversationStoreById(String conversationId) {
    return DataSp.getConversationStore()?[getKey(conversationId)];
  }
}
