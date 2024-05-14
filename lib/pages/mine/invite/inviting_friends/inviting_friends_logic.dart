import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class InvitingFriendsLogic extends GetxController {
  final inviteInfos = <InviteInfo>[].obs;
  final hadHandle = false.obs;

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
      hadHandle.value = true;
      Get.back();
    });
  }

  showModal(InviteInfo inviteInfo) async {
    await Get.dialog(CustomDialog(
      title: sprintf(
          StrLibrary.inviteDialogTips, [inviteInfo.inviteUser.showName]),
      leftText: StrLibrary.reject,
      rightText: StrLibrary.accept,
      onTapLeft: () => agreeOrReject(inviteInfo, 2),
      onTapRight: () => agreeOrReject(inviteInfo, 1),
    ));
  }
}
