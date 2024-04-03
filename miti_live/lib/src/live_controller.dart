import 'dart:async';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/services.dart';
import 'package:flutter_miti_live_alert/flutter_miti_live_alert.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
// import 'package:just_audio/just_audio.dart';
import 'package:miti_common/miti_common.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:rxdart/rxdart.dart';
import 'package:sprintf/sprintf.dart';
import 'package:uuid/uuid.dart';
import 'package:vibration/vibration.dart';
import 'package:flutter_ringtone_player/flutter_ringtone_player.dart';

import '../miti_live.dart';

/// 信令
mixin MitiLive {
  final signalingSubject = PublishSubject<CallEvent>();

  /// 被邀请者收到：邀请者取消音视频通话
  void invitationCancelled(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.beCanceled, info));
  }

  /// 邀请者收到：被邀请者超时未接通
  void invitationTimeout(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.timeout, info));
  }

  /// 邀请者收到：被邀请者同意音视频通话
  void inviteeAccepted(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.beAccepted, info));
  }

  /// 邀请者收到：被邀请者拒绝音视频通话
  void inviteeRejected(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.beRejected, info));
  }

  /// 被邀请者收到：音视频通话邀请
  void receiveNewInvitation(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.beCalled, info));
  }

  /// 被邀请者（其他端）收到：比如被邀请者在手机拒接，在pc上会收到此回调
  void inviteeAcceptedByOtherDevice(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.otherAccepted, info));
  }

  /// 被邀请者（其他端）收到：比如被邀请者在手机拒接，在pc上会收到此回调
  void inviteeRejectedByOtherDevice(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.otherReject, info));
  }

  /// 被挂断
  void beHangup(SignalingInfo info) {
    signalingSubject.add(CallEvent(CallState.beHangup, info));
  }

  final switchBackgroundSub = PublishSubject<bool>();
  final insertSignalingMessageSubject = PublishSubject<CallEvent>();

  Function(SignalingMessageEvent)? onSignalingMessage;
  final roomParticipantDisconnectedSubject = PublishSubject<RoomCallingInfo>();
  final roomParticipantConnectedSubject = PublishSubject<RoomCallingInfo>();

  bool _isRunningBackground = false;

  /// 退到后台不会弹出拨号界面，切到前台后才会弹出界面。
  /// 如果存在值，表示收到了来电邀请，启动后需要恢复拨号界面
  CallEvent? _beCalledEvent;

  /// true:点击了系统桌面的接受按钮，恢复拨号界面后自动接听
  bool _autoPickup = false;

  // final _ring = 'assets/audio/live_ring.wav';
  // final _audioPlayer = AudioPlayer(
  //   // Handle audio_session events ourselves for the purpose of this demo.
  //   handleInterruptions: false,
  //   // androidApplyAudioAttributes: false,
  //   // handleAudioSessionActivation: false,
  // );

  bool get isBusy => MitiLiveClient().isBusy;

  onCloseLive() {
    signalingSubject.close();
    insertSignalingMessageSubject.close();
    roomParticipantDisconnectedSubject.close();
    roomParticipantConnectedSubject.close();
    _stopBeepAndVibrate();
    FlutterMitiLiveAlert.closeLiveAlert();
  }

  onInitLive() async {
    _signalingListener();
    _insertSignalingMessageListener();
    // 后台通话
    switchBackgroundSub.listen((background) {
      _isRunningBackground = background;
      // 从后台切换到前台，如果还在被call，则拉起通话页面
      if (!_isRunningBackground) {
        // 恢复拨号界面
        if (_beCalledEvent != null) {
          signalingSubject.add(_beCalledEvent!);
        }
        // 关闭系统弹框
        FlutterMitiLiveAlert.closeLiveAlert();
      }
    });

    // 桌面浮窗
    FlutterMitiLiveAlert.buttonEvent(
      onAccept: () {
        // 自动接听
        _autoPickup = true;
      },
      onReject: () async {
        // 点击系统桌面浮窗的拒绝按钮
        await onTapReject(
            _beCalledEvent!.data..userID = OpenIM.iMManager.userID);
        // 重置拨号状态
        _beCalledEvent = null;
      },
    );

    // 群通话状态监听
    roomParticipantDisconnectedSubject.listen((info) {
      if (null == info.participant || info.participant!.length == 1) {
        MitiLiveClient().closeByRoomID(info.invitation!.roomID!);
      }
    });
  }

  /// 拦截其他干扰信令
  Stream<CallEvent> get _stream => signalingSubject
      .stream /*.where((event) => LiveClient.dispatchSignaling(event))*/;

  _signalingListener() => _stream.listen(
        (event) async {
          _beCalledEvent = null;
          if (event.state == CallState.beCalled) {
            _playSound(vibrate: true);
            final mediaType = event.data.invitation!.mediaType;
            final sessionType = event.data.invitation!.sessionType;
            final callType =
                mediaType == 'audio' ? CallType.audio : CallType.video;
            final callObj = sessionType == ConversationType.single
                ? CallObj.single
                : CallObj.group;

            if (Platform.isAndroid && _isRunningBackground) {
              // 记录拨号状态
              _beCalledEvent = event;
              if (await Permissions.checkSystemAlertWindow()) {
                // 如果当前处于后台，显示系统浮窗并拦截拨号界面
                var list = await OpenIM.iMManager.userManager.getUsersInfo(
                  userIDList: [event.data.invitation!.inviterUserID!],
                );
                // 后台弹框
                FlutterMitiLiveAlert.showLiveAlert(
                  title: sprintf(StrLibrary.inviteYouCall, [
                    list.firstOrNull?.nickname,
                    callType == CallType.audio
                        ? StrLibrary.callVoice
                        : StrLibrary.callVideo
                  ]),
                  rejectText: StrLibrary.rejectCall,
                  acceptText: StrLibrary.acceptCall,
                );
                return;
              }
            }
            // 重置
            _beCalledEvent = null;
            MitiLiveClient().start(
              Get.overlayContext!,
              callEventSubject: signalingSubject,
              roomID: event.data.invitation!.roomID!,
              inviteeUserIDList: event.data.invitation!.inviteeUserIDList!,
              inviterUserID: event.data.invitation!.inviterUserID!,
              groupID: event.data.invitation!.groupID,
              callType: callType,
              callObj: callObj,
              initState: CallState.beCalled,
              onSyncUserInfo: onSyncUserInfo,
              onSyncGroupInfo: onSyncGroupInfo,
              onSyncGroupMemberInfo: onSyncGroupMemberInfo,
              autoPickup: _autoPickup,
              onTapPickup: () => onTapPickup(
                event.data..userID = OpenIM.iMManager.userID,
              ),
              onTapReject: () => onTapReject(
                event.data..userID = OpenIM.iMManager.userID,
              ),
              onTapHangup: (duration, isPositive) => onTapHangup(
                event.data..userID = OpenIM.iMManager.userID,
                duration,
                isPositive,
              ),
              onError: (e, s) => onError(e, s, extMessage: "重置通话错误"),
              onRoomDisconnected: () => onRoomDisconnected(event.data),
            );
          } else if (event.state == CallState.beRejected) {
            // 被拒绝
            _stopBeepAndVibrate();
            insertSignalingMessageSubject.add(event);
          } else if (event.state == CallState.beHangup) {
            // 被挂断
            _stopBeepAndVibrate();
            // 通过挂断方法插入通话时长消息
            // insertSignalingMessageSubject.add(event);
          } else if (event.state == CallState.beCanceled) {
            // 超时被取消
            if (_isRunningBackground) {
              FlutterMitiLiveAlert.closeLiveAlert();
            }
            _stopBeepAndVibrate();
            insertSignalingMessageSubject.add(event);
          } else if (event.state == CallState.beAccepted) {
            // 被接听
            _stopBeepAndVibrate();
          } else if (event.state == CallState.otherReject ||
              event.state == CallState.otherAccepted) {
            // 被其他设备接听
            _stopBeepAndVibrate();
          } else if (event.state == CallState.timeout) {
            // 超时无响应
            _stopBeepAndVibrate();
            insertSignalingMessageSubject.add(event);
            final sessionType = event.data.invitation!.sessionType;

            if (sessionType == 1) {
              onTimeoutCancelled(event.data);
            }
          }
        },
      );

  _insertSignalingMessageListener() {
    insertSignalingMessageSubject.listen((value) {
      _insertMessage(
        state: value.state,
        signalingInfo: value.data,
        duration: value.fields ?? 0,
      );
    });
  }

  call({
    required CallObj callObj,
    required CallType callType,
    CallState callState = CallState.call,
    String? roomID,
    String? inviterUserID,
    required List<String> inviteeUserIDList,
    String? groupID,
    SignalingCertificate? credentials,
  }) async {
    final mediaType = callType == CallType.audio ? 'audio' : 'video';
    final sessionType = callObj == CallObj.single ? 1 : 3;
    inviterUserID ??= OpenIM.iMManager.userID;

    final signal = SignalingInfo(
      userID: inviterUserID,
      invitation: InvitationInfo(
        inviterUserID: inviterUserID,
        inviteeUserIDList: inviteeUserIDList,
        roomID: roomID ?? groupID ?? const Uuid().v4(),
        timeout: 30,
        mediaType: mediaType,
        sessionType: sessionType,
        platformID: MitiUtils.getPlatform(),
        groupID: groupID,
      ),
    );

    MitiLiveClient().start(
      Get.overlayContext!,
      callEventSubject: signalingSubject,
      inviterUserID: inviterUserID,
      groupID: groupID,
      inviteeUserIDList: inviteeUserIDList,
      callObj: callObj,
      callType: callType,
      initState: callState,
      onDialSingle: () => onDialSingle(signal),
      onDialGroup: () => onDialGroup(signal),
      onJoinGroup: () => Future.value(credentials!),
      onTapCancel: () => onTapCancel(signal),
      onTapHangup: (duration, isPositive) => onTapHangup(
        signal,
        duration,
        isPositive,
      ),
      onSyncUserInfo: onSyncUserInfo,
      onSyncGroupInfo: onSyncGroupInfo,
      onSyncGroupMemberInfo: onSyncGroupMemberInfo,
      onWaitingAccept: () {
        if (callObj == CallObj.single) _playSound(vibrate: false);
      },
      onBusyLine: onBusyLine,
      onStartCalling: () {
        _stopBeepAndVibrate();
      },
      onError: (e, s) => onError(e, s, extMessage: "开始拨打通话错误, call"),
      onRoomDisconnected: () => onRoomDisconnected(signal),
      onClose: _stopBeepAndVibrate,
    );
  }

  onError(error, stack, {String extMessage = ""}) {
    myLogger.e({
      "message": "通话错误",
      "extMessage": extMessage,
      "error": error,
      stack: stack
    });
    MitiLiveClient().close();
    _stopBeepAndVibrate();
    if (error is PlatformException) {
      myLogger.e({
        "message": "通话错误详情",
        "error": {
          "code": int.parse(error.code),
          "details": error.details,
          "message": error.message
        }
      });
      if (int.parse(error.code) == SDKErrorCode.hasBeenBlocked) {
        showToast(StrLibrary.callFail);
        return;
      }
    }
    showToast(StrLibrary.networkError);
  }

  onRoomDisconnected(SignalingInfo signalingInfo) {
    insertSignalingMessageSubject.add(
      CallEvent(CallState.networkError, signalingInfo),
    );
  }

  /// 拨向单人
  Future<SignalingCertificate> onDialSingle(SignalingInfo signaling) {
    final isAudio = signaling.invitation?.mediaType == CallType.audio;
    return OpenIM.iMManager.signalingManager
        .signalingInvite(
          info: signaling
            ..invitation?.timeout = 30
            ..offlinePushInfo = (Config.offlinePushInfo
              ..iOSPushSound = "live_ring.wav"
              ..title = OpenIM.iMManager.userInfo.nickname
              ..desc = (isAudio
                  ? '[${StrLibrary.callVoice}]'
                  : '[${StrLibrary.callVideo}]')),
        )
        .catchError((e, s) =>
            onError(e, s, extMessage: "发起单人通话room邀请错误, onDialSingle"));
  }

  /// 拨向多人
  Future<SignalingCertificate> onDialGroup(SignalingInfo signaling) async {
    final isAudio = signaling.invitation?.mediaType == CallType.audio;
    final groupId = signaling.invitation?.groupID;
    final list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
    final groupInfo = list.firstWhere((element) => element.groupID == groupId);
    final memberList = await OpenIM.iMManager.groupManager.getGroupMemberList(
      groupID: groupInfo.groupID,
      count: 999,
    );
    final member = memberList.firstWhere(
        (element) => element.userID == signaling.invitation?.inviterUserID);

    return OpenIM.iMManager.signalingManager
        .signalingInviteInGroup(
          info: signaling
            ..invitation?.timeout = 30
            ..offlinePushInfo = (Config.offlinePushInfo
              ..iOSPushSound = "live_ring.wav"
              ..title = (groupInfo.groupName ?? StrLibrary.offlineCallMessage)
              ..desc =
                  "${member.nickname ?? StrLibrary.friend}: ${isAudio ? '[${StrLibrary.callVoice}]' : '[${StrLibrary.callVideo}]'}"),
        )
        .catchError(
            (e, s) => onError(e, s, extMessage: "发起多人通话room邀请错误, onDialGroup"));
  }

  /// 接听
  Future<SignalingCertificate> onTapPickup(SignalingInfo signaling) {
    _beCalledEvent = null; // ios bug
    _autoPickup = false;
    _stopBeepAndVibrate();
    return OpenIM.iMManager.signalingManager
        .signalingAccept(info: signaling)
        .catchError(
            (e, s) => onError(e, s, extMessage: "同意接听通话错误, onTapPickup"));
  }

  /// 拒绝
  onTapReject(SignalingInfo signaling) async {
    _stopBeepAndVibrate();
    insertSignalingMessageSubject.add(CallEvent(CallState.reject, signaling));
    return OpenIM.iMManager.signalingManager.signalingReject(info: signaling);
  }

  /// 取消
  onTapCancel(SignalingInfo signaling) async {
    _stopBeepAndVibrate();
    insertSignalingMessageSubject.add(CallEvent(CallState.cancel, signaling));
    OpenIM.iMManager.signalingManager.signalingCancel(info: signaling);
    return true;
  }

  /// 超时取消
  onTimeoutCancelled(SignalingInfo signaling) =>
      OpenIM.iMManager.signalingManager.signalingCancel(
        info: signaling..userID = OpenIM.iMManager.userID,
      );

  /// 挂断
  /// [isPositive] 人为挂断行为
  onTapHangup(SignalingInfo signaling, int duration, bool isPositive) async {
    if (isPositive) {
      OpenIM.iMManager.signalingManager.signalingHungUp(
        info: signaling..userID = OpenIM.iMManager.userID,
      );
    }
    _stopBeepAndVibrate();
    insertSignalingMessageSubject.add(CallEvent(
      CallState.hangup,
      signaling,
      fields: duration,
    ));
  }

  /// 用户繁忙
  onBusyLine() {
    _stopBeepAndVibrate();
    showToast('用户正忙，请稍后再试！');
  }

  onJoin() {}

  /// 同步用户信息
  Future<UserInfo?> onSyncUserInfo(userID) async {
    var list = await OpenIM.iMManager.userManager.getUsersInfo(
      userIDList: [userID],
    );

    return list.firstOrNull?.simpleUserInfo;
  }

  /// 同步组信息
  Future<GroupInfo?> onSyncGroupInfo(groupID) async {
    var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
      groupIDList: [groupID],
    );
    return list.firstOrNull;
  }

  /// 同步群成员信息
  Future<List<GroupMembersInfo>> onSyncGroupMemberInfo(
      groupID, userIDList) async {
    var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupID: groupID,
      userIDList: userIDList,
    );
    return list;
  }

  /// 自定义通话消息
  void _insertMessage({
    required CallState state,
    required SignalingInfo signalingInfo,
    int duration = 0,
  }) async {
    (() async {
      var invitation = signalingInfo.invitation;
      var mediaType = invitation!.mediaType;
      var inviterUserID = invitation.inviterUserID;
      var inviteeUserID = invitation.inviteeUserIDList!.first;
      var groupID = invitation.groupID;
      _recordCall(state: state, signaling: signalingInfo, duration: duration);
      var message = await OpenIM.iMManager.messageManager.createCallMessage(
        state: state.name,
        type: mediaType!,
        duration: duration,
      );
      switch (invitation.sessionType) {
        case 1:
          {
            String? receiverID;
            if (inviterUserID != OpenIM.iMManager.userID) {
              receiverID = inviterUserID;
            } else {
              receiverID = inviteeUserID;
            }

            var msg = await OpenIM.iMManager.messageManager
                .insertSingleMessageToLocalStorage(
              receiverID: inviteeUserID,
              senderID: inviterUserID,
              // receiverID: receiverID,
              // senderID: OpenIM.iMManager.uid,
              message: message
                ..status = 2
                ..isRead = true,
            );

            onSignalingMessage
                ?.call(SignalingMessageEvent(msg, 1, receiverID, null));
            // signalingMessageSubject.add(
            //   SignalingMessageEvent(msg, 1, receiverID, null),
            // );
          }
          break;
        case 2:
          {
            // signalingMessageSubject.add(
            //   SignalingMessageEvent(message, 2, null, groupID),
            // );
            // OpenIM.iMManager.messageManager.insertGroupMessageToLocalStorage(
            //   groupID: groupID!,
            //   senderID: inviterUserID,
            //   message: message..status = 2,
            // );
          }
          break;
      }
    })();
  }

  /// 播放提示音
  void _playSound({bool vibrate = false}) async {
    // if (!_audioPlayer.playerState.playing) {
    // _audioPlayer.setAsset(_ring, package: 'miti_common');
    // _audioPlayer.setLoopMode(LoopMode.one);
    // _audioPlayer.setVolume(1.0);
    // _audioPlayer.play();
    FlutterRingtonePlayer().play(
        fromAsset: "packages/miti_common/assets/audio/live_ring_loop.wav");

    if (vibrate) {
      try {
        int n = 30;
        List<int> pattern =
            List.generate(n * 2, (index) => index % 2 == 0 ? 500 : 1000);
        Vibration.vibrate(pattern: pattern);
      } catch (e) {
        myLogger.e({"设备不支持震动"});
      }
    }
    // }
  }

  /// 关闭提示音
  void _stopBeepAndVibrate() async {
    // if (_audioPlayer.playerState.playing) {
    //   _audioPlayer.stop();
    // }
    try {
      FlutterRingtonePlayer().play(fromAsset: "packages/miti_common/assets/audio/live_ring_loop.wav", volume: 0);
      FlutterRingtonePlayer().stop();
      Vibration.cancel();
    } catch (e) {
      myLogger.e({"message": "震动关闭失败或者铃声关闭失败", "error": e});
    }
  }

  void _recordCall({
    required CallState state,
    required SignalingInfo signaling,
    int duration = 0,
  }) async {
    var invitation = signaling.invitation;
    if (invitation!.sessionType != ConversationType.single) return;
    var mediaType = invitation.mediaType;
    var inviterUserID = invitation.inviterUserID;
    var inviteeUserID = invitation.inviteeUserIDList!.first;
    // var groupID = invitation.groupID;
    var isMeCall = inviterUserID == OpenIM.iMManager.userID;
    var userID = isMeCall ? inviteeUserID : inviterUserID!;
    var incomingCall = isMeCall ? false : true;
    var userInfo =
        (await OpenIM.iMManager.userManager.getUsersInfo(userIDList: [userID]))
            .firstOrNull;
    if (null == userInfo) return;
    final cache = Get.find<HiveCtrl>();
    cache.addCallRecords(CallRecords(
      userID: userID,
      nickname: userInfo.nickname,
      faceURL: userInfo.faceURL,
      success: state == CallState.hangup || state == CallState.beHangup,
      date: DateTime.now().millisecondsSinceEpoch,
      type: mediaType!,
      incomingCall: incomingCall,
      duration: duration,
    ));
  }
}

class SignalingMessageEvent {
  Message message;
  String? userID;
  String? groupID;
  int sessionType;

  SignalingMessageEvent(
    this.message,
    this.sessionType,
    this.userID,
    this.groupID,
  );

  /// 单聊消息
  bool get isSingleChat => sessionType == ConversationType.single;

  /// 群聊消息
  bool get isGroupChat =>
      sessionType == ConversationType.group ||
      sessionType == ConversationType.superGroup;
}
