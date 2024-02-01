import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class Button extends StatelessWidget {
  const Button({
    Key? key,
    required this.text,
    this.enabled = true,
    this.enabledColor,
    this.disabledColor,
    this.borderColor,
    this.radius,
    this.textStyle,
    this.disabledTextStyle,
    this.onTap,
    this.height,
    this.width,
    this.margin,
    this.padding,
  }) : super(key: key);
  final Color? enabledColor;
  final Color? disabledColor;
  final Color? borderColor;
  final double? radius;
  final TextStyle? textStyle;
  final TextStyle? disabledTextStyle;
  final String text;
  final double? height;
  final double? width;
  final Function()? onTap;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      child: Material(
        type: MaterialType.transparency,
        child: Ink(
          height: height ?? 44.h,
          width: width,
          decoration: BoxDecoration(
            color: enabled
                ? enabledColor ?? Styles.c_8443F8
                : disabledColor ?? Styles.c_8443F8_opacity50,
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            border: Border.all(color: borderColor ?? Colors.transparent),
          ),
          child: InkWell(
            onTap: enabled ? onTap : null,
            borderRadius: BorderRadius.circular(radius ?? 10.r),
            child: Container(
              alignment: Alignment.center,
              padding: padding,
              child: Text(
                text,
                style: enabled
                    ? textStyle ?? Styles.ts_FFFFFF_16sp
                    : disabledTextStyle ?? Styles.ts_FFFFFF_16sp,
                maxLines: 1,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ImageTextButton extends StatelessWidget {
  ImageTextButton({
    Key? key,
    required this.icon,
    required this.text,
    double? iconWidth,
    double? iconHeight,
    double? radius,
    this.textStyle,
    this.color,
    this.height,
    this.onTap,
  })  : iconWidth = iconWidth ?? 20.w,
        iconHeight = iconHeight ?? 20.h,
        radius = radius ?? 6.r,
        super(key: key);

  final String icon;
  final String text;
  final TextStyle? textStyle;
  final Color? color;
  final double? height;
  final double? iconWidth;
  final double? iconHeight;
  final double? radius;
  final Function()? onTap;

  ImageTextButton.call({super.key, this.onTap})
      : icon = ImageRes.audioAndVideoCall,
        text = StrRes.audioAndVideoCall,
        color = Styles.c_FFFFFF,
        textStyle = null,
        iconWidth = null,
        iconHeight = null,
        radius = null,
        height = null;

  ImageTextButton.message({super.key, this.onTap})
      : icon = ImageRes.message,
        text = StrRes.sendMessage,
        color = Styles.c_8443F8,
        textStyle = Styles.ts_FFFFFF_16sp,
        iconWidth = null,
        iconHeight = null,
        radius = null,
        height = null;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Ink(
        height: height ?? 46.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(radius ?? 0),
          color: color,
        ),
        child: InkWell(
          onTap: onTap,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon.toImage
                ..width = iconWidth
                ..height = iconHeight,
              7.horizontalSpace,
              text.toText..style = textStyle ?? Styles.ts_333333_16sp,
            ],
          ),
        ),
      ),
    );
  }
}
