import 'dart:async';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti_common/miti_common.dart';

class InvitingFriendsLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final users = [].obs;

  get userID => imCtrl.userInfo.value.userID;

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      final res = await ClientApis.queryApplyActiveList();
      users.value = res?["applyList"] ?? [];
      // users.value = [
      //   {"applyTime": 12345678, "inviteUserID": "aaaa"}
      // ];
    });
  }

  agreeOrReject(dynamic user, int result) {
    LoadingView.singleton.start(fn: () async {
      await ClientApis.responseApplyActive(
          invtedUserID: user["inviteUserID"], result: result);
      user["disabled"] = true;
      users.refresh();
    });
  }
}
