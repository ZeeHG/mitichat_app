import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class HandleFriendRequestsLogic extends GetxController {
  late FriendApplicationInfo applicationInfo;

  @override
  void onInit() {
    super.onInit();
    applicationInfo = Get.arguments['applicationInfo'];
  }

  /// 接受好友申请
  void acceptFriendApplication() async {
    LoadingView.singleton.start(fn: () async {
      await OpenIM.iMManager.friendshipManager
          .acceptFriendApplication(userID: applicationInfo.fromUserID!);
      showToast(StrLibrary.addSuccessfully);
      Get.back(result: 1);
    }).catchError((e) => showToast(StrLibrary.addFailed));
  }

  /// 拒绝好友申请
  void refuseFriendApplication() async {
    LoadingView.singleton.start(fn: () async {
      await OpenIM.iMManager.friendshipManager
          .refuseFriendApplication(userID: applicationInfo.fromUserID!);
      showToast(StrLibrary.rejectSuccessfully);
      Get.back(result: -1);
    }).catchError((e) => showToast(StrLibrary.rejectFailed));
  }
}
