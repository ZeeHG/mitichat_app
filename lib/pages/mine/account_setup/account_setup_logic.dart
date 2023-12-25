import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'dart:ui';
import '../../../core/controller/im_controller.dart';

class AccountSetupLogic extends GetxController {
  final imLogic = Get.find<IMController>();
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
  bool get isGlobalNotDisturb => imLogic.userInfo.value.globalRecvMsgOpt == 2;

  bool get isAllowAddFriend => imLogic.userInfo.value.allowAddFriend == 1;

  bool get isAllowBeep => imLogic.userInfo.value.allowBeep == 1;

  bool get isAllowVibration => imLogic.userInfo.value.allowVibration == 1;

  void _queryMyFullInfo() async {
    final data = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.queryMyFullInfo(),
    );
    if (data is UserFullInfo) {
      final userInfo = UserFullInfo.fromJson(data.toJson());
      imLogic.userInfo.update((val) {
        val?.allowAddFriend = userInfo.allowAddFriend;
        val?.allowBeep = userInfo.allowBeep;
        val?.allowVibration = userInfo.allowVibration;
      });
    }
  }

  void toggleNotDisturbMode() async {
    var status = isGlobalNotDisturb ? 0 : 2;
    await LoadingView.singleton.wrap(asyncFunction: () => OpenIM.iMManager.conversationManager.setGlobalRecvMessageOpt(status: status));
    imLogic.userInfo.update((val) {
      val?.globalRecvMsgOpt = status;
    });
  }

  void toggleBeep() async {
    final allowBeep = !isAllowBeep ? 1 : 2;
    // 1关闭 2开启
    await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.updateUserInfo(
        allowBeep: allowBeep,
        userID: OpenIM.iMManager.userID,
      ),
    );
    imLogic.userInfo.update((val) {
      val?.allowBeep = allowBeep;
    });
  }

  void toggleVibration() async {
    final allowVibration = !isAllowVibration ? 1 : 2;
    // 1关闭 2开启
    await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.updateUserInfo(
        allowVibration: allowVibration,
        userID: OpenIM.iMManager.userID,
      ),
    );
    imLogic.userInfo.update((val) {
      val?.allowVibration = allowVibration;
    });
  }

  void toggleForbidAddMeToFriend() async {
    final allowAddFriend = !isAllowAddFriend ? 1 : 2;
    // 1关闭 2开启
    final data = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.updateUserInfo(
        allowAddFriend: allowAddFriend,
        userID: OpenIM.iMManager.userID,
      ),
    );
    imLogic.userInfo.update((val) {
      val?.allowAddFriend = allowAddFriend;
    });
  }

  void blacklist() => AppNavigator.startBlacklist();

  void clearChatHistory() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrRes.confirmClearChatHistory,
    ));
    if (confirm == true) {
      LoadingView.singleton.wrap(asyncFunction: () async {
        await OpenIM.iMManager.messageManager.deleteAllMsgFromLocalAndSvr();
      });
    }
  }

  void languageSetting() => AppNavigator.startLanguageSetup();

  void _updateLanguage() {
    Locale systemLocal = window.locale;
    var language = DataSp.getLanguage();
    var index = (language != null && language != 0)
        ? language
        : (systemLocal.toString().startsWith("zh_") ? 1 : 2);
    switch (index) {
      case 1:
        curLanguage.value = StrRes.chinese;
        break;
      case 2:
        curLanguage.value = StrRes.english;
        break;
      default:
        curLanguage.value = StrRes.followSystem;
        break;
    }
  }

  void unlockSetup() => AppNavigator.startUnlockSetup();

  void changePwd() => AppNavigator.startChangePassword();
}
