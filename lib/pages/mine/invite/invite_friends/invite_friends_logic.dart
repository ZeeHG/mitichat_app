import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

class InviteFriendsLogic extends GetxController {
  final myInviteRecords = <InviteInfo>[].obs;

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      myInviteRecords.value = await ClientApis.querySelfApplyActive();
    });
  }

  inviteDetail() {
    AppNavigator.startInviteFriendsDetail();
  }
}
