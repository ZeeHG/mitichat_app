import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/pages/home/home_logic.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';

import '../../core/ctrl/im_ctrl.dart';
import '../../core/ctrl/push_ctrl.dart';
import '../../routes/app_navigator.dart';

class MineLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  late StreamSubscription kickedSub;
  final accountUtil = Get.find<AccountUtil>();
  final homeLogic = Get.find<HomeLogic>();

  bool get isAlreadyActive => imCtrl.userInfo.value.isAlreadyActive == true;

  void viewMyQrcode() => AppNavigator.startMyQrcode();

  void viewMyInfo() => AppNavigator.startMyInfo();

  void viewInviteFriends() async {
    await AppNavigator.startInviteFriends();
    homeLogic.getUnHandleInviteCount();
  }

  void viewAccountActiveEntry() => AppNavigator.startActiveAccountEntry();

  void copyID() {
    if (null != imCtrl.userInfo.value.mitiID) {
      MitiUtils.copy(text: imCtrl.userInfo.value.mitiID!);
    }
  }

  void accountSetting() => AppNavigator.startAccountSetting();

  void myPoints() => AppNavigator.startMyPoints();

  void aboutUs() => AppNavigator.startAboutUs();

  void logout() async {
    final confirm =
        await Get.dialog(CustomDialog(title: StrLibrary.logoutHint));
    if (confirm == true) {
      try {
        await LoadingView.singleton.start(fn: () async {
          await accountUtil.tryLogout();
        });
        imCtrl.reBuildSubject();
        AppNavigator.startLogin();
      } catch (e, s) {
        showToast('$e');
        myLogger.e({"message": "退出登录异常", "error": e, "stack": s});
      }
    }
  }

  void kickedOffline() async {
    myLogger.e({"message": "mine监听到用户kickedOffline, 退出登录"});
    MitiBridge.rtcBridge?.dismiss();
    Get.snackbar(StrLibrary.accountWarn, StrLibrary.accountException);
    // await DataSp.removeLoginCertificate();
    await accountUtil.tryLogout();
    AppNavigator.startLogin();
  }

  kickedSubInit() {
    kickedSub = imCtrl.onKickedOfflineSubject.listen((value) {
      kickedOffline();
    });
  }

  @override
  void onInit() {
    kickedSubInit();
    imCtrl.queryMyFullInfo();
    super.onInit();
  }

  @override
  void onClose() {
    kickedSub.cancel();
    super.onClose();
  }
}
