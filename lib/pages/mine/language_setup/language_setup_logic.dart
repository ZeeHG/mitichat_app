import 'dart:ui';

import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class LanguageSetupLogic extends GetxController {
  final onOff = {
    "isFollowSystem": false.obs,
    "isChinese": false.obs,
    "isEnglish": false.obs,
    "isJapanese": false.obs,
    "isKorean": false.obs,
    "isSpanish": false.obs,
  };

  @override
  void onInit() {
    _initLanguageSetting();
    super.onInit();
  }

  void setLang(String key) {
    onOff.values.forEach((element) {
      element.value = false;
    });
    onOff[key]!.value = true;
  }

  void _initLanguageSetting() {
    Locale systemLocal = WidgetsBinding.instance.platformDispatcher.locale;
    var language = DataSp.getLanguage();
    var index = (language != null && language != 0)
        ? language
        : (systemLocal.toString().startsWith("zh_") ? 1 : 2);
    switch (index) {
      case 1:
        setLang("isChinese");
        break;
      case 2:
        setLang("isEnglish");
        break;
      case 3:
        setLang("isJapanese");
        break;
      case 4:
        setLang("isKorean");
        break;
      case 5:
        setLang("isSpanish");
        break;
      default:
        setLang("isFollowSystem");
        break;
    }
  }

  void switchLanguage(index) async {
    await DataSp.putLanguage(index);
    switch (index) {
      case 1:
        setLang("isChinese");
        Get.updateLocale(const Locale('zh', 'CN'));
        break;
      case 2:
        setLang("isEnglish");
        Get.updateLocale(const Locale('en', 'US'));
        break;
      case 3:
        setLang("isJapanese");
        Get.updateLocale(const Locale('ja', 'JP'));
        break;
      case 4:
        setLang("isKorean");
        Get.updateLocale(const Locale('ko', 'KR'));
        break;
      case 5:
        setLang("isSpanish");
        Get.updateLocale(const Locale('es', 'ES'));
        break;
      default:
        setLang("isFollowSystem");
        Get.updateLocale(WidgetsBinding.instance.platformDispatcher.locale);
        break;
    }
  }
}
