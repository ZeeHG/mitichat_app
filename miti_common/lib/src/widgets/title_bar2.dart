import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class TitleBar2 extends StatelessWidget implements PreferredSizeWidget {
  const TitleBar2(
      {Key? key,
      this.height,
      this.left,
      this.center,
      this.right,
      this.backgroundColor,
      this.backgroundImage})
      : super(key: key);
  final double? height;
  final Widget? left;
  final Widget? center;
  final Widget? right;
  final Color? backgroundColor;
  final DecorationImage? backgroundImage;

  @override
  Widget build(BuildContext context) {
    final mq = MediaQuery.of(context);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Container(
        decoration: BoxDecoration(
            color: backgroundColor ?? StylesLibrary.c_FFFFFF,
            image: backgroundImage),
        padding: EdgeInsets.only(top: mq.padding.top),
        child: Container(
          height: height,
          padding: EdgeInsets.symmetric(horizontal: 12.w),
          child: Stack(
            children: [
              if (null != left)
                Align(
                  alignment: Alignment.centerLeft,
                  child: left,
                ),
              if (null != center)
                Align(
                  alignment: Alignment.center,
                  child: center,
                ),
              if (null != right)
                Align(
                  alignment: Alignment.centerRight,
                  child: right,
                ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height ?? 44.h);

  TitleBar2.back(
      {super.key,
      String? title,
      TextStyle? titleStyle,
      Color? backgroundColor,
      Color? backIconColor,
      this.right,
      Function()? onTap,
      String? leftTitle,
      TextStyle? leftTitleStyle,
      this.backgroundImage})
      : height = 44.h,
        backgroundColor = backgroundColor ?? StylesLibrary.c_FFFFFF,
        center = (title ?? '').toText
          ..style = (titleStyle ?? StylesLibrary.ts_333333_18sp_medium)
          ..textAlign = TextAlign.center,
        left = GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap ?? (() => Get.back()),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ImageLibrary.appBackBlack.toImage
                ..width = 24.w
                ..height = 24.h
                ..color = backIconColor ?? StylesLibrary.c_333333,
              if (null != leftTitle)
                leftTitle.toText
                  ..style =
                      (leftTitleStyle ?? StylesLibrary.ts_333333_17sp_semibold),
            ],
          ),
        );
}
