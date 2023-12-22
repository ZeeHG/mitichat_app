import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import 'pages/group/room.dart';
import 'pages/single/room.dart';

enum CallType { audio, video }

enum CallObj { single, group }

enum CallState {
  call, // 主动邀请
  beCalled, // 被邀请
  reject, // 拒绝
  beRejected, // 被拒绝
  calling, // 通话中
  beAccepted, // 已接受
  hangup, // 主动挂断
  beHangup, // 被对方挂断
  connecting,
  // noReply, // 无响应
  otherAccepted, // 其他端接受
  otherReject, // 其他端拒绝
  cancel, // 主动取消
  beCanceled, // 被取消
  timeout, //超时
  join, //主动加入（群通话）
  // busyLine, // 繁忙
  networkError,
}

class CallEvent {
  CallState state;
  SignalingInfo data;
  dynamic fields;

  CallEvent(this.state, this.data, {this.fields});

  @override
  String toString() {
    return 'CallEvent{state: $state, data: $data, fields: $fields}';
  }
}

class OpenIMLiveClient implements RTCBridge {
  OpenIMLiveClient._();

  static final OpenIMLiveClient singleton = OpenIMLiveClient._();

  factory OpenIMLiveClient() {
    PackageBridge.rtcBridge = singleton;
    return singleton;
  }

  @override
  bool get hasConnection => isBusy;

  @override
  void dismiss() {
    close();
  }

  static OverlayEntry? _holder;

  /// 占线
  bool isBusy = false;

  String? currentRoomID;

  closeByRoomID(String roomID) {
    if (currentRoomID == roomID) {
      close();
    }
  }

  close() {
    if (_holder != null) {
      _holder?.remove();
      _holder = null;
    }
    isBusy = false;
    currentRoomID = null;
    // The next line disables the wakelock again.
    WakelockPlus.disable();
  }

  start(
    BuildContext ctx, {
    required PublishSubject<CallEvent> callEventSubject,
    String? roomID,
    CallState initState = CallState.call,
    CallType callType = CallType.video,
    CallObj callObj = CallObj.single,
    required String inviterUserID,
    required List<String> inviteeUserIDList,
    String? groupID,
    Future<SignalingCertificate> Function()? onDialSingle,
    Future<SignalingCertificate> Function()? onDialGroup,
    Future<SignalingCertificate> Function()? onJoinGroup,
    Future<SignalingCertificate> Function()? onTapPickup,
    Future Function()? onTapCancel,
    Future Function(int duration, bool isPositive)? onTapHangup,
    Future Function()? onTapReject,
    Future<UserInfo?> Function(String userID)? onSyncUserInfo,
    Future<GroupInfo?> Function(String groupID)? onSyncGroupInfo,
    Future<List<GroupMembersInfo>> Function(String groupID, List<String> memberIDList)? onSyncGroupMemberInfo,
    bool autoPickup = false,
    Function()? onWaitingAccept,
    Function()? onBusyLine,
    Function()? onStartCalling,
    Function(dynamic error, dynamic stack)? onError,
    Function()? onClose,
    Function()? onRoomDisconnected,
  }) {
    if (isBusy) return;
    // close();
    isBusy = true;
    currentRoomID = roomID;

    FocusScope.of(ctx).requestFocus(FocusNode());

    if (callObj == CallObj.single) {
      _holder = OverlayEntry(
          builder: (context) => SingleRoomView(
                callType: callType,
                initState: initState,
                callEventSubject: callEventSubject,
                roomID: roomID,
                userID: initState == CallState.call ? inviteeUserIDList.first : inviterUserID,
                onDial: onDialSingle,
                onTapCancel: onTapCancel,
                onTapHangup: onTapHangup,
                onTapReject: onTapReject,
                onTapPickup: onTapPickup,
                onSyncUserInfo: onSyncUserInfo,
                autoPickup: autoPickup,
                onBindRoomID: (roomID) => currentRoomID = roomID,
                onWaitingAccept: onWaitingAccept,
                onBusyLine: onBusyLine,
                onStartCalling: onStartCalling,
                onError: onError,
                onRoomDisconnected: onRoomDisconnected,
                onClose: () {
                  onClose?.call();
                  close();
                },
              ));
    } else {
      _holder = OverlayEntry(
          builder: (context) => GroupRoomView(
                callType: callType,
                initState: initState,
                callEventSubject: callEventSubject,
                roomID: roomID,
                inviterUserID: inviterUserID,
                inviteeUserIDList: inviteeUserIDList,
                groupID: groupID!,
                onDial: onDialGroup,
                onJoin: onJoinGroup,
                onTapCancel: onTapCancel,
                onTapHangup: onTapHangup,
                onTapReject: onTapReject,
                onTapPickup: onTapPickup,
                onSyncGroupInfo: onSyncGroupInfo,
                onSyncGroupMemberInfo: onSyncGroupMemberInfo,
                onBindRoomID: (roomID) => currentRoomID = roomID,
                onError: onError,
                onRoomDisconnected: onRoomDisconnected,
                autoPickup: autoPickup,
                onClose: () {
                  onClose?.call();
                  close();
                },
              ));
    }

    Overlay.of(ctx).insert(_holder!);
    // The following line will enable the Android and iOS wakelock.
    WakelockPlus.enable();
  }
}
