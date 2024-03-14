import 'dart:convert';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:livekit_client/livekit_client.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_meeting/src/widgets/page_content.dart';
import 'package:page_view_dot_indicator/page_view_dot_indicator.dart';

import '../../widgets/meeting_state.dart';
import '../../widgets/overlay_widget.dart';
import '../../widgets/participant.dart';
import '../../widgets/participant_info.dart';

class MeetingRoom extends MeetingView {
  const MeetingRoom(
    super.room,
    super.listener, {
    Key? key,
    required super.roomID,
    super.onClose,
  }) : super(key: key);

  @override
  MeetingViewState<MeetingRoom> createState() => _MeetingRoomState();
}

class _MeetingRoomState extends MeetingViewState<MeetingRoom> {
  //
  List<ParticipantTrack> participantTracks = [];

  EventsListener<RoomEvent> get _listener => widget.listener;

  bool get fastConnection => widget.room.engine.fastConnectOptions != null;

  ScrollPhysics? scrollPhysics;
  final _pageController = PageController();
  int _pages = 0;

  @override
  void initState() {
    super.initState();
    widget.room.addListener(_onRoomDidUpdate);
    _setUpListeners();
    _sortParticipants();
    _parseRoomMetadata();
    WidgetsBindingCompatible.instance?.addPostFrameCallback((_) {
      startTimerCompleter.complete(true);
      if (!fastConnection) {
        _askPublish();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    // always dispose listener
    (() async {
      widget.room.removeListener(_onRoomDidUpdate);
      await _listener.dispose();
      // for (var e in widget.room.participants.values) {
      //   await e.dispose();
      // }
      await widget.room.localParticipant?.dispose();
      await widget.room.disconnect();
      await widget.room.dispose();
    })();
    super.dispose();
  }

  void _setUpListeners() => _listener
    ..on<RoomDisconnectedEvent>((event) => _meetingClosed())
    ..on<RoomRecordingStatusChanged>((event) {})
    ..on<LocalTrackPublishedEvent>((_) => _sortParticipants())
    ..on<LocalTrackUnpublishedEvent>((_) => _sortParticipants())
    ..on<ParticipantConnectedEvent>((_) => _sortParticipants())
    ..on<ParticipantDisconnectedEvent>((_) => _sortParticipants())
    ..on<RoomMetadataChangedEvent>((event) => _parseRoomMetadata());

  void _askPublish() async {
    Logger.print('joinDisabledVideo: $joinDisabledVideo');
    Logger.print('joinDisabledMicrophone: $joinDisabledMicrophone');
    // video will fail when running in ios simulator
    try {
      await widget.room.localParticipant?.setCameraEnabled(!joinDisabledVideo);
    } catch (error) {
      Logger.print('could not publish video: $error');
    }
    try {
      await widget.room.localParticipant
          ?.setMicrophoneEnabled(!joinDisabledMicrophone);
    } catch (error) {
      Logger.print('could not publish audio: $error');
    }
  }

  void _parseRoomMetadata() {
    if (widget.room.metadata != null) {
      Logger.print('room parseRoomMetadata: ${widget.room.metadata}');
      final json = jsonDecode(widget.room.metadata!);
      meetingInfo = MeetingInfo.fromJson(json);
      watchedUserID = meetingInfo?.beWatchedUserIDList?.firstOrNull;
      // _watchedUserID ??= _meetingInfo?.hostUserID;
      meetingInfoChangedSubject.add(meetingInfo!);
      setState(() {});
    }
  }

  @override
  customWatchedUser(String userID) {
    if (wasClickedUserID == userID) return;
    final track = participantTracks.firstWhereOrNull((e) =>
        e.participant.identity == userID &&
        (e.screenShareTrack != null && !e.screenShareTrack!.muted ||
            e.videoTrack != null && !e.videoTrack!.muted));
    wasClickedUserID = track?.participant.identity;
    if (null != wasClickedUserID) _sortParticipants();
  }

  void _onRoomDidUpdate() {
    _sortParticipants();
  }

  void _sortParticipants() {
    List<ParticipantTrack> participantTracks = [];

    for (var participant in widget.room.participants.values) {
      // 排除观察者
      if (widget.roomID == participant.identity) {
        continue;
      }
      VideoTrack? videoTrack;
      VideoTrack? screenShareTrack;
      for (var t in participant.videoTracks) {
        if (t.isScreenShare) {
          screenShareTrack = t.track;
        } else {
          videoTrack = t.track;
        }
      }
      participantTracks.add(setWatchedTrack(ParticipantTrack(
        participant: participant,
        videoTrack: videoTrack,
        screenShareTrack: screenShareTrack,
        isHost: hostUserID == participant.identity,
      )));
    }

    if (null != _localParticipantTrack) {
      participantTracks.add(_localParticipantTrack!);
    }

    participantTracks.sort((a, b) {
      // joinedAt
      return a.participant.joinedAt.millisecondsSinceEpoch -
          b.participant.joinedAt.millisecondsSinceEpoch;
    });

    participantsSubject.add(participantTracks);

    setState(() {
      this.participantTracks = [...participantTracks];
    });
  }

  ParticipantTrack? get _firstParticipantTrack {
    ParticipantTrack? track;
    if (null != watchedUserID) {
      track = participantTracks
          .firstWhere((e) => e.participant.identity == watchedUserID);
    } else if (null != wasClickedUserID) {
      track = participantTracks
          .firstWhere((e) => e.participant.identity == wasClickedUserID);
    } else {
      track = participantTracks.firstWhereOrNull(
          (e) => e.screenShareTrack != null || e.videoTrack != null);
    }
    Logger.print('first watch track : ${track == null} '
        'videoTrack:${track?.videoTrack == null} '
        'screenShareTrack:${track?.screenShareTrack == null} '
        'muted:${track?.videoTrack?.muted} '
        'muted:${track?.screenShareTrack?.muted}');
    return track;
  }

  ParticipantTrack? get _localParticipantTrack {
    if (widget.room.localParticipant != null) {
      VideoTrack? videoTrack;
      VideoTrack? screenShareTrack;
      final localParticipantTracks = widget.room.localParticipant!.videoTracks;
      for (var t in localParticipantTracks) {
        if (t.isScreenShare) {
          screenShareTrack = t.track;
        } else {
          videoTrack = t.track;
        }
      }
      return setWatchedTrack(ParticipantTrack(
        participant: widget.room.localParticipant!,
        videoTrack: videoTrack,
        screenShareTrack: screenShareTrack,
        isHost: hostUserID == widget.room.localParticipant!.identity,
      ));
    }
    return null;
  }

  _onPageChange(int pages) {
    setState(() {
      _pages = pages;
    });
  }

  _fixPages(int count) {
    _pages = min(_pages, count - 1);
    return count;
  }

  int get pageCount => _fixPages((participantTracks.length % 4 == 0
          ? participantTracks.length ~/ 4
          : participantTracks.length ~/ 4 + 1) +
      (null == _firstParticipantTrack ? 0 : 1));

  @override
  Widget buildChild() => Stack(
        children: [
          widget.room.participants.isEmpty
              ? (_localParticipantTrack == null
                  ? const SizedBox()
                  : ParticipantWidget.widgetFor(_localParticipantTrack!,
                      isZoom: true,
                      useScreenShareTrack: true, onTapSwitchCamera: () {
                      _localParticipantTrack!.toggleCamera();
                    }))
              : StatefulBuilder(
                  builder: (v, status) {
                    return GestureDetector(
                      child: NotificationListener(
                        onNotification: (v) {
                          if (v is FirstPageZoomNotification) {
                            scrollPhysics = v.isZoom
                                ? const NeverScrollableScrollPhysics()
                                : null;
                            status.call(() {});
                            return true;
                          }
                          return false;
                        },
                        child: PageView.builder(
                          physics: scrollPhysics,
                          itemBuilder: (context, index) {
                            final existVideoTrack =
                                null != _firstParticipantTrack;
                            if (existVideoTrack && index == 0) {
                              return GestureDetector(
                                child: FirstPage(
                                  participantTrack: _firstParticipantTrack!,
                                ),
                                onTap: () {
                                  toggleFullScreen();
                                },
                              );
                            }
                            return OtherPage(
                              participantTracks: participantTracks,
                              pages: existVideoTrack ? index - 1 : index,
                              onDoubleTap: (t) {
                                setState(() {
                                  customWatchedUser(t.participant.identity);
                                  _pageController.jumpToPage(0);
                                });
                              },
                            );
                          },
                          itemCount: pageCount,
                          onPageChanged: _onPageChange,
                          controller: _pageController,
                        ),
                      ),
                    );
                  },
                ),
          if (widget.room.participants.isNotEmpty && pageCount > 1)
            Positioned(
              bottom: 8.h,
              child: PageViewDotIndicator(
                currentItem: _pages,
                count: pageCount,
                size: Size(8.w, 8.h),
                unselectedColor: Styles.c_FFFFFF_opacity50,
                selectedColor: Styles.c_FFFFFF,
              ),
            ),
          Positioned(
            right: 16.w,
            bottom: 16.h,
            child: ImageRes.meetingRotateScreen.toImage
              ..width = 44.w
              ..height = 44.h
              ..onTap = rotateScreen,
          )
        ],
      );

  void _meetingClosed() => OverlayWidget().showDialog(
        context: context,
        child: CustomDialog(
          onTapLeft: OverlayWidget().dismiss,
          onTapRight: () {
            OverlayWidget().dismiss();
            widget.onClose?.call();
          },
          title: StrLibrary.meetingClosedHint,
        ),
      );
}

class FirstPageZoomNotification extends Notification {
  bool isZoom;

  FirstPageZoomNotification({this.isZoom = false});
}
