import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import '../core/controller/app_ctrl.dart';

class MitiView extends StatelessWidget {
  MitiView({super.key, required this.builder});
  final Widget Function(Locale? locale, TransitionBuilder builder) builder;
  final appCommonCtrl = Get.find<AppCommonLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppCtrl>(
      init: AppCtrl(),
      builder: (appCtrl) => FocusDetector(
        onForegroundGained: () {
          appCtrl.runningBackground(false);
          appCommonCtrl.setForeground(true);
          // appCommonCtrl.tryUpdateAppFromCache();
        },
        onForegroundLost: () {
          appCtrl.runningBackground(true);
          appCommonCtrl.setForeground(false);
        },
        child: ScreenUtilInit(
          designSize: const Size(Config.uiW, Config.uiH),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) =>
              builder(appCtrl.getCurLocale(context), transitionWidgetBuilder()),
        ),
      ),
    );
  }

  static TransitionBuilder transitionWidgetBuilder() => EasyLoading.init(
        builder: (context, widget) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
            textScaler: const TextScaler.linear(Config.textScaleFactor),
          ),
          child: widget!,
        ),
      );
}
