import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../core/controller/im_controller.dart';

enum EditAttr {
  nickname,
  englishName,
  telephone,
  mobile,
  email,
}

class EditMyInfoLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  late TextEditingController inputCtrl;
  late EditAttr editAttr;
  late int maxLength;
  String? title;
  String? defaultValue;
  TextInputType? keyboardType;

  @override
  void onInit() {
    editAttr = Get.arguments['editAttr'];
    maxLength = Get.arguments['maxLength'] ?? 60;
    _initAttr();
    inputCtrl = TextEditingController(text: defaultValue);
    super.onInit();
  }

  _initAttr() {
    switch (editAttr) {
      case EditAttr.nickname:
        title = StrLibrary.name;
        defaultValue = imLogic.userInfo.value.nickname;
        keyboardType = TextInputType.text;
        break;
      case EditAttr.englishName:
        // title = StrLibrary .englishName;
        // defaultValue = imLogic.userInfo.value.englishName;
        // keyboardType = TextInputType.text;
        break;
      case EditAttr.telephone:
        // title = StrLibrary .tel;
        // defaultValue = imLogic.userInfo.value.telephone;
        // keyboardType = TextInputType.phone;
        break;
      case EditAttr.mobile:
        title = StrLibrary.mobile;
        defaultValue = imLogic.userInfo.value.phoneNumber;
        keyboardType = TextInputType.phone;
        break;
      case EditAttr.email:
        title = StrLibrary.email;
        defaultValue = imLogic.userInfo.value.email;
        keyboardType = TextInputType.emailAddress;
        break;
    }
  }

  void save() async {
    final value = inputCtrl.text.trim();
    if (editAttr == EditAttr.nickname) {
      await LoadingView.singleton.start(
        fn: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          nickname: value,
        ),
      );
      imLogic.userInfo.update((val) {
        val?.nickname = value;
      });
    } else if (editAttr == EditAttr.mobile) {
      await LoadingView.singleton.start(
        fn: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          phoneNumber: value,
        ),
      );
      imLogic.userInfo.update((val) {
        val?.phoneNumber = value;
      });
    } else if (editAttr == EditAttr.email) {
      await LoadingView.singleton.start(
        fn: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          email: value,
        ),
      );
      imLogic.userInfo.update((val) {
        val?.email = value;
      });
    }
    Get.back();
  }
}
