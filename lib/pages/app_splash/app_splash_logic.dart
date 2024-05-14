import 'dart:async';

import 'package:get/get.dart';
import 'package:miti/core/ctrl/app_ctrl.dart';
import 'package:miti_common/miti_common.dart';

import '../../core/ctrl/im_ctrl.dart';
import '../../core/ctrl/push_ctrl.dart';
import '../../routes/app_navigator.dart';
// import '../../utils/upgrade_manager.dart';

class AppSplashLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final appCtrl = Get.find<AppCtrl>();

//getxxx
  String? get userID => DataSp.userID;

  String? get token => DataSp.imToken;

  late StreamSubscription initializedSub;

  @override
  void onInit() async {
    initializedSub = imCtrl.initializedSubject.listen((value) async {
      myLogger.i({"message": "imSdk初始化完成", "data": value});
      try {
        final data = await ClientApis.querySupportRegistTypes();
        appCtrl.supportLoginTypes.value = List<int>.from(data["types"]).map((value) => SupportLoginTypeMap[value])
            .cast<SupportLoginType>().toList();
      } catch (e) {
        myLogger.e({"message": "获取支持的注册方式失败", "error": e});
      }
      await Future.delayed(const Duration(seconds: 2));
      if (null != userID && null != token) {
        await tryAutoLogin();
      } else {
        bool? isFirstUse = await DataSp.getfirstUse();
        if (true) {
          AppNavigator.welcome();
        } else {
          AppNavigator.startLogin();
        }
      }
      // autoCheckVersionUpgrade();
    });
    super.onInit();
  }

  tryAutoLogin() async {
    try {
      await imCtrl.login(userID!, token!);
      pushCtrl.login(userID!);
      translateLogic.init(userID!);
      ttsLogic.init(userID!);
      AppNavigator.startSplashToMain(isAutoLogin: true);
      myLogger.i({"message": "自动登录成功"});
    } catch (e, s) {
      showToast('$e $s');
      await DataSp.removeLoginCertificate();
      AppNavigator.startLogin();
      myLogger.e({"message": "自动登录失败, 回到登录页"});
    }
  }

  @override
  void onClose() {
    initializedSub.cancel();
    super.onClose();
  }
}
