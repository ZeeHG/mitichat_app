import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_meeting/src/pages/meeting_room/room.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

/// 会议室
class MeetingClient implements MeetingBridge {
  MeetingClient._();

  static final MeetingClient _singleton = MeetingClient._();

  factory MeetingClient.singleton() {
    PackageBridge.meetingBridge ??= _singleton;
    return _singleton;
  }

  factory MeetingClient() {
    return MeetingClient.singleton();
  }

  @override
  bool get hasConnection => isBusy;

  @override
  void dismiss() {
    close();
  }

  OverlayEntry? _holder;
  bool isBusy = false;
  PublishSubject<MeetingStreamEvent>? subject;

  close() async {
    if (_holder != null) {
      _holder?.remove();
      _holder = null;
    }
    isBusy = false;
    subject?.close();
    subject = null;
    // The next line disables the wakelock again.
    if (await WakelockPlus.enabled) WakelockPlus.disable();
  }

  create(
    BuildContext ctx, {
    required String meetingName,
    required int startTime,
    required int duration,
  }) =>
      _connect(
        ctx,
        isCreate: true,
        meetingName: meetingName,
        startTime: startTime,
        duration: duration,
      );

  join(
    BuildContext ctx, {
    required String meetingID,
    String? meetingName,
    String? participantNickname,
  }) =>
      _connect(
        ctx,
        isCreate: false,
        meetingID: meetingID,
        meetingName: meetingName,
        participantNickname: participantNickname,
      );

  _connect(
    BuildContext ctx, {
    bool isCreate = true,
    String? meetingID,
    String? meetingName,
    int? startTime,
    int? duration,
    String? participantNickname,
  }) async {
    try {
      if (isBusy) return;
      isBusy = true;

      FocusScope.of(ctx).requestFocus(FocusNode());

      subject ??= PublishSubject();

      await LoadingView.singleton.wrap(asyncFunction: () async {
        late SignalingCertificate sc;
        if (isCreate) {
          sc = await OpenIM.iMManager.signalingManager.signalingCreateMeeting(
            meetingName: meetingName!,
            startTime: startTime!,
            meetingDuration: duration!,
          );
        } else {
          sc = await OpenIM.iMManager.signalingManager.signalingJoinMeeting(
            roomID: meetingID!,
            meetingName: meetingName,
            participantNickname: participantNickname,
          );
        }

        //create new room
        final room = Room();

        // Create a Listener before connecting
        final listener = room.createListener();

        // Try to connect to the room
        // This will throw an Exception if it fails for any reason.
        await room.connect(
          sc.liveURL!,
          sc.token!,
          roomOptions: const RoomOptions(
            dynacast: true,
            adaptiveStream: true,
            defaultCameraCaptureOptions: CameraCaptureOptions(params: VideoParametersPresets.h720_169),
            defaultVideoPublishOptions: VideoPublishOptions(
                simulcast: true,
                videoCodec: 'VP8',
                videoEncoding: VideoEncoding(
                  maxBitrate: 5 * 1000 * 1000,
                  maxFramerate: 15,
                )),
            defaultScreenShareCaptureOptions: ScreenShareCaptureOptions(useiOSBroadcastExtension: true, maxFrameRate: 15.0),
          ),
        );

        // The following line will enable the Android and iOS wakelock.
        if (!await WakelockPlus.enabled) WakelockPlus.enable();

        Overlay.of(ctx).insert(
          _holder = OverlayEntry(
            builder: (context) => MeetingRoom(
              room,
              listener,
              roomID: sc.roomID!,
              onClose: close,
            ),
          ),
        );
      });
    } catch (error, trace) {
      close();
      Logger.print("error:$error  stack:$trace");
      if (error.toString().contains('NotExist')) {
        IMViews.showToast(StrRes.meetingIsOver);
      } else {
        IMViews.showToast(StrRes.networkError);
      }
    }
  }

  invite({
    required String meetingID,
    required String meetingName,
    required int startTime,
    required int duration,
    String? userID,
    String? groupID,
  }) async =>
      OpenIM.iMManager.messageManager.sendMessage(
        userID: userID,
        groupID: groupID,
        message: await OpenIM.iMManager.messageManager.createMeetingMessage(
          inviterUserID: OpenIM.iMManager.userInfo.userID!,
          inviterNickname: OpenIM.iMManager.userInfo.nickname ?? '',
          inviterFaceURL: OpenIM.iMManager.userInfo.faceURL,
          subject: meetingName,
          id: meetingID,
          start: startTime,
          duration: duration,
        ),
        offlinePushInfo: Config.offlinePushInfo..title = StrRes.offlineMeetingMessage,
      );
}
