import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:openim_common/openim_common.dart';

class AiUtil extends GetxController {
  final accountUtil = Get.find<AccountUtil>();
  final aiList = [].obs;

  String get accountKey => DataSp.getCurAccountLoginInfoKey();

  String getKey(String aiUserID) => accountKey + "__" + aiUserID;

  updateStore({required String aiUserID, required String botID, String? nickName}) {
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

  getAiKeys() {
    return DataSp.getAiKeys() ?? [];
  }

  Future queryAiList() async {
    aiList.value = (await Apis.getBots()).map<String>((e) {
      return e["UserID"].toString();
    }).toList();

    aiList.value = (await Apis.getBots()).map<String>((e) {
      return Ai.fromJson({
        "key": getKey(e["UserID"]),
        "userID": e["UserID"],
        "botID": e["BotID"],
        "nickName": e["NickName"]
      });
    }).toList();
  }
}
