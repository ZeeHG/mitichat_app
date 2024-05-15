import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class InviteFriendsLogic extends GetxController {
  final users = <UserFullInfo>[].obs;
  final inviteInfos = <InviteInfo>[].obs;
  final applyTimes = <int>[].obs;

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: requestPageData);
  }

  Future requestPageData() async {
    final result = await Future.wait(
        [ClientApis.queryApplyActiveList(), ClientApis.queryInvitedUsers()]);
    inviteInfos.value = (List<InviteInfo>.from(result[0]["applyList"]));

    if (null != result[1]?["users"]) {
      users.value = List<UserFullInfo>.from(
          result[1]?["users"]!.map((e) => UserFullInfo.fromJson(e)).toList());
    }
    if (null != result[1]?["applyTimes"]) {
      applyTimes.value = List<int>.from(result[1]?["applyTimes"]);
    }
  }

  inviteDetail() async {
    final result = await AppNavigator.startInviteFriendsDetail();
    if (result) {
      loadingData();
    }
  }

  agreeOrReject(InviteInfo inviteInfo, int result) {
    LoadingView.singleton.start(fn: () async {
      await ClientApis.responseApplyActive(
          invtedUserID: inviteInfo.inviteUser.userID!, result: result);
      if (result == 2) {
        inviteInfos.remove(inviteInfo);
      } else {
        await requestPageData();
      }
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
