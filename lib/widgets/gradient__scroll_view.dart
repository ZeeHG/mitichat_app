import 'package:flutter/material.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class GradientScrollView extends StatelessWidget {
  const GradientScrollView(
      {super.key, required this.child, this.isGradientBg = true});
  final Widget child;
  final bool isGradientBg;

  @override
  Widget build(BuildContext context) => KeyboardDismissOnTap(
          child: Scaffold(
              body: SizedBox.expand(
        child: isGradientBg
            ? Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Styles.c_8443F8_opacity10,
                      Styles.c_FFFFFF_opacity0,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: scrollContainer,
              )
            : scrollContainer,
      )));

  Widget get scrollContainer => SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            50.verticalSpace,
            Container(
              padding: EdgeInsets.only(left: 12.w),
              child: ImageRes.backBlack.toImage
                ..width = 24.w
                ..height = 24.h
                ..onTap = () => Get.back(),
            ),
            30.verticalSpace,
            Container(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child: child,
            ),
          ],
        ),
      );
}
