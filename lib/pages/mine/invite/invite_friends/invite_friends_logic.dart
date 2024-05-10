import 'dart:async';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class InviteFriendsLogic extends GetxController {
  final myInviteRecords = [].obs;
  final imCtrl = Get.find<IMCtrl>();

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      final res = await ClientApis.querySelfApplyActive(
          userID: imCtrl.userInfo.value.userID!);
      myInviteRecords.value =
          (res?["applyList"] is List) ? (res?["applyList"]) : res?["applyTime"] != null? [res] : [];
    });
  }

  inviteDetail() {
    AppNavigator.startInviteFriendsDetail();
  }
}
