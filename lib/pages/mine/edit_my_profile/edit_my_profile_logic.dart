import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/ctrl/im_ctrl.dart';

enum EditAttr {
  nickname,
}

class EditMyProfileLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  late TextEditingController inputCtrl;
  late EditAttr editKey;
  late int maxLength;
  String? title;
  String? defaultValue;
  TextInputType? keyboardType;

  @override
  void onInit() {
    editKey = Get.arguments['editAttr'];
    maxLength = Get.arguments['maxLength'] ?? 60;
    initInput();
    inputCtrl = TextEditingController(text: defaultValue);
    super.onInit();
  }

  initInput() {
    switch (editKey) {
      case EditAttr.nickname:
        title = StrLibrary.name;
        defaultValue = imCtrl.userInfo.value.nickname;
        keyboardType = TextInputType.text;
        break;
      default:
    }
  }

  void save() async {
    final value = inputCtrl.text.trim();
    if (editKey == EditAttr.nickname) {
      await LoadingView.singleton.start(
        fn: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          nickname: value,
        ),
      );
      imCtrl.userInfo.update((val) {
        val?.nickname = value;
      });
    }
    Get.back();
  }
}
