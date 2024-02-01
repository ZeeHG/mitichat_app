import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:openim_common/openim_common.dart';

class AiUtil extends GetxController {
  final accountUtil = Get.find<AccountUtil>();
  final aiStore = <String, Ai>{}.obs;

  String get accountKey => DataSp.getCurAccountLoginInfoKey();
  List<String> get aiKeys => getAiKeys();

  String getKey(String aiUserID) => accountKey + "__" + aiUserID;

  init() {
    final store = DataSp.getAiStore();
    if (null != store) {
      aiStore.addAll(store);
    }
    queryAiList();
  }

  updateStoreItem(
      {required String aiUserID, required String botID, String? nickName}) {
    final key = getKey(aiUserID);
    DataSp.putAiStore({
      key: Ai.fromJson({
        "key": key,
        "userID": aiUserID,
        "botID": botID,
        "nickName": nickName
      })
    });
  }

  Future<bool?> updateStore(Map<String, Ai> store) async {
    aiStore.addAll(store);
    return await DataSp.putAiStore(aiStore.value);
  }

  List<String> getAiKeys() {
    return aiStore.keys.toList();
  }

  bool isAi(String? aiUserID) {
    if (null != aiUserID) {
      final key = getKey(aiUserID);
      return aiKeys.contains(key);
    }
    return false;
  }

  Future<bool?> queryAiList() async {
    List<Ai> list = (await Apis.getBots())
        .map((e) {
          return Ai.fromJson({
            "key": getKey(e["UserID"]),
            "userID": e["UserID"],
            "botID": e["BotID"],
            "nickName": e["NickName"]
          });
        })
        .toList()
        .cast<Ai>();

    Map<String, Ai> store =
        Map.fromIterable(list, key: (e) => e.key, value: (e) => e);

    return await updateStore(store);
  }
}
