import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sprintf/sprintf.dart';

class ImageButton extends StatelessWidget {
  const ImageButton({
    Key? key,
    required this.icon,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
    this.onTap,
    this.label,
    this.textStyle,
    this.expanded = false,
    this.enabled = true,
  }) : super(key: key);
  final String icon;
  final double? iconWidth;
  final double? iconHeight;
  final double? width;
  final double? height;
  final Function()? onTap;
  final String? label;
  final TextStyle? textStyle;
  final bool expanded;
  final bool enabled;

  const ImageButton.minimize({
    Key? key,
    this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
  })  : label = null,
        textStyle = null,
        icon = ImageRes.liveClose,
        enabled = true,
        expanded = false,
        super(key: key);

  const ImageButton.trumpet({
    Key? key,
    this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
    bool on = true,
  })  : label = null,
        textStyle = null,
        icon = on ? ImageRes.meetingTrumpet : ImageRes.meetingEar,
        expanded = false,
        enabled = true,
        super(key: key);

  const ImageButton.expandArrow({
    Key? key,
    this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
  })  : label = null,
        textStyle = null,
        icon = ImageRes.meetingExpandArrow,
        expanded = false,
        enabled = true,
        super(key: key);

  ImageButton.microphone({
    Key? key,
    this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
    bool on = true,
    this.enabled = true,
    this.textStyle,
  })  : label = on ? StrRes.meetingMute : StrRes.meetingUnmute,
        icon = on ? ImageRes.meetingMicOnWhite : ImageRes.meetingMicOffWhite,
        expanded = true,
        super(key: key);

  ImageButton.camera({
    Key? key,
    this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
    bool on = true,
    this.enabled = true,
    this.textStyle,
  })  : label = on ? StrRes.meetingCloseVideo : StrRes.meetingOpenVideo,
        icon =
            on ? ImageRes.meetingCameraOnWhite : ImageRes.meetingCameraOffWhite,
        expanded = true,
        super(key: key);

  ImageButton.screenShare({
    Key? key,
    this.onTap,
    bool on = true,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
    this.enabled = true,
    this.textStyle,
  })  : label = on ? StrRes.meetingEndSharing : StrRes.meetingShareScreen,
        icon =
            on ? ImageRes.meetingScreenShareOn : ImageRes.meetingScreenShareOff,
        expanded = true,
        super(key: key);

  ImageButton.members({
    Key? key,
    int count = 0,
    this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
    this.textStyle,
  })  : label = sprintf(StrRes.meetingMembers, [count]),
        icon = ImageRes.meetingMembers,
        expanded = true,
        enabled = true,
        super(key: key);

  ImageButton.settings({
    Key? key,
    this.onTap,
    this.iconWidth,
    this.iconHeight,
    this.width,
    this.height,
    this.textStyle,
  })  : label = StrRes.settings,
        icon = ImageRes.meetingSetting,
        expanded = true,
        enabled = true,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return expanded ? Expanded(child: _child) : _child;
  }

  Widget get _child => Material(
        color: Colors.transparent,
        child: Opacity(
          opacity: enabled ? 1 : .5,
          child: InkWell(
            onTap: enabled ? onTap : null,
            child: SizedBox(
              width: width,
              height: height,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  icon.toImage
                    ..width = (iconWidth ?? 30.w)
                    ..height = (iconHeight ?? 30.h),
                  if (null != label)
                    label!.toText..style = textStyle ?? Styles.ts_FFFFFF_10sp,
                ],
              ),
            ),
          ),
        ),
      );
}
