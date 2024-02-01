import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'splash_logic.dart';

class SplashPage extends StatelessWidget {
  final logic = Get.find<SplashLogic>();

  SplashPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
            statusBarIconBrightness: Brightness.light,
            systemNavigationBarColor: Styles.c_F7F8FA,
            systemNavigationBarIconBrightness: Brightness.dark),
        child: Container(
          width: 1.sw,
          height: 1.sh,
          decoration: BoxDecoration(
            color: Styles.c_F7F8FA,
            image: const DecorationImage(
              fit: BoxFit.fill,
              image: AssetImage(ImageRes.splash, package: 'openim_common'),
            ),
          ),
        ));
  }
}
