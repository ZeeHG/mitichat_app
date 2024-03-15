import 'dart:async';

import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../core/controller/im_ctrl.dart';
import '../../core/controller/push_ctrl.dart';
import '../../routes/app_navigator.dart';

class MineLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  late StreamSubscription kickedOfflineSub;

  void viewMyQrcode() => AppNavigator.startMyQrcode();

  void viewMyInfo() => AppNavigator.startMyInfo();

  void copyID() {
    IMUtils.copy(text: imCtrl.userInfo.value.userID!);
  }

  void accountSetup() => AppNavigator.startAccountSetup();

  void myPoints() => AppNavigator.startMyPoints();

  void aboutUs() => AppNavigator.startAboutUs();

  void logout() async {
    var confirm = await Get.dialog(CustomDialog(title: StrLibrary.logoutHint));
    if (confirm == true) {
      try {
        await LoadingView.singleton.start(fn: () async {
          await imCtrl.logout();
          await DataSp.removeLoginCertificate();
          pushCtrl.logout();
        });
        imCtrl.reBuildSubject();
        AppNavigator.startLogin();
      } catch (e) {
        IMViews.showToast('e:$e');
      }
    }
  }

  void kickedOffline() async {
    myLogger.e({"message": "mine_logic监听到用户kickedOffline, 退出登录"});
    // PackageBridge.meetingBridge?.dismiss();
    PackageBridge.rtcBridge?.dismiss();
    Get.snackbar(StrLibrary.accountWarn, StrLibrary.accountException);
    await DataSp.removeLoginCertificate();
    pushCtrl.logout();
    AppNavigator.startLogin();
  }

  kickedOfflineSubInit() {
    kickedOfflineSub = imCtrl.onKickedOfflineSubject.listen((value) {
      kickedOffline();
    });
  }

  @override
  void onInit() {
    kickedOfflineSubInit();
    super.onInit();
  }

  @override
  void onClose() {
    kickedOfflineSub.cancel();
    super.onClose();
  }
}
