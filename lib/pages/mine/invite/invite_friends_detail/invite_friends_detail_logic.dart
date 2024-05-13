import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class InviteFriendsDetailLogic extends GetxController {
  final invitedTotal = 0.obs;
  final invitingTotal = 0.obs;

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
}
