import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_live/src/widgets/live_button.dart';
import 'package:synchronized/synchronized.dart';

import '../../../live_client.dart';

class ControlsView extends StatefulWidget {
  const ControlsView({
    Key? key,
    this.child,
    this.initState = CallState.call,
    this.callType = CallType.video,
    required this.callStateStream,
    required this.roomDidUpdateStream,
    this.onMinimize,
    this.onCallingDuration,
    this.onEnabledMicrophone,
    this.onEnabledSpeaker,
    this.onCancel,
    this.onHangUp,
    this.onPickUp,
    this.onReject,
    this.onChangedCallState,
  }) : super(key: key);
  final Widget? Function(CallState state)? child;
  final Stream<Room> roomDidUpdateStream;
  final Stream<CallState> callStateStream;
  final CallState initState;
  final CallType callType;
  final Function()? onMinimize;
  final Function(int duration)? onCallingDuration;
  final Function(bool enabled)? onEnabledMicrophone;
  final Function(bool enabled)? onEnabledSpeaker;
  final Function()? onPickUp;
  final Function()? onCancel;
  final Function()? onReject;
  final Function(bool isPositive)? onHangUp;
  final Function(CallState state)? onChangedCallState;

  @override
  State<ControlsView> createState() => _ControlsViewState();
}

class _ControlsViewState extends State<ControlsView> {
  late CallState _callState;
  Timer? _callingTimer;
  int _callingDuration = 0;
  String _callingDurationStr = "00:00";

  //
  CameraPosition position = CameraPosition.front;

  List<MediaDevice>? _audioInputs;
  List<MediaDevice>? _audioOutputs;
  List<MediaDevice>? _videoInputs;

  StreamSubscription<CallState>? _callStateChangedSub;
  StreamSubscription? _deviceChangeSub;
  StreamSubscription<Room>? _roomDidUpdateSub;

  Room? _room;
  LocalParticipant? _participant;

  /// 默认启用麦克风
  bool _enabledMicrophone = true;

  /// 默认开启扬声器
  bool _enabledSpeaker = true;

  final _lockAudio = Lock();
  final _lockSpeaker = Lock();

  @override
  void dispose() {
    _callStateChangedSub?.cancel();
    _roomDidUpdateSub?.cancel();
    _callingTimer?.cancel();
    _deviceChangeSub?.cancel();
    _participant?.removeListener(_onChange);
    super.dispose();
  }

  @override
  void initState() {
    _onChangedCallState(widget.initState);
    _callStateChangedSub = widget.callStateStream.listen(_onChangedCallState);
    _roomDidUpdateSub = widget.roomDidUpdateStream.listen(_roomDidUpdate);
    // _queryUserInfo();

    _deviceChangeSub =
        Hardware.instance.onDeviceChange.stream.listen(_loadDevices);
    Hardware.instance.enumerateDevices().then(_loadDevices);
    super.initState();
  }

  _roomDidUpdate(Room room) {
    _room ??= room;
    if (room.localParticipant != null && _participant == null) {
      _participant = room.localParticipant;
      _participant?.addListener(_onChange);
    }
  }

  _onChangedCallState(CallState state) {
    if (!mounted) return;
    widget.onChangedCallState?.call(state);
    setState(() {
      _callState = state;
      if (_callState == CallState.calling) {
        _startCallingTimer();
      }
    });
  }

  void _startCallingTimer() {
    _callingTimer ??= Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      setState(() {
        _callingDurationStr = IMUtils.seconds2HMS(++_callingDuration);
        widget.onCallingDuration?.call(_callingDuration);
      });
    });
  }

  void _loadDevices(List<MediaDevice> devices) async {
    _audioInputs = devices.where((d) => d.kind == 'audioinput').toList();
    _audioOutputs = devices.where((d) => d.kind == 'audiooutput').toList();
    _videoInputs = devices.where((d) => d.kind == 'videoinput').toList();
    // setState(() {});
  }

  void _onChange() {
    // trigger refresh
    setState(() {});
  }

  void _toggleAudio() async {
    await _lockAudio.synchronized(() async {
      _enabledMicrophone = !_enabledMicrophone;
      widget.onEnabledMicrophone?.call(_enabledMicrophone);
      if (_enabledMicrophone) {
        await _enableAudio();
      } else {
        await _disableAudio();
      }
    });

    // if (null != _participant) {
    //   if (_participant!.isMicrophoneEnabled()) {
    //     _disableAudio();
    //   } else {
    //     _enableAudio();
    //   }
    // }
  }

  void _toggleSpeaker() async {
    await _lockSpeaker.synchronized(() async {
      _enabledSpeaker = !_enabledSpeaker;
      widget.onEnabledSpeaker?.call(_enabledSpeaker);
      if (_enabledSpeaker) {
        await _enableSpeaker();
      } else {
        await _disableSpeaker();
      }
      setState(() {});
    });
  }

  Future<void> _disableAudio() async {
    await _participant?.setMicrophoneEnabled(false);
  }

  Future<void> _enableAudio() async {
    await _participant?.setMicrophoneEnabled(true);
  }

  Future<void> _disableVideo() async {
    await _participant?.setCameraEnabled(false);
  }

  Future<void> _enableVideo() async {
    await _participant?.setCameraEnabled(true);
  }

  Future<void> _disableSpeaker() async {
    await Hardware.instance.setSpeakerphoneOn(false);
  }

  Future<void> _enableSpeaker() async {
    await Hardware.instance.setSpeakerphoneOn(true);
  }

  void _selectAudioOutput(MediaDevice device) async {
    await _room?.setAudioOutputDevice(device);
    setState(() {});
  }

  void _selectAudioInput(MediaDevice device) async {
    await _room?.setAudioInputDevice(device);
    setState(() {});
  }

  void _selectVideoInput(MediaDevice device) async {
    await _room?.setVideoInputDevice(device);
    setState(() {});
  }

  void _toggleCamera() async {
    //
    final track = _participant?.videoTracks.firstOrNull?.track;
    if (track == null) return;
    Helper.switchCamera(track.mediaStreamTrack);
    // try {
    //   final newPosition = position.switched();
    //   await track.setCameraPosition(newPosition);
    //   setState(() {
    //     position = newPosition;
    //   });
    // } catch (error, stack) {
    //   Logger.print('could not restart track: $error $stack');
    //   return;
    // }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Container(
            height: 45.h,
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Stack(
              children: [
                Align(
                  alignment: Alignment.centerLeft,
                  child: ImageRes.liveClose.toImage
                    ..width = 30.w
                    ..height = 30.h
                    ..onTap = widget.onMinimize,
                ),
                Align(
                  alignment: Alignment.center,
                  child: _videoCallingDurationView,
                ),
                if (null != _participant)
                  Align(
                    alignment: Alignment.centerRight,
                    child: Visibility(
                      visible: isVideo,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          (_participant!.isCameraEnabled()
                                  ? ImageRes.liveCameraOn
                                  : ImageRes.liveCameraOff)
                              .toImage
                            ..width = 30.w
                            ..height = 30.h
                            ..onTap = (_participant!.isCameraEnabled()
                                ? _disableVideo
                                : _enableVideo),
                          16.horizontalSpace,
                          ImageRes.liveSwitchCamera.toImage
                            ..width = 30.w
                            ..height = 30.h
                            ..onTap = _toggleCamera,
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(child: widget.child?.call(_callState) ?? const SizedBox()),
          10.verticalSpace,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: _buttonGroup,
          ),
          32.verticalSpace,
        ],
      ),
    );
  }

  List<Widget> get _buttonGroup {
    if (_callState == CallState.call ||
        _callState == CallState.connecting &&
            widget.initState == CallState.call) {
      return [
        LiveButton.microphone(on: _enabledMicrophone, onTap: _toggleAudio),
        LiveButton.cancel(onTap: widget.onCancel),
        LiveButton.speaker(on: _enabledSpeaker, onTap: _toggleSpeaker),
      ];
    } else if (_callState == CallState.beCalled ||
        _callState == CallState.connecting &&
            widget.initState == CallState.beCalled) {
      return [
        LiveButton.reject(onTap: widget.onReject),
        LiveButton.pickUp(onTap: widget.onPickUp),
      ];
    } else if (_callState == CallState.calling) {
      return [
        LiveButton.microphone(on: _enabledMicrophone, onTap: _toggleAudio),
        LiveButton.hungUp(onTap: () => widget.onHangUp?.call(true)),
        LiveButton.speaker(on: _enabledSpeaker, onTap: _toggleSpeaker),
      ];
    }
    return [];
  }

  bool get isVideo => widget.callType == CallType.video;

  bool get isCalling => _callState == CallState.calling;

  Widget get _videoCallingDurationView => Visibility(
        visible: isCalling,
        child: _callingDurationStr.toText
          ..style = Styles.ts_FFFFFF_opacity70_17sp,
      );
}
