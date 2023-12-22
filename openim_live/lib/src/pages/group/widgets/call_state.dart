import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_live/src/pages/group/widgets/call_view.dart';
import 'package:openim_live/src/utils/live_utils.dart';
import 'package:openim_live/src/widgets/loading_view.dart';
import 'package:rxdart/rxdart.dart';

import '../../../../openim_live.dart';
import '../../../widgets/small_window.dart';
import 'controls.dart';
import 'participant.dart';
import 'participant_info.dart';

abstract class SignalView extends StatefulWidget {
  const SignalView({
    Key? key,
    required this.callType,
    required this.initState,
    required this.callEventSubject,
    this.roomID,
    required this.groupID,
    required this.inviterUserID,
    required this.inviteeUserIDList,
    this.onDial,
    this.onJoin,
    this.onTapCancel,
    this.onTapHangup,
    this.onTapPickup,
    this.onTapReject,
    this.onClose,
    required this.autoPickup,
    this.onBindRoomID,
    this.onError,
    this.onSyncGroupInfo,
    this.onSyncGroupMemberInfo,
    this.onRoomDisconnected,
  }) : super(key: key);
  final CallType callType;
  final CallState initState;
  final String? roomID;
  final String groupID;
  final String inviterUserID;
  final List<String> inviteeUserIDList;
  final PublishSubject<CallEvent> callEventSubject;
  final Future<SignalingCertificate> Function()? onDial;
  final Future<SignalingCertificate> Function()? onJoin;
  final Future<SignalingCertificate> Function()? onTapPickup;
  final Future Function()? onTapCancel;
  final Future Function(int duration, bool isPositive)? onTapHangup;
  final Future Function()? onTapReject;
  final Function()? onClose;
  final bool autoPickup;
  final Future<GroupInfo?> Function(String groupID)? onSyncGroupInfo;
  final Future<List<GroupMembersInfo>> Function(
      String groupID, List<String> userIDList)? onSyncGroupMemberInfo;
  final Function(String roomID)? onBindRoomID;
  final Function(dynamic error, dynamic stack)? onError;
  final Function()? onRoomDisconnected;
}

abstract class SignalState<T extends SignalView> extends State<T> {
  final callStateSubject = PublishSubject<CallState>();
  final roomDidUpdateSubject = PublishSubject<Room>();
  late CallState callState;
  late SignalingCertificate certificate;
  String? roomID;
  StreamSubscription? callEventSub;
  bool minimize = false;
  int duration = 0;
  bool enabledMicrophone = true;
  bool enabledSpeaker = true;
  GroupInfo? groupInfo;
  List<GroupMembersInfo> membersList = [];

  List<String> get memberIDList =>
      [widget.inviterUserID, ...widget.inviteeUserIDList];
  List<ParticipantTrack> participantTracks = [];

  bool get isVideoCall => widget.callType == CallType.video;

  @override
  void initState() {
    callState = widget.initState;
    callEventSub = sameRoomSignalStream.listen(_onStateDidUpdate);
    widget.onSyncGroupInfo?.call(widget.groupID).then(_onUpdateGroupInfo);
    widget.onSyncGroupMemberInfo
        ?.call(widget.groupID, memberIDList)
        .then(_onUpdateGroupMemberInfo);
    onDail();
    onJoin();
    autoPickup();
    super.initState();
  }

  @override
  void dispose() {
    callStateSubject.close();
    callEventSub?.cancel();
    super.dispose();
  }

  /// 过滤其他房间的信令
  Stream<CallEvent> get sameRoomSignalStream => widget.callEventSubject.stream
      .where((event) => LiveUtils.isSameRoom(event, widget.roomID));

  _onUpdateGroupInfo(GroupInfo? info) {
    if (!mounted && null != info) return;
    setState(() {
      groupInfo = info;
    });
  }

  _onUpdateGroupMemberInfo(List<GroupMembersInfo> list) {
    if (!mounted && list.isNotEmpty) return;
    setState(() {
      membersList = list;
    });
  }

  ///  某些信令通过liveKit的监听
  _onStateDidUpdate(CallEvent event) async {
    Logger.print("CallEvent : 当前：$callState  收到：$event");
    if (!mounted) return;
    // ui 状态只有 呼叫，被呼叫，通话中，连接中
    if (event.state == CallState.call ||
        event.state == CallState.beCalled ||
        event.state == CallState.calling) {
      callStateSubject.add(event.state);
    } else if (event.state == CallState.beCanceled) {
      widget.onClose?.call();
    }
  }

  onDail() async {
    if (callState == CallState.call) {
      callStateSubject.add(CallState.connecting);
      certificate = await widget.onDial!.call();
      widget.onBindRoomID?.call(roomID = certificate.roomID!);
      await connect();
    }
  }

  onJoin() async {
    if (callState == CallState.join) {
      callStateSubject.add(CallState.connecting);
      certificate = await widget.onJoin!.call();
      widget.onBindRoomID?.call(roomID = certificate.roomID!);
      await connect();
    }
  }

  autoPickup() {
    if (widget.autoPickup) {
      onTapPickup();
    }
  }

  onTapPickup() async {
    Logger.print('------------onTapPickup---------连接中--------');
    callStateSubject.add(CallState.connecting);
    certificate = await widget.onTapPickup!.call();
    widget.onBindRoomID?.call(roomID = certificate.roomID!);
    await connect();
    Logger.print('------------onTapPickup---------连接成功--------');
  }

  /// [isPositive] 人为挂断行为
  onTapHangup(bool isPositive) async {
    await widget.onTapHangup
        ?.call(duration, isPositive)
        .whenComplete(() => /*isPositive ? {} : */ widget.onClose?.call());
  }

  onTapCancel() async {
    await widget.onTapCancel?.call().whenComplete(() => widget.onClose?.call());
  }

  onTapReject() async {
    await widget.onTapReject?.call().whenComplete(() => widget.onClose?.call());
  }

  onTapMinimize() {
    setState(() {
      minimize = true;
    });
  }

  onTapMaximize() {
    setState(() {
      minimize = false;
    });
  }

  callingDuration(int duration) {
    this.duration = duration;
  }

  onChangedMicStatus(bool enabled) {
    enabledMicrophone = enabled;
  }

  onChangedSpeakerStatus(bool enabled) {
    enabledSpeaker = enabled;
  }

  Future<void> connect();

  //Alignment(0.9, -0.9),
  double alignX = 0.9;
  double alignY = -0.9;

  Alignment get moveAlign => Alignment(alignX, alignY);

  onMoveSmallWindow(DragUpdateDetails details) {
    final globalDy = details.globalPosition.dy;
    final globalDx = details.globalPosition.dx;
    setState(() {
      alignX = (globalDx - .5.sw) / .5.sw;
      alignY = (globalDy - .5.sh) / .5.sh;
    });
  }

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          AnimatedScale(
            scale: minimize ? 0 : 1,
            alignment: moveAlign,
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
                  ControlsView(
                    callStateStream: callStateSubject.stream,
                    roomDidUpdateStream: roomDidUpdateSubject.stream,
                    initState: widget.initState,
                    callType: widget.callType,
                    onMinimize: onTapMinimize,
                    onCallingDuration: callingDuration,
                    onEnabledMicrophone: onChangedMicStatus,
                    onEnabledSpeaker: onChangedSpeakerStatus,
                    onHangUp: onTapHangup,
                    onPickUp: onTapPickup,
                    onReject: onTapReject,
                    onCancel: onTapCancel,
                    onChangedCallState: (state) => callState = state,
                    child: (state) => participantTracks.isEmpty
                        ? (state == CallState.beCalled
                            ? BeCalledView(
                                callType: widget.callType,
                                inviterUserID: widget.inviterUserID,
                                inviteeUserIDList: widget.inviteeUserIDList,
                                groupInfo: groupInfo,
                                memberInfoList: membersList,
                              )
                            : const LiveLoadingView(status: true))
                        : CallingView(participantTracks: participantTracks),
                  ),
                ],
              ),
            ),
          ),
          if (minimize)
            Align(
              alignment: moveAlign,
              child: AnimatedOpacity(
                opacity: minimize ? 1 : 0,
                duration: const Duration(milliseconds: 200),
                child: SmallWindowView(
                  opacity: minimize ? 1 : 0,
                  callState: callState,
                  groupInfo: groupInfo,
                  onTapMaximize: onTapMaximize,
                  onPanUpdate: onMoveSmallWindow,
                  child: (state) {
                    if (participantTracks.isNotEmpty &&
                        state == CallState.calling &&
                        widget.callType == CallType.video) {
                      return SizedBox(
                        width: 120.w,
                        height: 180.h,
                        child: ParticipantWidget.widgetFor(
                            participantTracks.first),
                      );
                    }
                    return null;
                  },
                ),
              ),
            ),
        ],
      );
}
