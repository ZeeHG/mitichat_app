import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:share_plus/share_plus.dart';

class InviteFriendsDetailLogic extends GetxController {
  final invitedTotal = 0.obs;
  final invitingTotal = 0.obs;
  final iMCtrl = Get.find<IMCtrl>();
  final hadHandle = false.obs;

  String get mitiID => iMCtrl.userInfo.value.mitiID ?? "";

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      final result = await Future.wait(
          [ClientApis.queryInvitedUsers(), ClientApis.queryApplyActiveList()]);
      invitedTotal.value = result[0]?["total"] ?? 0;
      invitingTotal.value = result[1]?["total"] ?? 0;
    });
  }

  share() {
    Share.share("${Config.inviteUrl}?mitiID=$mitiID");
  }

  startInviteFriends() async {
    final result = await AppNavigator.startInvitingFriends();
    if (result) {
      loadingData();
      hadHandle.value = true;
    }
  }
}
