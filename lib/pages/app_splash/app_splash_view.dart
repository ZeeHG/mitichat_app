import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'app_splash_logic.dart';

class AppSplashPage extends StatelessWidget {
  final logic = Get.find<AppSplashLogic>();

  AppSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: StylesLibrary.c_F7F8FA,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: Scaffold(
            backgroundColor: StylesLibrary.c_FFFFFF,
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: Center(
              child: ImageLibrary.appSplashLogo.toImage
                  ..width = 1.sw / 2.5
                  ..height = 1.sw / 2.5
            )));
  }
}
