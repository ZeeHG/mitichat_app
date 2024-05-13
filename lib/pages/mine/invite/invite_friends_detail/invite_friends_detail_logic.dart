import 'dart:async';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti_common/miti_common.dart';

class InviteFriendsDetailLogic extends GetxController {
  final invitedTotal = 0.obs;
  final invitingTotal = 0.obs;
  final imCtrl = Get.find<IMCtrl>();

  get userID => imCtrl.userInfo.value.userID;

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      final res1 = await ClientApis.queryInvitedUsers();
      final res2 = await ClientApis.queryApplyActiveList();
      invitedTotal.value = res1?["total"] ?? 0;
      invitingTotal.value = res2?["total"] ?? 0;
    });
  }
}
