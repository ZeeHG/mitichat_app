import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../user_profile_logic.dart';

class SetRemarkLogic extends GetxController {
  final userProfilesLogic =
      Get.find<UserProfileLogic>(tag: GetTags.userProfile);
  late TextEditingController inputCtrl;

  void save() async {
    try {
      await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.friendshipManager.setFriendRemark(
          userID: userProfilesLogic.userInfo.value.userID!,
          remark: inputCtrl.text.trim(),
        ),
      );
      showToast(StrLibrary.saveSuccessfully);
      Get.back(result: inputCtrl.text.trim());
    } catch (s) {
      showToast(StrLibrary.saveFailed);
    }
  }

  @override
  void onInit() {
    super.onInit();
    inputCtrl =
        TextEditingController(text: userProfilesLogic.userInfo.value.remark);
  }

  @override
  void onClose() {
    super.onClose();
    inputCtrl.dispose();
  }
}
