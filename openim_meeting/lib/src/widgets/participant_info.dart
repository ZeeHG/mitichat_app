import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';

class ParticipantTrack {
  ParticipantTrack({
    required this.participant,
    required this.videoTrack,
    required this.screenShareTrack,
    // this.useScreenShareTrack = false,
    this.isHost = false,
  });

  VideoTrack? videoTrack;
  VideoTrack? screenShareTrack;
  Participant participant;
  // bool useScreenShareTrack;
  bool isHost;

  bool get isScreenShare => screenShareTrack != null;
}

class ParticipantInfoWidget extends StatelessWidget {
  //
  final String? title;
  final bool audioAvailable;
  final ConnectionQuality connectionQuality;
  final bool isScreenShare;
  final bool isHost;

  const ParticipantInfoWidget({
    this.title,
    this.audioAvailable = true,
    this.connectionQuality = ConnectionQuality.unknown,
    this.isScreenShare = false,
    this.isHost = false,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
        padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 10.w),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (isHost)
              ImageRes.meetingPerson.toImage
                ..width = 17.w
                ..height = 17.h,
            Container(
              decoration: BoxDecoration(
                color: Styles.c_0C1C33_opacity30,
                borderRadius: BorderRadius.circular(10.r),
              ),
              margin: EdgeInsets.only(left: 2.w),
              padding: EdgeInsets.symmetric(horizontal: 10.w, vertical: 2.h),
              child: Row(
                children: [
                  (audioAvailable
                          ? ImageRes.meetingMicOnWhite
                          : ImageRes.meetingMicOffWhite)
                      .toImage
                    ..width = 13.w
                    ..height = 13.h,
                  if (title != null)
                    title!.toText..style = Styles.ts_FFFFFF_12sp,
                  if (connectionQuality != ConnectionQuality.unknown)
                    Padding(
                      padding: const EdgeInsets.only(left: 5),
                      child: Icon(
                        connectionQuality == ConnectionQuality.poor
                            ? EvaIcons.wifiOffOutline
                            : EvaIcons.wifi,
                        color: {
                          ConnectionQuality.excellent: Colors.green,
                          ConnectionQuality.good: Colors.orange,
                          ConnectionQuality.poor: Colors.red,
                        }[connectionQuality],
                        size: 16,
                      ),
                    ),
                ],
              ),
            ),
            // isScreenShare
            //     ? const Padding(
            //         padding: EdgeInsets.only(left: 5),
            //         child: Icon(
            //           EvaIcons.monitor,
            //           color: Colors.white,
            //           size: 16,
            //         ),
            //       )
            //     : Padding(
            //         padding: const EdgeInsets.only(left: 5),
            //         child: Icon(
            //           audioAvailable ? EvaIcons.mic : EvaIcons.micOff,
            //           color: audioAvailable ? Colors.white : Colors.red,
            //           size: 16,
            //         ),
            //       ),
          ],
        ),
      );
}
