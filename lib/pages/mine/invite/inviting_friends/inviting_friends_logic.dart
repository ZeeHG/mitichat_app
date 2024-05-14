import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class InvitingFriendsLogic extends GetxController {
  final inviteInfos = <InviteInfo>[].obs;

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      final res = await ClientApis.queryApplyActiveList();
      inviteInfos.value = (List<InviteInfo>.from(res["applyList"]));
    });
  }

  agreeOrReject(InviteInfo inviteInfo, int result) {
    LoadingView.singleton.start(fn: () async {
      await ClientApis.responseApplyActive(
          invtedUserID: inviteInfo.inviteUser.userID!, result: result);
      inviteInfos.remove(inviteInfo);
    });
  }
}
