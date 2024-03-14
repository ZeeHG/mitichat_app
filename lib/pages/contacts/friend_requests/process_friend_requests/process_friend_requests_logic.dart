import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class ProcessFriendRequestsLogic extends GetxController {
  late FriendApplicationInfo applicationInfo;

  @override
  void onInit() {
    applicationInfo = Get.arguments['applicationInfo'];
    super.onInit();
  }

  /// 接受好友申请
  void acceptFriendApplication() async {
    LoadingView.singleton
        .start(
            fn: () => OpenIM.iMManager.friendshipManager
                .acceptFriendApplication(userID: applicationInfo.fromUserID!))
        .then(_addSuccessfully)
        .catchError((_) => IMViews.showToast(StrLibrary.addFailed));
  }

  /// 拒绝好友申请
  void refuseFriendApplication() async {
    LoadingView.singleton
        .start(
            fn: () => OpenIM.iMManager.friendshipManager
                .refuseFriendApplication(userID: applicationInfo.fromUserID!))
        .then(_rejectSuccessfully)
        .catchError((_) => IMViews.showToast(StrLibrary.rejectFailed));
  }

  _addSuccessfully(_) {
    IMViews.showToast(StrLibrary.addSuccessfully);
    Get.back(result: 1);
    return _;
  }

  _rejectSuccessfully(_) {
    IMViews.showToast(StrLibrary.rejectSuccessfully);
    Get.back(result: -1);
    return _;
  }
}
