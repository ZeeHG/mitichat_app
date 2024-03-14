import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import '../core/controller/app_controller.dart';

class MitiView extends StatelessWidget {
  MitiView({super.key, required this.builder});
  final Widget Function(Locale? locale, TransitionBuilder builder) builder;
  final appCommonLogic = Get.find<AppCommonLogic>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<AppController>(
      init: AppController(),
      builder: (appController) => FocusDetector(
        onForegroundGained: () {
          appController.runningBackground(false);
          appCommonLogic.setForeground(true);
          // appCommonLogic.tryUpdateAppFromCache();
        },
        onForegroundLost: () {
          appController.runningBackground(true);
          appCommonLogic.setForeground(false);
        },
        child: ScreenUtilInit(
          designSize: const Size(Config.uiW, Config.uiH),
          minTextAdapt: true,
          splitScreenMode: true,
          builder: (context, child) => builder(
              appController.getCurLocale(context), transitionWidgetBuilder()),
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
