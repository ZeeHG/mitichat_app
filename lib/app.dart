import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'core/controller/im_controller.dart';
import 'core/controller/push_controller.dart';
import 'routes/app_pages.dart';
import 'widgets/app_view.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/services.dart';
import 'dart:io';

class ChatApp extends StatelessWidget {
  ChatApp({Key? key}) : super(key: key);

  final appCommonLogic = Get.put(AppCommonLogic());

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Styles.c_F7F8FA,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: AppView(
      builder: (locale, builder) => GetMaterialApp(
          theme: _buildTheme(context, Brightness.dark),
          navigatorObservers: [LoadingView.singleton],
          debugShowCheckedModeBanner: true,
          enableLog: true,
          builder: builder,
          logWriterCallback: Logger.print,
          translations: TranslationService(),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
            // DefaultCupertinoLocalizations.delegate,
          ],
          fallbackLocale: TranslationService.fallbackLocale,
          locale: locale,
          localeResolutionCallback: (locale, list) {
            Get.locale ??= locale;
            return locale;
          },
          supportedLocales: const [Locale('zh', 'CN'), Locale('en', 'US')],
          getPages: AppPages.routes,
          initialBinding: InitBinding(),
          initialRoute: AppRoutes.splash,
          // theme: ThemeData.light().copyWith(colorScheme: ColorScheme.fromSwatch())
          ),
    )
    );
  }

  ThemeData _buildTheme(BuildContext context, Brightness brightness) {
    // var baseTheme = ThemeData(brightness: brightness);

    return ThemeData(
      fontFamily: Theme.of(context).platform == TargetPlatform.iOS
          ? 'PingFang SC'
          : null,
      // fontFamilyFallback:
      //     Theme.of(context).platform == TargetPlatform.iOS ? null : null,
    );

    // return baseTheme.copyWith(
    //   textTheme: GoogleFonts.robotoTextTheme(baseTheme.textTheme)
    // );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IMController>(IMController());
    Get.put<PushController>(PushController());
    Get.put<CacheController>(CacheController());
    Get.put<DownloadController>(DownloadController());
    Get.put(TranslateLogic());
    Get.put(BetaTestLogic());
  }
}
