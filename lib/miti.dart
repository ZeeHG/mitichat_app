import 'dart:async';
import 'dart:io';

import 'package:app_links/app_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/app_ctrl.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti/utils/conversation_util.dart';
import 'package:miti/utils/message_util.dart';
import 'package:miti_common/miti_common.dart';
import 'core/ctrl/im_ctrl.dart';
import 'core/ctrl/push_ctrl.dart';
import 'routes/app_pages.dart';
import 'widgets/miti_view.dart';
import 'package:flutter/services.dart';

class Miti extends StatefulWidget {
  @override
  _MitiState createState() => _MitiState();
}

class _MitiState extends State<Miti> {
  final appCommonLogic = Get.put(AppCommonLogic());
  final appCtrl = Get.put(AppCtrl());
  late AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  @override
  void initState() {
    super.initState();
    initDeepLinks();
  }

  @override
  void dispose() {
    _linkSubscription?.cancel();
    super.dispose();
  }

  Future<void> initDeepLinks() async {
    _appLinks = AppLinks();

    _linkSubscription = _appLinks.uriLinkStream.listen((uri) {
      openAppLink(uri);
    });
  }

  void openAppLink(Uri uri) async {
    myLogger.i({
      "message": "app link",
      "data": {"uri": uri.toString()}
    });
    // todo 是否已经打开app, splash初始化, 是否以登录...
    if (uri.path == AppRoutes.activeAccount &&
        uri.queryParameters["mitiID"] != null) {
      final String inviteMitiID = uri.queryParameters["mitiID"]!.toString();

      if (Get.isRegistered<IMCtrl>()) {
        final imCtrl = Get.find<IMCtrl>();
        if (imCtrl.userInfo.value.isAlreadyActive != true) {
          await ClientApis.applyActive(inviteMitiID: inviteMitiID);
          showToast(StrLibrary.submitActiveSuccess);
        }
      } else {
        appCtrl.inviteMitiID.value = inviteMitiID;
      }
    } else {
      Get.toNamed(uri.path, arguments: uri.queryParameters);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: StylesLibrary.c_F7F8FA,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: MitiView(
          builder: (locale, transitionWidgetBuilder) => GetMaterialApp(
            theme: getTheme(Brightness.dark),
            navigatorObservers: [LoadingView.singleton],
            debugShowCheckedModeBanner: false,
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
        dialogBackgroundColor: StylesLibrary.c_FFFFFF,
        bottomSheetTheme: const BottomSheetThemeData(
            backgroundColor: Colors.transparent, modalElevation: 0),
        dialogTheme: const DialogTheme(elevation: 0));
  }
}

class AppBinding extends Bindings {
  @override
  void dependencies() {
    // Get.put(AppCtrl());
    Get.put<IMCtrl>(IMCtrl());
    Get.put<PushCtrl>(PushCtrl());
    Get.put<HiveCtrl>(HiveCtrl());
    Get.put<DownloadCtrl>(DownloadCtrl());
    Get.put(BetaTestLogic());
    Get.put(AccountUtil());
    Get.put(AiUtil());
    Get.put(ConversationUtil());
    Get.put(TranslateLogic());
    Get.put(TtsLogic());
    Get.put(MessageUtil());

    // final appCtrl = Get.find<AppCtrl>();
    // final imCtrl = Get.find<IMCtrl>();
    final conversationUtil = Get.find<ConversationUtil>();
    conversationUtil.resetAllWaitingST();

    // imCtrl.inviteApplySubject.listen((value) {
    //   appCtrl.promptInviteNotification(value);
    // });

    // imCtrl.inviteApplyHandleSubject.listen((value) {
    //   appCtrl.promptInviteHandleNotification(value);
    // });
  }
}
