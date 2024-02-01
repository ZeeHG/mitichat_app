import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../../routes/app_navigator.dart';
import '../ai_friend_list_logic.dart';

class SearchAiFriendLogic extends GetxController {
  final logic = Get.find<AiFriendListLogic>();
  final focusNode = FocusNode();
  final searchCtrl = TextEditingController();
  final resultList = <ISUserInfo>[].obs;
  late bool isMultiModel;

  @override
  void onInit() {
    searchCtrl.addListener(_clearInput);
    super.onInit();
  }

  @override
  void onClose() {
    focusNode.dispose();
    searchCtrl.dispose();
    super.onClose();
  }

  bool get isSearchNotResult => searchCtrl.text.trim().isNotEmpty && resultList.isEmpty;

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
        if (element.showName.toUpperCase().contains(key.toUpperCase()) || element.userID!.contains(key.toLowerCase()) || element.nickname!.toUpperCase().contains(key.toUpperCase())) {
          resultList.add(element);
        }
      }
    }
  }

  viewFriendInfo(ISUserInfo info) => AppNavigator.startUserProfilePane(
        userID: info.userID!,
        offAndToNamed: true,
      );
}
