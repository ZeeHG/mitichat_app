import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:miti_common/miti_common.dart';

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
              '${duration ?? 0}"'.toText..style = StylesLibrary.ts_FFFFFF_16sp,
              4.horizontalSpace,
              // if (widget.isPlaying)
              RotatedBox(
                quarterTurns: 2,
                child: isPlaying
                    ? (ImageLibrary.voiceWhiteAnim.toLottie
                      ..height = 20.h
                      ..width = 20.w
                      ..fit = BoxFit.fitHeight)
                    : (ImageLibrary.voiceBlack.toImage
                      ..width = 20.w
                      ..height = 20.h
                      ..color = StylesLibrary.c_FFFFFF),
              ),
              // else
            ],
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (isPlaying)
                ImageLibrary.voiceBlueAnim.toLottie
                  ..width = 20.w
                  ..height = 20.h
                  ..fit = BoxFit.fitHeight
              else
                ImageLibrary.voiceBlue.toImage
                  ..width = 20.w
                  ..height = 20.h,
              4.horizontalSpace,
              '${duration ?? 0}"'.toText..style = StylesLibrary.ts_333333_16sp,
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
