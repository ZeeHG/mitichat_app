import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class UnreadCountView extends StatelessWidget {
  const UnreadCountView({
    Key? key,
    this.count = 0,
    this.size = 13,
    this.margin,
    this.showCount = true,
  }) : super(key: key);
  final int count;
  final double size;
  final EdgeInsetsGeometry? margin;
  final bool showCount;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: count > 0,
      child: Container(
        alignment: Alignment.center,
        margin: margin,
        padding: count > 99 ? EdgeInsets.symmetric(horizontal: 4.w) : null,
        constraints: BoxConstraints(maxHeight: size, minWidth: size),
        decoration: _decoration,
        child: showCount? _text : Container(),
      ),
    );
  }

  Text get _text => Text(
        '${count > 99 ? '99+' : count}',
        style: TextStyle(
          fontSize: 8.sp,
          color: const Color(0xFFFFFFFF),
        ),
        textAlign: TextAlign.center,
      );

  Decoration get _decoration => BoxDecoration(
        color: StylesLibrary.c_FF4E4C,
        shape: count > 99 ? BoxShape.rectangle : BoxShape.circle,
        borderRadius: count > 99 ? BorderRadius.circular(10.r) : null,
        boxShadow: [
          BoxShadow(
            color: const Color(0x26C61B4A),
            offset: Offset(1.15.w, 1.15.h),
            blurRadius: 57.58.r,
          ),
          BoxShadow(
            color: const Color(0x1AC61B4A),
            offset: Offset(2.3.w, 2.3.h),
            blurRadius: 11.52.r,
          ),
          BoxShadow(
            color: const Color(0x0DC61B4A),
            offset: Offset(4.61.w, 4.61.h),
            blurRadius: 17.28.r,
          ),
        ],
      );
}
