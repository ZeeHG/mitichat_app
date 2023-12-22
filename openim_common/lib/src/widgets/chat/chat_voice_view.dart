import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:openim_common/openim_common.dart';

class ChatVoiceView extends StatelessWidget {
  final bool isISend;
  final String? soundPath;
  final String? soundUrl;
  final int? duration;
  final bool isPlaying;

  const ChatVoiceView({
    Key? key,
    required this.isISend,
    this.soundPath,
    this.soundUrl,
    this.duration,
    this.isPlaying = false,
  }) : super(key: key);

  Widget _buildVoiceAnimView() {
    return isISend
        ? Row(
            // mainAxisSize: MainAxisSize.min,
            children: [
              '${duration ?? 0}``'.toText..style = Styles.ts_0C1C33_17sp,
              4.horizontalSpace,
              // if (widget.isPlaying)
              RotatedBox(
                quarterTurns: 90,
                child: isPlaying
                    ? (ImageRes.voiceBlackAnim.toLottie
                      ..height = 24.h
                      ..width = 24.w
                      ..fit = BoxFit.fitHeight)
                    : (ImageRes.voiceBlack.toImage
                      ..width = 24.w
                      ..height = 24.h),
              ),
              // else
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPlaying)
                ImageRes.voiceBlueAnim.toLottie
                  ..width = 24.w
                  ..height = 24.h
                  ..fit = BoxFit.fitHeight
              else
                ImageRes.voiceBlue.toImage
                  ..width = 24.w
                  ..height = 24.h,
              4.horizontalSpace,
              '${duration ?? 0}``'.toText..style = Styles.ts_0089FF_17sp,
            ],
          );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
        left: isISend ? _margin : 0,
        right: !isISend ? _margin : 0,
      ),
      child: _buildVoiceAnimView(),
    );
  }

  double get _margin {
    // 60  100.w
    // duration x
    final maxWidth = 100.w;
    const maxDuration = 60;
    double diff = (duration ?? 0) * maxWidth / maxDuration;
    return diff > maxWidth ? maxWidth : diff;
  }
}
