import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as openim;
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_meeting/src/widgets/overlay_widget.dart';
import 'package:rxdart/rxdart.dart';

import 'participant_info.dart';

class MeetingMembersSheetView extends StatefulWidget {
  const MeetingMembersSheetView({
    Key? key,
    required this.participantsSubject,
    required this.meetingInfoChangedSubject,
    this.controller,
    this.onInvite,
    this.isHost = false,
  }) : super(key: key);
  final BehaviorSubject<List<ParticipantTrack>> participantsSubject;
  final BehaviorSubject<openim.MeetingInfo> meetingInfoChangedSubject;
  final AnimationController? controller;
  final Function()? onInvite;
  final bool isHost;

  @override
  State<MeetingMembersSheetView> createState() => _MeetingMembersSheetViewState();
}

class _MeetingMembersSheetViewState extends State<MeetingMembersSheetView> {
  late StreamSubscription _pSub;
  late StreamSubscription _iSub;
  openim.MeetingInfo? _meetingInfo;
  final List<ParticipantTrack> _participantTracks = [];

  List<String> get _disabledMicrophoneUserIDList => _meetingInfo?.disableMicrophoneUserIDList ?? [];

  List<String> get _pinedUserIDList => _meetingInfo?.pinedUserIDList ?? [];

  List<String> get _disabledVideoUserIDList => _meetingInfo?.disableVideoUserIDList ?? [];

  List<String> get _beWatchedUserIDList => _meetingInfo?.beWatchedUserIDList ?? [];

  bool get _onlyHostInviteUser => _meetingInfo?.onlyHostInviteUser == true;

  @override
  void initState() {
    _pSub = widget.participantsSubject.listen(_onChangedParticipants);
    _iSub = widget.meetingInfoChangedSubject.listen(_onChangedMeetingInfo);
    super.initState();
  }

  @override
  void dispose() {
    _pSub.cancel();
    _iSub.cancel();
    super.dispose();
  }

  void _onChangedParticipants(List<ParticipantTrack> list) {
    if (!mounted) return;
    setState(() {
      _participantTracks.clear();
      _participantTracks.addAll(list);
      _sortParticipantTracks();
    });
  }

  void _onChangedMeetingInfo(meetingInfo) {
    if (!mounted) return;
    setState(() {
      _meetingInfo = meetingInfo;
      _sortParticipantTracks();
    });
  }

  void _sortParticipantTracks() {
    _participantTracks.sort((a, b) {
      final aIdentity = a.participant.identity;
      final bIdentity = b.participant.identity;
      final aIsPined = _pinedUserIDList.contains(aIdentity);
      final bIsPined = _pinedUserIDList.contains(bIdentity);
      final aIndex = _pinedUserIDList.indexOf(aIdentity);
      final bIndex = _pinedUserIDList.indexOf(bIdentity);
      if (aIsPined && bIsPined) {
        return aIndex - bIndex;
      } else if (aIsPined && !bIsPined) {
        return -1;
      } else if (!aIsPined && bIsPined) {
        return 1;
      }
      return 0;
    });
  }

  _invite() => widget.controller?.reverse().then((value) => widget.onInvite?.call());

  _muteAll() => widget.controller?.reverse().then((value) => _updateMeetingInfo({
        "roomID": _meetingInfo!.roomID!,
        "isMuteAllMicrophone": true,
      }));

  _unmuteAll() => widget.controller?.reverse().then((value) => _updateMeetingInfo({
        "roomID": _meetingInfo!.roomID!,
        "isMuteAllMicrophone": false,
      }));

  _pinThisMember(String userID, bool pined) async {
    await _updateMeetingInfo(pined
        ? {
            "roomID": _meetingInfo!.roomID!,
            "addPinedUserIDList": [userID],
          }
        : {
            "roomID": _meetingInfo!.roomID!,
            "reducePinedUserIDList": [userID],
          });
    setState(() {
      if (pined) {
        _meetingInfo?.pinedUserIDList?.add(userID);
      } else {
        _meetingInfo?.pinedUserIDList?.remove(userID);
      }
    });
  }

  _allSeeHim(String userID, bool seeHim) async {
    await _updateMeetingInfo({
      "roomID": _meetingInfo!.roomID!,
      "addBeWatchedUserIDList": seeHim ? [userID] : [],
      "reduceBeWatchedUserIDList": _meetingInfo!.beWatchedUserIDList,
    });
    setState(() {
      if (seeHim) {
        _meetingInfo?.beWatchedUserIDList?.clear();
        _meetingInfo?.beWatchedUserIDList?.add(userID);
      } else {
        _meetingInfo?.beWatchedUserIDList?.remove(userID);
      }
    });
  }

  _updateMeetingInfo(Map args) =>
      LoadingView.singleton.wrap(asyncFunction: () => openim.OpenIM.iMManager.signalingManager.signalingUpdateMeetingInfo(info: args));

  /// String meetingID, String? streamType, String userID,
  ///       bool mute, bool muteAll
  _onTapCamera(String userID, bool value) => _updateOpStream(_meetingInfo!.roomID!, 'video', userID, value, false);

  _onTapMic(String userID, bool value) => _updateOpStream(_meetingInfo!.roomID!, 'audio', userID, value, false);

  _updateOpStream(roomID, streamType, userID, mute, muteAll) {
    return LoadingView.singleton.wrap(
        asyncFunction: () => openim.OpenIM.iMManager.signalingManager.signalingOperateStream(
              roomID: roomID,
              streamType: streamType,
              userID: userID,
              mute: mute,
              muteAll: muteAll,
            ));
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {},
        child: Container(
          constraints: BoxConstraints(maxHeight: 500.h),
          decoration: BoxDecoration(
            color: Styles.c_FFFFFF,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.r),
              topRight: Radius.circular(14.r),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Spacer(
                    flex: 2,
                  ),
                  Container(
                    height: 52.h,
                    alignment: Alignment.center,
                    child: StrRes.members.toText..style = Styles.ts_0C1C33_17sp_medium,
                  ),
                  Spacer(),
                  CupertinoButton(
                      child: Icon(Icons.close),
                      onPressed: () {
                        widget.controller?.reverse();
                      })
                ],
              ),
              Flexible(
                  child: ListView.builder(
                padding: EdgeInsets.only(top: 7.h),
                itemCount: _participantTracks.length,
                itemBuilder: (_, index) => _buildItemView(_participantTracks.elementAt(index).participant),
              )),
              if (widget.isHost || !_onlyHostInviteUser) _buildButton(),
              12.verticalSpace,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemView(Participant participant) {
    String? nickname;
    String? faceURL;
    String userID = participant.identity;
    final disableMic = !participant.isMicrophoneEnabled() /*|| _meetingInfo!.isMuteAllMicrophone == true*/;
    final disableVideo = !participant.isCameraEnabled() /*|| _meetingInfo!.isMuteAllVideo == true*/;
    final isPined = _pinedUserIDList.contains(userID);
    final isSeeHim = _beWatchedUserIDList.contains(userID);
    // final disableMic = _disableMicrophoneUserIDList.contains(userID);
    // final disableVideo = _disableVideoUserIDList.contains(userID);
    try {
      var data = json.decode(participant.metadata!);
      final userInfo = data['userInfo'];
      nickname = userInfo['nickname'] ?? userID;
      faceURL = userInfo?['faceURL'];
    } catch (e, s) {
      Logger.print('error: $e   stack$s');
    }
    return Container(
      height: 60.h,
      padding: EdgeInsets.symmetric(horizontal: 16.w),
      child: Row(
        children: [
          AvatarView(url: faceURL, text: nickname),
          10.horizontalSpace,
          Expanded(
            child: Container(
              height: 60.h,
              decoration: BoxDecoration(
                border: BorderDirectional(
                  bottom: BorderSide(color: Styles.c_E8EAEF, width: 1),
                ),
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: (nickname ?? '').toText
                          ..style = Styles.ts_0C1C33_17sp
                          ..maxLines = 1
                          ..overflow = TextOverflow.ellipsis,
                      ),
                      if (isSeeHim)
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: ImageRes.meetingAllSeeHim.toImage
                            ..width = 30.w
                            ..height = 30.h,
                        ),
                      if (widget.isHost)
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: (!disableMic ? ImageRes.meetingMicOnGray : ImageRes.meetingMicOffGray).toImage
                            ..width = 30.w
                            ..height = 30.h
                            ..onTap = () => _onTapMic(userID, !disableMic),
                        ),
                      if (widget.isHost)
                        Padding(
                          padding: EdgeInsets.only(left: 16.w),
                          child: (!disableVideo ? ImageRes.meetingCameraOnGray : ImageRes.meetingCameraOffGray).toImage
                            ..width = 30.w
                            ..height = 30.h
                            ..onTap = () => _onTapCamera(userID, !disableVideo),
                        ),
                      if (widget.isHost)
                        _buildPopButton(
                          userID: userID,
                          isPined: isPined,
                          isSeeHim: isSeeHim,
                        ),
                    ],
                  ),
                  if (isPined)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: ImageRes.meetingMembersPin.toImage
                        ..width = 10.w
                        ..height = 10.h,
                    ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPopButton({
    required String userID,
    required bool isPined,
    required bool isSeeHim,
  }) {
    Widget popItemView({
      required String text,
      Function()? onTap,
      bool underline = false,
    }) =>
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: onTap,
          child: Container(
            height: 48.h,
            width: 117.w,
            alignment: Alignment.center,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            decoration: underline
                ? BoxDecoration(
                    border: BorderDirectional(
                      bottom: BorderSide(color: Styles.c_E8EAEF, width: 1),
                    ),
                  )
                : null,
            child: text.toText
              ..style = Styles.ts_0C1C33_17sp
              ..maxLines = 1
              ..overflow = TextOverflow.ellipsis,
          ),
        );
    final completer = Completer<bool>();

    return OverlayPopupMenuButton(
      closePopMenuCompleter: completer,
      builder: (controller) => Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4.r),
          color: Styles.c_FFFFFF,
          boxShadow: [
            BoxShadow(
              color: Styles.c_000000_opacity15,
              offset: Offset(0, 4.h),
              blurRadius: 4.r,
              spreadRadius: 1.r,
            ),
          ],
        ),
        child: Column(
          children: [
            popItemView(
              text: isPined ? StrRes.unpinThisMember : StrRes.pinThisMember,
              underline: true,
              // onTap: () => controller?.reverse().then((value) {}),
              onTap: () {
                completer.complete(true);
                _pinThisMember(userID, !isPined);
              },
            ),
            popItemView(
              text: isSeeHim ? StrRes.cancelAllSeeHim : StrRes.allSeeHim,
              underline: true,
              // onTap: () => controller?.reverse().then((value) {}),
              onTap: () {
                completer.complete(true);
                _allSeeHim(userID, !isSeeHim);
              },
            ),
          ],
        ),
      ),
      child: Container(
        width: 30.w,
        height: 30.h,
        margin: EdgeInsets.only(left: 16.w),
        alignment: Alignment.center,
        child: ImageRes.meetingMore.toImage
          ..width = 22.w
          ..height = 22.h,
      ),
    );
  }

  Widget _buildButton() => Container(
        height: 66.h,
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: widget.isHost
            ? Row(
                children: [
                  _buildTextButton(text: StrRes.invite, onTap: _invite),
                  10.horizontalSpace,
                  _buildTextButton(text: StrRes.muteAll, onTap: _muteAll),
                  10.horizontalSpace,
                  _buildTextButton(text: StrRes.unmuteAll, onTap: _unmuteAll),
                ],
              )
            : _buildTextButton(text: StrRes.invite, onTap: _invite, expanded: false),
      );

  Widget _buildTextButton({
    required String text,
    Function()? onTap,
    bool expanded = true,
  }) {
    final button = GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        height: 36.h,
        decoration: BoxDecoration(
          border: Border.all(color: Styles.c_E8EAEF, width: 1),
          borderRadius: BorderRadius.circular(6.r),
        ),
        alignment: Alignment.center,
        child: text.toText..style = Styles.ts_0089FF_14sp_medium,
      ),
    );
    return expanded ? Expanded(child: button) : button;
  }
}
