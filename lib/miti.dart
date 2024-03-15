import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti/utils/conversation_util.dart';
import 'package:miti_common/miti_common.dart';
import 'core/ctrl/im_ctrl.dart';
import 'core/ctrl/push_ctrl.dart';
import 'routes/app_pages.dart';
import 'widgets/miti_view.dart';
import 'package:flutter/services.dart';

class Miti extends StatelessWidget {
  Miti({super.key});

  final appCommonLogic = Get.put(AppCommonLogic());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Styles.c_F7F8FA,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: MitiView(
          builder: (locale, transitionWidgetBuilder) => GetMaterialApp(
            theme: getTheme(Brightness.dark),
            navigatorObservers: [LoadingView.singleton],
            debugShowCheckedModeBanner: true,
            enableLog: true,
            builder: transitionWidgetBuilder,
            logWriterCallback: Logger.print,
            translations: TranslationCtrl(),
            localizationsDelegates: const [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            fallbackLocale: TranslationCtrl.fallbackLocale,
            locale: locale,
            localeResolutionCallback: (locale, list) {
              Get.locale ??= locale;
              return locale;
            },
            supportedLocales: const [
              Locale('zh', 'CN'),
              Locale('en', 'US'),
              Locale('ja', 'JP'),
              Locale('ko', 'KR'),
              Locale('es', 'ES'),
            ],
            getPages: AppPages.routes,
            initialBinding: AppBinding(),
            initialRoute: AppRoutes.splash,
          ),
        ));
  }

  ThemeData getTheme(Brightness brightness) {
    return ThemeData(
        fontFamily: Platform.isIOS ? 'PingFang SC' : null,
        fontFamilyFallback: [if (Platform.isIOS) "PingFang SC", "sans-serif"],
        dialogBackgroundColor: Styles.c_FFFFFF,
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent, modalElevation: 0),
        dialogTheme: const DialogTheme(elevation: 0));
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IMCtrl>(IMCtrl());
    Get.put<PushCtrl>(PushCtrl());
    Get.put<CacheController>(CacheController());
    Get.put<DownloadController>(DownloadController());
    Get.put(BetaTestLogic());
    Get.put(AccountUtil());
    Get.put(AiUtil());
    Get.put(ConversationUtil());
    Get.put(TranslateLogic());
    Get.put(TtsLogic());

    final conversationUtil = Get.find<ConversationUtil>();
    conversationUtil.resetAllWaitingST();
  }
}
