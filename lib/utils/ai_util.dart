import 'dart:async';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';

class AiUtil extends GetxController {
  final accountUtil = Get.find<AccountUtil>();
  final aiStore = <String, Ai>{}.obs;

  String get accountKey => DataSp.getCurAccountLoginInfoKey();
  List<String> get aiKeys => getAiKeys();

  String getKey(String aiUserID) => accountKey + "__" + aiUserID;

  init() async {
    // todo 暂时加上, 防止数据结构出错
    // await DataSp.clearAiStore();
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
    return await DataSp.putAiStore(aiStore);
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

  bool isMyAi(Ai ai) {
    return ai.createdBy == OpenIM.iMManager.userID;
  }

  Future<bool?> queryAiList() async {
    List<Ai> list = ((await Apis.getBots())["bots"] ?? [])
        .map((e) {
          return Ai.fromJson({
            "key": getKey(e["userID"]),
            "userID": e["userID"],
            "botID": e["botID"],
            "nickName": e["nickName"],
            "createTime": e["createTime"],
            "createdBy": e["createdBy"]
          });
        })
        .toList()
        .cast<Ai>();

    Map<String, Ai> store = {for (var e in list) e.key: e};

    return await updateStore(store);
  }

  Future<List<Ai>> queryMyAiList() async {
    return ((await Apis.getMyAi())["bots"] ?? [])
        .map((e) {
          return Ai.fromJson({
            "key": getKey(e["userID"]),
            "userID": e["userID"],
            "botID": e["botID"],
            "nickName": e["nickName"],
            "createTime": e["createTime"],
            "createdBy": e["createdBy"]
          });
        })
        .toList()
        .cast<Ai>();
  }
}
