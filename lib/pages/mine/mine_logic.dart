import 'dart:async';

import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../core/controller/im_controller.dart';
import '../../core/controller/push_controller.dart';
import '../../routes/app_navigator.dart';

class MineLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  late StreamSubscription kickedOfflineSub;

  void viewMyQrcode() => AppNavigator.startMyQrcode();

  void viewMyInfo() => AppNavigator.startMyInfo();

  void copyID() {
    IMUtils.copy(text: imLogic.userInfo.value.userID!);
  }

  void accountSetup() => AppNavigator.startAccountSetup();

  void aboutUs() => AppNavigator.startAboutUs();

  void logout() async {
    var confirm = await Get.dialog(CustomDialog(title: StrRes.logoutHint));
    if (confirm == true) {
      try {
        await LoadingView.singleton.wrap(asyncFunction: () async {
          await imLogic.logout();
          await DataSp.removeLoginCertificate();
          await DataSp.clearLockScreenPassword();
          await DataSp.closeBiometric();
          pushLogic.logout();
        });
        AppNavigator.startLogin();
      } catch (e) {
        IMViews.showToast('e:$e');
      }
    }
  }

  void kickedOffline() async {
    myLogger.e({"message": "mine_logic监听到用户kickedOffline, 退出登录"});
    PackageBridge.meetingBridge?.dismiss();
    PackageBridge.rtcBridge?.dismiss();
    Get.snackbar(StrRes.accountWarn, StrRes.accountException);
    await DataSp.removeLoginCertificate();
    pushLogic.logout();
    AppNavigator.startLogin();
  }

  kickedOfflineSubInit() {
    kickedOfflineSub = imLogic.onKickedOfflineSubject.listen((value) {
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
