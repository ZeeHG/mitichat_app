import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';

import '../../openim_meeting.dart';
import 'controls.dart';
import 'participant_info.dart';

abstract class MeetingView extends StatefulWidget {
  const MeetingView(
    this.room,
    this.listener, {
    Key? key,
    required this.roomID,
    this.onClose,
  }) : super(key: key);
  final Room room;
  final EventsListener<RoomEvent> listener;
  final String roomID;
  final Function()? onClose;
}

abstract class MeetingViewState<T extends MeetingView> extends State<T> {
  final meetingInfoChangedSubject = BehaviorSubject<MeetingInfo>();
  final participantsSubject = BehaviorSubject<List<ParticipantTrack>>();
  final startTimerCompleter = Completer<bool>();

  bool minimize = false;

  bool _enableFullScreen = false;

  //Alignment(0.9, -0.9),
  double alignX = 0.9;
  double alignY = -0.9;

  MeetingInfo? meetingInfo;

  /// 主持是指的强制看他
  String? watchedUserID;

  /// 我点击的成员
  String? wasClickedUserID;

  bool get joinDisabledMicrophone => meetingInfo?.joinDisableMicrophone == true;

  bool get joinDisabledVideo => meetingInfo?.joinDisableVideo == true;

  String? get hostUserID => meetingInfo?.hostUserID;

  bool get _isLandscapeScreen {
    final orientation = MediaQuery.of(context).orientation;
    return orientation == Orientation.landscape;
  }

  @override
  void initState() {
    MeetingClient().subject?.stream.listen(meetingStreamChanged);
    super.initState();
  }

  @override
  void dispose() {
    meetingInfoChangedSubject.close();
    participantsSubject.close();
    _portraitScreen();
    super.dispose();
  }

  void meetingStreamChanged(MeetingStreamEvent data) {
    Logger.print('meetingStreamChanged: $data');
    if (data.roomID == meetingInfo?.roomID) {
      if (data.streamType == 'audio') {
        widget.room.localParticipant?.setMicrophoneEnabled(!data.mute!);
      } else {
        widget.room.localParticipant?.setCameraEnabled(!data.mute!);
      }
    }
  }

  customWatchedUser(String userID);

  /// 设置当前被看的流
  setWatchedTrack(ParticipantTrack track) {
    return track;
  }

  onMoveSmallWindow(DragUpdateDetails details) {
    final globalDy = details.globalPosition.dy;
    final globalDx = details.globalPosition.dx;
    setState(() {
      alignX = (globalDx - .5.sw) / .5.sw;
      alignY = (globalDy - .5.sh) / .5.sh;
    });
  }

  onTapMinimize() async {
    await _portraitScreen();
    setState(() {
      minimize = true;
    });
  }

  onTapMaximize() {
    setState(() {
      minimize = false;
    });
  }

  onInviteMembers() async {
    onTapMinimize();
    final meetingID = meetingInfo!.roomID!;
    final meetingName = meetingInfo!.meetingName!;
    final startTime = meetingInfo!.startTime!;
    final duration = meetingInfo!.endTime! - meetingInfo!.startTime!;
    // Logger.print('metaData meetingID : $meetingID');
    // Logger.print('metaData meetingName : $meetingName');
    // Logger.print('metaData startTime : $startTime');
    // Logger.print('metaData duration : $duration');
    final result = await PackageBridge.selectContactsBridge?.selectContacts(2);
    if (result is Map) {
      final list = IMUtils.convertCheckedListToShare(result.values);

      await LoadingView.singleton.wrap(
          asyncFunction: () => Future.forEach(
              list,
              (map) => MeetingClient().invite(
                    userID: map['userID'],
                    groupID: map['groupID'],
                    meetingID: meetingID,
                    meetingName: meetingName,
                    startTime: startTime,
                    duration: duration,
                  )));
      IMViews.showToast(StrRes.shareSuccessfully);
    }
  }

  void rotateScreen() {
    if (_isLandscapeScreen) {
      _portraitScreen();
    } else {
      _landscapeScreen();
    }
  }

  /// 还原为竖屏功能代码，一般写在 dispose()方法中，页面返回时执行
  static _portraitScreen() => SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
      ]);

  /// 实现全屏功能代码，一般写在按钮或者初始化函数里
  /// 全屏时旋转方向，左边
  static _landscapeScreen() => SystemChrome.setPreferredOrientations([
        DeviceOrientation.landscapeLeft, //全屏时旋转方向，左边
      ]);

  void toggleFullScreen() {
    setState(() {
      _enableFullScreen = !_enableFullScreen;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          AnimatedScale(
            scale: minimize ? 0 : 1,
            alignment: Alignment(alignX, alignY),
            duration: const Duration(milliseconds: 200),
            onEnd: () {},
            child: Material(
              color: Styles.c_000000,
              child: Stack(
                children: [
                  // ImageRes.liveBg.toImage
                  //   ..fit = BoxFit.cover
                  //   ..width = 1.sw
                  //   ..height = 1.sh,
                  if (widget.room.localParticipant != null)
                    ControlsView(
                      widget.room,
                      widget.room.localParticipant!,
                      meetingInfoChangedSubject: meetingInfoChangedSubject,
                      onClose: widget.onClose,
                      onMinimize: onTapMinimize,
                      onInviteMembers: onInviteMembers,
                      participantsSubject: participantsSubject,
                      startTimerCompleter: startTimerCompleter,
                      enableFullScreen: _enableFullScreen,
                      child: Container(
                        color: const Color(0xFF333333),
                        child: buildChild(),
                      ),
                    ),
                ],
              ),
            ),
          ),
          if (minimize)
            Align(
              alignment: Alignment(alignX, alignY),
              // alignment: const Alignment(0.9, -0.9),
              child: AnimatedOpacity(
                opacity: minimize ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  onTap: onTapMaximize,
                  onPanUpdate: onMoveSmallWindow,
                  child: Container(
                    width: 84.w,
                    height: 101.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6.r),
                      color: Styles.c_0C1C33_opacity60,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ImageRes.meetingVideo.toImage
                          ..width = 48.w
                          ..height = 48.h,
                        8.verticalSpace,
                        StrRes.videoMeeting.toText..style = Styles.ts_FFFFFF_12sp,
                      ],
                    ),
                  ),
                ),
              ),
            ),
        ],
      );

  Widget buildChild();
}
