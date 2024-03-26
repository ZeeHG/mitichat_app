import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'dart:ui';
import '../../../core/ctrl/im_ctrl.dart';

class AccountSetupLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final curLanguage = "".obs;

  @override
  void onReady() {
    getLanguageName();
    super.onReady();
  }

  /// 全局免打扰 0：正常；1：不接受消息；2：接受在线消息不接受离线消息；
  bool get isGlobalNotDisturb => imCtrl.userInfo.value.globalRecvMsgOpt == 2;

  bool get isAllowAddFriend => imCtrl.userInfo.value.allowAddFriend == 1;

  bool get isAllowBeep => imCtrl.userInfo.value.allowBeep == 1;

  bool get isAllowVibration => imCtrl.userInfo.value.allowVibration == 1;

  void toggleNotDisturbMode() async {
    final status = isGlobalNotDisturb ? 0 : 2;
    await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.conversationManager
            .setGlobalRecvMessageOpt(status: status));
    imCtrl.userInfo.update((val) {
      val?.globalRecvMsgOpt = status;
    });
  }

  void toggleBeep() async {
    final allowBeep = !isAllowBeep ? 1 : 2;
    updateUserInfo("allowBeep", allowBeep);
    // // 1关闭 2开启
    // await LoadingView.singleton.start(
    //   fn: () => Apis.updateUserInfo(
    //     allowBeep: allowBeep,
    //     userID: OpenIM.iMManager.userID,
    //   ),
    // );
    // imCtrl.userInfo.update((val) {
    //   val?.allowBeep = allowBeep;
    // });
  }

  void toggleVibration() async {
    final allowVibration = !isAllowVibration ? 1 : 2;
    updateUserInfo("allowVibration", allowVibration);
    // // 1关闭 2开启
    // await LoadingView.singleton.start(
    //   fn: () => Apis.updateUserInfo(
    //     allowVibration: allowVibration,
    //     userID: OpenIM.iMManager.userID,
    //   ),
    // );
    // imCtrl.userInfo.update((val) {
    //   val?.allowVibration = allowVibration;
    // });
  }

  void toggleForbidAddMeToFriend() async {
    final allowAddFriend = !isAllowAddFriend ? 1 : 2;
    updateUserInfo("allowAddFriend", allowAddFriend);
    // // 1关闭 2开启
    // await LoadingView.singleton.start(
    //   fn: () => Apis.updateUserInfo(
    //     allowAddFriend: allowAddFriend,
    //     userID: OpenIM.iMManager.userID,
    //   ),
    // );
    // imCtrl.userInfo.update((val) {
    //   val?.allowAddFriend = allowAddFriend;
    // });
  }

  Future<void> updateUserInfo(String key, int value) async {
    switch (key) {
      case 'allowAddFriend':
        await Apis.updateUserInfo(
            allowAddFriend: value, userID: OpenIM.iMManager.userID);
        imCtrl.userInfo.update((val) {
          val?.allowAddFriend = value;
        });
        break;
      case 'allowVibration':
        await Apis.updateUserInfo(
            allowVibration: value, userID: OpenIM.iMManager.userID);
        imCtrl.userInfo.update((val) {
          val?.allowVibration = value;
        });
        break;
      case 'allowBeep':
        await Apis.updateUserInfo(
            allowBeep: value, userID: OpenIM.iMManager.userID);
        imCtrl.userInfo.update((val) {
          val?.allowBeep = value;
        });
        break;
    }
  }

  void clearChatHistory() async {
    final confirm = await Get.dialog(CustomDialog(
      title: StrLibrary.confirmClearChatHistory,
    ));
    if (confirm == true) {
      LoadingView.singleton.start(fn: () async {
        await OpenIM.iMManager.messageManager.deleteAllMsgFromLocalAndSvr();
      });
    }
  }

  void getLanguageName() {
    Locale systemLocal = PlatformDispatcher.instance.locale;
    var language = DataSp.getLanguage();
    var index = (language != null && language != 0)
        ? language
        : (systemLocal.toString().startsWith("zh_") ? 1 : 2);
    switch (index) {
      case 1:
        curLanguage.value = StrLibrary.chinese;
        break;
      case 2:
        curLanguage.value = StrLibrary.english;
        break;
      case 3:
        curLanguage.value = StrLibrary.japanese;
        break;
      case 4:
        curLanguage.value = StrLibrary.korean;
        break;
      case 5:
        curLanguage.value = StrLibrary.spanish;
        break;
      default:
        curLanguage.value = StrLibrary.followSystem;
        break;
    }
  }

  void blacklist() => AppNavigator.startBlacklist();

  void languageSetting() async {
    await AppNavigator.startLanguageSetup();
    getLanguageName();
  }

  void unlockSetup() => AppNavigator.startUnlockSetup();

  void goAccountAndSecurity() => AppNavigator.startAccountAndSecurity();
}
