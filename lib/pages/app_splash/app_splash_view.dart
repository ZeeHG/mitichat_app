import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'app_splash_logic.dart';

class AppSplashPage extends StatelessWidget {
  final logic = Get.find<AppSplashLogic>();

  AppSplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.dark,
            systemNavigationBarColor: Styles.c_F7F8FA,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: Scaffold(
            backgroundColor: Styles.c_F7F8FA,
            extendBody: true,
            extendBodyBehindAppBar: true,
            body: const Stack(
              children: [
                Positioned.fill(
                  child: Image(
                    image: AssetImage(ImageRes.splash, package: 'miti_common'),
                    fit: BoxFit.fill,
                  ),
                ),
              ],
            )));
  }
}
