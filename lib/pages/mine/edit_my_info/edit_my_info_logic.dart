import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/controller/im_ctrl.dart';

enum EditAttr {
  nickname,
  englishName,
  telephone,
  mobile,
  email,
}

class EditMyInfoLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
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
        defaultValue = imCtrl.userInfo.value.nickname;
        keyboardType = TextInputType.text;
        break;
      case EditAttr.englishName:
        // title = StrLibrary .englishName;
        // defaultValue = imCtrl.userInfo.value.englishName;
        // keyboardType = TextInputType.text;
        break;
      case EditAttr.telephone:
        // title = StrLibrary .tel;
        // defaultValue = imCtrl.userInfo.value.telephone;
        // keyboardType = TextInputType.phone;
        break;
      case EditAttr.mobile:
        title = StrLibrary.mobile;
        defaultValue = imCtrl.userInfo.value.phoneNumber;
        keyboardType = TextInputType.phone;
        break;
      case EditAttr.email:
        title = StrLibrary.email;
        defaultValue = imCtrl.userInfo.value.email;
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
      imCtrl.userInfo.update((val) {
        val?.nickname = value;
      });
    } else if (editAttr == EditAttr.mobile) {
      await LoadingView.singleton.start(
        fn: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          phoneNumber: value,
        ),
      );
      imCtrl.userInfo.update((val) {
        val?.phoneNumber = value;
      });
    } else if (editAttr == EditAttr.email) {
      await LoadingView.singleton.start(
        fn: () => Apis.updateUserInfo(
          userID: OpenIM.iMManager.userID,
          email: value,
        ),
      );
      imCtrl.userInfo.update((val) {
        val?.email = value;
      });
    }
    Get.back();
  }
}
