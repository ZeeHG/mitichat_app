import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class SetMuteForGroupMemberLogic extends GetxController {
  final controller = TextEditingController(text: '0');
  final focusNode = FocusNode();
  final index = 10.obs;
  late String groupID;
  late String userID;

  @override
  void onInit() {
    groupID = Get.arguments['groupID'];
    userID = Get.arguments['userID'];
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        index.value = 10;
      }
    });
    super.onInit();
  }

  @override
  void onClose() {
    controller.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void checkedIndex(index) {
    this.index.value = index;
    controller.clear();
    focusNode.unfocus();
  }

  void completed() async {
    var seconds = 0;
    if (index < 5) {
      switch (index.value) {
        case 0:
          seconds = 10 * 60;
          break;
        case 1:
          seconds = 1 * 60 * 60;
          break;
        case 2:
          seconds = 12 * 60 * 60;
          break;
        case 3:
          seconds = 24 * 60 * 60;
          break;
        default:
          seconds = 0;
          break;
      }
    }
    if (controller.text.isNotEmpty) {
      var day = double.parse(controller.text);
      seconds = (day * 24 * 60 * 60).toInt();
    }
    await LoadingView.singleton.wrap(asyncFunction: () async {
      await OpenIM.iMManager.groupManager.changeGroupMemberMute(
        groupID: groupID,
        userID: userID,
        seconds: seconds,
      );
    });
    IMViews.showToast(StrRes.setSuccessfully);
    Get.back();
  }
}
