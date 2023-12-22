import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'core/controller/im_controller.dart';
import 'core/controller/push_controller.dart';
import 'routes/app_pages.dart';
import 'widgets/app_view.dart';

class ChatApp extends StatelessWidget {
  const ChatApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppView(
      builder: (locale, builder) => GetMaterialApp(
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
          theme: ThemeData.light().copyWith(colorScheme: ColorScheme.fromSwatch())),
    );
  }
}

class InitBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<IMController>(IMController());
    Get.put<PushController>(PushController());
    Get.put<CacheController>(CacheController());
    Get.put<DownloadController>(DownloadController());
  }
}
