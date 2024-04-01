import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../../routes/app_navigator.dart';
import '../my_ai_logic.dart';

class SearchMyAiLogic extends GetxController {
  final logic = Get.find<MyAiLogic>();
  final focusNode = FocusNode();
  final searchCtrl = TextEditingController();
  final resultList = <ISUserInfo>[].obs;
  late bool isMultiModel;

  @override
  void onInit() {
    super.onInit();
    searchCtrl.addListener(_clearInput);
  }

  @override
  void onClose() {
    super.onClose();
    focusNode.dispose();
    searchCtrl.dispose();
  }

  bool get isSearchNotResult =>
      searchCtrl.text.trim().isNotEmpty && resultList.isEmpty;

  _clearInput() {
    final key = searchCtrl.text.trim();
    if (key.isEmpty) {
      resultList.clear();
    }
  }

  search() {
    var key = searchCtrl.text.trim();
    resultList.clear();
    if (key.isNotEmpty) {
      for (var element in logic.friendList) {
        if (element.showName.toUpperCase().contains(key.toUpperCase()) ||
            element.userID!.contains(key.toLowerCase()) ||
            element.nickname!.toUpperCase().contains(key.toUpperCase())) {
          resultList.add(element);
        }
      }
    }
  }

  viewFriendInfo(ISUserInfo info) => AppNavigator.startUserProfilePane(
        userID: info.userID!,
        offAndToNamed: true,
      );

  void startTrainAi(ISUserInfo info) => AppNavigator.startTrainAi(
      userID: info.userID!,
      faceURL: info.faceURL,
      showName: info.showName,
      offAndToNamed: true,
      ai: logic.myAiList.firstWhere((e) => e.userID == info.userID));
}
