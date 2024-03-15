import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'dart:ui';
import '../../../core/controller/im_ctrl.dart';

class AccountSetupLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final curLanguage = "".obs;

  @override
  void onReady() {
    _updateLanguage();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }

  @override
  void onInit() {
    _queryMyFullInfo();
    super.onInit();
  }

  /// 全局免打扰 0：正常；1：不接受消息；2：接受在线消息不接受离线消息；
  bool get isGlobalNotDisturb => imCtrl.userInfo.value.globalRecvMsgOpt == 2;

  bool get isAllowAddFriend => imCtrl.userInfo.value.allowAddFriend == 1;

  bool get isAllowBeep => imCtrl.userInfo.value.allowBeep == 1;

  bool get isAllowVibration => imCtrl.userInfo.value.allowVibration == 1;

  void _queryMyFullInfo() async {
    final data = await LoadingView.singleton.start(
      fn: () => Apis.queryMyFullInfo(),
    );
    if (data is UserFullInfo) {
      final userInfo = UserFullInfo.fromJson(data.toJson());
      imCtrl.userInfo.update((val) {
        val?.allowAddFriend = userInfo.allowAddFriend;
        val?.allowBeep = userInfo.allowBeep;
        val?.allowVibration = userInfo.allowVibration;
      });
    }
  }

  void toggleNotDisturbMode() async {
    var status = isGlobalNotDisturb ? 0 : 2;
    await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.conversationManager
            .setGlobalRecvMessageOpt(status: status));
    imCtrl.userInfo.update((val) {
      val?.globalRecvMsgOpt = status;
    });
  }

  void toggleBeep() async {
    final allowBeep = !isAllowBeep ? 1 : 2;
    // 1关闭 2开启
    await LoadingView.singleton.start(
      fn: () => Apis.updateUserInfo(
        allowBeep: allowBeep,
        userID: OpenIM.iMManager.userID,
      ),
    );
    imCtrl.userInfo.update((val) {
      val?.allowBeep = allowBeep;
    });
  }

  void toggleVibration() async {
    final allowVibration = !isAllowVibration ? 1 : 2;
    // 1关闭 2开启
    await LoadingView.singleton.start(
      fn: () => Apis.updateUserInfo(
        allowVibration: allowVibration,
        userID: OpenIM.iMManager.userID,
      ),
    );
    imCtrl.userInfo.update((val) {
      val?.allowVibration = allowVibration;
    });
  }

  void toggleForbidAddMeToFriend() async {
    final allowAddFriend = !isAllowAddFriend ? 1 : 2;
    // 1关闭 2开启
    final data = await LoadingView.singleton.start(
      fn: () => Apis.updateUserInfo(
        allowAddFriend: allowAddFriend,
        userID: OpenIM.iMManager.userID,
      ),
    );
    imCtrl.userInfo.update((val) {
      val?.allowAddFriend = allowAddFriend;
    });
  }

  void blacklist() => AppNavigator.startBlacklist();

  void clearChatHistory() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrLibrary.confirmClearChatHistory,
    ));
    if (confirm == true) {
      LoadingView.singleton.start(fn: () async {
        await OpenIM.iMManager.messageManager.deleteAllMsgFromLocalAndSvr();
      });
    }
  }

  void languageSetting() => AppNavigator.startLanguageSetup();

  void _updateLanguage() {
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

  void unlockSetup() => AppNavigator.startUnlockSetup();

  void changePwd() => AppNavigator.startChangePassword();

  void goAccountAndSecurity() => AppNavigator.startAccountAndSecurity();
}
