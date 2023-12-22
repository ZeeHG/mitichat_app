import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as openim;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';

import '../pages/meeting_room/room.dart';
import 'no_video.dart';
import 'participant_info.dart';

extension LocalVideoTrackExt on ParticipantTrack {
  void toggleCamera() async {
    if (participant is! LocalParticipant) {
      return;
    }
    final track = videoTrack as LocalVideoTrack;

    try {
      final newPosition =
          (track.currentOptions as CameraCaptureOptions).cameraPosition ==
                  CameraPosition.front
              ? CameraPosition.back
              : CameraPosition.front;
      await track.setCameraPosition(newPosition);
    } catch (error) {
      print('could not restart track: $error');
      return;
    }
  }
}

abstract class ParticipantWidget extends StatefulWidget {
  // Convenience method to return relevant widget for participant
  static ParticipantWidget widgetFor(ParticipantTrack participantTrack,
      {bool useScreenShareTrack = false,
      bool isZoom = false,
      VoidCallback? onTapSwitchCamera}) {
    if (participantTrack.participant is LocalParticipant) {
      return LocalParticipantWidget(
          participantTrack.participant as LocalParticipant,
          participantTrack.videoTrack,
          participantTrack.screenShareTrack,
          participantTrack.isScreenShare,
          // participantTrack.useScreenShareTrack,
          useScreenShareTrack,
          participantTrack.isHost,
          isZoom:isZoom,
          onTapSwitchCamera);
    } else if (participantTrack.participant is RemoteParticipant) {
      return RemoteParticipantWidget(
          participantTrack.participant as RemoteParticipant,
          participantTrack.videoTrack,
          participantTrack.screenShareTrack,
          participantTrack.isScreenShare,
          // participantTrack.useScreenShareTrack,
          useScreenShareTrack,
          participantTrack.isHost,
          isZoom:isZoom,
          onTapSwitchCamera);
    }
    throw UnimplementedError('Unknown participant type');
  }

  // Must be implemented by child class
  abstract final Participant participant;
  abstract final VideoTrack? videoTrack;
  abstract final VideoTrack? screenShareTrack;
  abstract final bool isScreenShare;

  abstract final bool useScreenShareTrack;
  abstract final bool isHost;
  abstract final VoidCallback? onTapSwitchCamera;

  final VideoQuality quality;
  final bool isZoom;

  const ParticipantWidget({
    this.quality = VideoQuality.MEDIUM,
    this.isZoom = false,
    Key? key,
  }) : super(key: key);
}

class LocalParticipantWidget extends ParticipantWidget {
  @override
  final LocalParticipant participant;
  @override
  final VideoTrack? videoTrack;
  @override
  final VideoTrack? screenShareTrack;
  @override
  final bool isScreenShare;
  @override
  final bool useScreenShareTrack;
  @override
  final bool isHost;
  @override
  final VoidCallback? onTapSwitchCamera;

  const LocalParticipantWidget(
    this.participant,
    this.videoTrack,
    this.screenShareTrack,
    this.isScreenShare,
    this.useScreenShareTrack,
    this.isHost,
    this.onTapSwitchCamera, {
    Key? key,
    bool isZoom = false,
  }) : super(key: key, isZoom: isZoom);

  @override
  State<StatefulWidget> createState() => _LocalParticipantWidgetState();
}

class RemoteParticipantWidget extends ParticipantWidget {
  @override
  final RemoteParticipant participant;
  @override
  final VideoTrack? videoTrack;
  @override
  final VideoTrack? screenShareTrack;
  @override
  final bool isScreenShare;
  @override
  final bool useScreenShareTrack;
  @override
  final bool isHost;
  @override
  final VoidCallback? onTapSwitchCamera;

  const RemoteParticipantWidget(
    this.participant,
    this.videoTrack,
    this.screenShareTrack,
    this.isScreenShare,
    this.useScreenShareTrack,
    this.isHost,
    this.onTapSwitchCamera, {
    Key? key,
    bool isZoom = false,
  }) : super(key: key, isZoom: isZoom);

  @override
  State<StatefulWidget> createState() => _RemoteParticipantWidgetState();
}

abstract class _ParticipantWidgetState<T extends ParticipantWidget>
    extends State<T> {
  //
  VideoTrack? get activeVideoTrack;

  TrackPublication? get videoPublication;

  TrackPublication? get firstAudioPublication;

  @override
  void initState() {
    super.initState();
    widget.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
  }

  @override
  void dispose() {
    widget.participant.removeListener(_onParticipantChanged);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant T oldWidget) {
    oldWidget.participant.removeListener(_onParticipantChanged);
    widget.participant.addListener(_onParticipantChanged);
    _onParticipantChanged();
    super.didUpdateWidget(oldWidget);
  }

  // Notify Flutter that UI re-build is required, but we don't set anything here
  // since the updated values are computed properties.
  void _onParticipantChanged() => setState(() {
        _parseMetadata();
      });

  // Widgets to show above the info bar
  List<Widget> extraWidgets(bool isScreenShare) => [];

  openim.UserInfo? userInfo;

  void _parseMetadata() {
    try {
      if (widget.participant.metadata == null) return;
      var data = json.decode(widget.participant.metadata!);
      userInfo = openim.UserInfo.fromJson(data['userInfo']);
    } catch (error, stack) {
      Logger.print('$error $stack');
    }
  }

  @override
  Widget build(BuildContext ctx) => Container(
        foregroundDecoration: BoxDecoration(
          border: widget.participant.isSpeaking && !widget.isScreenShare
              ? Border.all(width: 5, color: Styles.c_0089FF)
              : null,
        ),
        decoration: const BoxDecoration(color: Color(0xFF666666)),
        child: Stack(
          children: [
            // Video
            activeVideoTrack != null && !activeVideoTrack!.muted
                ? widget.isZoom
                    ? GestureZoomBox(
                        maxScale: 5.0,
                        doubleTapScale: 2.0,
                        duration: const Duration(milliseconds: 200),
                        onScaleListener: (v) {
                          FirstPageZoomNotification(isZoom: v != 1)
                              .dispatch(context);
                        },
                        child: VideoTrackRenderer(
                          activeVideoTrack!,
                          fit: RTCVideoViewObjectFit
                              .RTCVideoViewObjectFitContain,
                        ),
                      )
                    : VideoTrackRenderer(
                        activeVideoTrack!,
                        fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitContain,
                      )
                : Align(
                    alignment: Alignment.center,
                    child: NoVideoAvatarWidget(
                      nickname: userInfo?.nickname,
                      faceURL: userInfo?.faceURL,
                      width: 70.w,
                      height: 70.h,
                    ),
                  ),
            if (widget.onTapSwitchCamera != null)
              Align(
                alignment: Alignment.topLeft,
                child: CupertinoButton(
                    onPressed: widget.onTapSwitchCamera,
                    child: const Icon(
                      Icons.switch_camera,
                      color: Colors.white,
                    )),
              ),
            // Bottom bar
            Align(
              alignment: Alignment.bottomCenter,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: [
                  ...extraWidgets(widget.isScreenShare),
                  ParticipantInfoWidget(
                    title: userInfo?.nickname,
                    audioAvailable: firstAudioPublication?.muted == false &&
                        firstAudioPublication?.subscribed == true,
                    connectionQuality: widget.participant.connectionQuality,
                    isScreenShare: widget.isScreenShare,
                    isHost: widget.isHost,
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _LocalParticipantWidgetState
    extends _ParticipantWidgetState<LocalParticipantWidget> {
  @override
  LocalTrackPublication<LocalVideoTrack>? get videoPublication =>
      widget.participant.videoTracks
          .where((element) => element.sid == widget.videoTrack?.sid)
          .firstOrNull;

  @override
  LocalTrackPublication<LocalAudioTrack>? get firstAudioPublication =>
      widget.participant.audioTracks.firstOrNull;

  @override
  VideoTrack? get activeVideoTrack => widget.useScreenShareTrack
      ? (widget.screenShareTrack ?? widget.videoTrack)
      : widget.videoTrack;
}

class _RemoteParticipantWidgetState
    extends _ParticipantWidgetState<RemoteParticipantWidget> {
  @override
  RemoteTrackPublication<RemoteVideoTrack>? get videoPublication =>
      widget.participant.videoTracks
          .where((element) => element.sid == widget.videoTrack?.sid)
          .firstOrNull;

  @override
  RemoteTrackPublication<RemoteAudioTrack>? get firstAudioPublication =>
      widget.participant.audioTracks.firstOrNull;

  @override
  VideoTrack? get activeVideoTrack => widget.useScreenShareTrack
      ? (widget.screenShareTrack ?? widget.videoTrack)
      : widget.videoTrack;
}
