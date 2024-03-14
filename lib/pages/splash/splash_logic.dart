import 'dart:async';

import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../core/controller/im_controller.dart';
import '../../core/controller/push_controller.dart';
import '../../routes/app_navigator.dart';
// import '../../utils/upgrade_manager.dart';

class SplashLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();

  String? get userID => DataSp.userID;

  String? get token => DataSp.imToken;

  late StreamSubscription initializedSub;

  @override
  void onInit() {
    initializedSub = imLogic.initializedSubject.listen((value) async {
      Logger.print('---------------------initialized---------------------');
      myLogger.i({"message": "imSdk初始化完成", "data": value});
      await Future.delayed(const Duration(seconds: 2));
      if (null != userID && null != token) {
        await _login();
      } else {
        AppNavigator.startLogin();
      }
      // autoCheckVersionUpgrade();
    });
    super.onInit();
  }

  _login() async {
    try {
      Logger.print('---------login---------- userID: $userID, token: $token');
      await imLogic.login(userID!, token!);
      Logger.print('---------im login success-------');
      translateLogic.init(userID!);
      ttsLogic.init(userID!);
      pushLogic.login(userID!);
      Logger.print('---------push login success----');
      AppNavigator.startSplashToMain(isAutoLogin: true);
    } catch (e, s) {
      IMViews.showToast('$e $s');
      await DataSp.removeLoginCertificate();
      AppNavigator.startLogin();
    }
  }

  @override
  void onClose() {
    initializedSub.cancel();
    super.onClose();
  }
}
