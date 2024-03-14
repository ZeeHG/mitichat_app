import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

class LiveButton extends StatelessWidget {
  const LiveButton({
    Key? key,
    required this.text,
    required this.icon,
    this.onTap,
  }) : super(key: key);
  final String text;
  final String icon;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        icon.toImage
          ..width = 62.w
          ..height = 62.h
          ..onTap = onTap,
        10.verticalSpace,
        text.toText..style = Styles.ts_FFFFFF_opacity70_14sp,
      ],
    );
  }

  LiveButton.microphone({
    super.key,
    this.onTap,
    bool on = true,
  })  : text = StrLibrary.microphone,
        icon = on ? ImageRes.liveMicOn : ImageRes.liveMicOff;

  LiveButton.speaker({
    super.key,
    this.onTap,
    bool on = true,
  })  : text = StrLibrary.speaker,
        icon = on ? ImageRes.liveSpeakerOn : ImageRes.liveSpeakerOff;

  LiveButton.hungUp({
    super.key,
    this.onTap,
  })  : text = StrLibrary.hangUp,
        icon = ImageRes.liveHangUp;

  LiveButton.reject({
    super.key,
    this.onTap,
  })  : text = StrLibrary.reject,
        icon = ImageRes.liveHangUp;

  LiveButton.cancel({
    super.key,
    this.onTap,
  })  : text = StrLibrary.cancel,
        icon = ImageRes.liveHangUp;

  LiveButton.pickUp({
    super.key,
    this.onTap,
  })  : text = StrLibrary.pickUp,
        icon = ImageRes.livePicUp;
}
