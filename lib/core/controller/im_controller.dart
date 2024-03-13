import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/core/controller/app_controller.dart';
import 'package:miti/utils/misc.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_live/openim_live.dart';
import 'dart:convert';
import '../im_callback.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';

class IMController extends GetxController with IMCallback, OpenIMLive {
  late Rx<UserFullInfo> userInfo;
  late String atAllTag;

  @override
  void onClose() {
    super.close();
    // OpenIM.iMManager.unInitSDK();
    onCloseLive();
    super.onClose();
  }

  @override
  void onInit() async {
    super.onInit();
    onInitLive();
    // Initialize SDK
    WidgetsBinding.instance.addPostFrameCallback((_) => initOpenIM());
  }

  Future<void> unInitOpenIM() async {
    await OpenIM.iMManager.unInitSDK();
  }

  bool isLogined() {
    return OpenIM.iMManager.isLogined;
  }

  Future<void> initOpenIM() async {
    final initialized = await OpenIM.iMManager.initSDK(
      platformID: IMUtils.getPlatform(),
      apiAddr: Config.imApiUrl,
      wsAddr: Config.imWsUrl,
      dataDir: Config.cachePath,
      logLevel: 6,
      logFilePath: Config.cachePath,
      listener: OnConnectListener(
        onConnecting: () {
          imSdkStatus(IMSdkStatus.connecting);
        },
        onConnectFailed: (code, error) {
          imSdkStatus(IMSdkStatus.connectionFailed);
          myLogger.e({
            "message": "im连接失败",
            "error": {"code": code, "error": error}
          });
        },
        onConnectSuccess: () {
          imSdkStatus(IMSdkStatus.connectionSucceeded);
          myLogger.i({"message": "im连接成功"});
        },
        onKickedOffline: () => kickedOffline("KickedOffline"),
        onUserTokenExpired: () => kickedOffline("UserTokenExpired"),
      ),
    );
    // Set listener
    OpenIM.iMManager
      ..setUploadLogsListener(
          OnUploadLogsListener(onUploadProgress: uploadLogsProgress))
      //
      ..userManager.setUserListener(OnUserListener(
          onSelfInfoUpdated: (u) {
            userInfo.update((val) {
              val?.nickname = u.nickname;
              val?.faceURL = u.faceURL;
              // val?.gender = u.gender;
              // val?.birth = u.birth;
              // val?.email = u.email;
              val?.remark = u.remark;
              val?.ex = u.ex;
              val?.globalRecvMsgOpt = u.globalRecvMsgOpt;
            });
            // _queryMyFullInfo();
          },
          onUserStatusChanged: userStausChanged))
      // Add message listener (remove when not in use)
      ..messageManager.setAdvancedMsgListener(OnAdvancedMsgListener(
          onRecvC2CReadReceipt: recvC2CMessageReadReceipt,
          onRecvNewMessage: recvNewMessage,
          onRecvGroupReadReceipt: recvGroupMessageReadReceipt,
          onNewRecvMessageRevoked: recvMessageRevoked,
          onRecvOfflineNewMessage: recvOfflineMessage))

      // Set up message sending progress listener
      ..messageManager.setMsgSendProgressListener(OnMsgSendProgressListener(
        onProgress: progressCallback,
      ))
      ..messageManager.setCustomBusinessListener(OnCustomBusinessListener(
        onRecvCustomBusinessMessage: recvCustomBusinessMessage,
      ))
      // Set up friend relationship listener
      ..friendshipManager.setFriendshipListener(OnFriendshipListener(
        onBlackAdded: blacklistAdded,
        onBlackDeleted: blacklistDeleted,
        onFriendApplicationAccepted: friendApplicationAccepted,
        onFriendApplicationAdded: friendApplicationAdded,
        onFriendApplicationDeleted: friendApplicationDeleted,
        onFriendApplicationRejected: friendApplicationRejected,
        onFriendInfoChanged: friendInfoChanged,
        onFriendAdded: friendAdded,
        onFriendDeleted: friendDeleted,
      ))

      // Set up conversation listener
      ..conversationManager.setConversationListener(OnConversationListener(
        onConversationChanged: conversationChanged,
        onNewConversation: newConversation,
        onTotalUnreadMessageCountChanged: totalUnreadMsgCountChanged,
        onSyncServerFailed: () {
          imSdkStatus(IMSdkStatus.syncFailed);
        },
        onSyncServerFinish: () async {
          imSdkStatus(IMSdkStatus.syncEnded);
          if (Platform.isAndroid) {
            await requestBackgroundPermission();
            Permissions.request([Permission.systemAlertWindow]);
          }
        },
        onSyncServerStart: () {
          imSdkStatus(IMSdkStatus.syncStart);
        },
      ))

      // Set up group listener
      ..groupManager.setGroupListener(OnGroupListener(
        onGroupApplicationAccepted: groupApplicationAccepted,
        onGroupApplicationAdded: groupApplicationAdded,
        onGroupApplicationDeleted: groupApplicationDeleted,
        onGroupApplicationRejected: groupApplicationRejected,
        onGroupInfoChanged: groupInfoChanged,
        onGroupMemberAdded: groupMemberAdded,
        onGroupMemberDeleted: groupMemberDeleted,
        onGroupMemberInfoChanged: groupMemberInfoChanged,
        onJoinedGroupAdded: joinedGroupAdded,
        onJoinedGroupDeleted: joinedGroupDeleted,
      ))
      // Set up signaling listener
      ..signalingManager.setSignalingListener(OnSignalingListener(
        onInvitationCancelled: invitationCancelled,
        onInvitationTimeout: invitationTimeout,
        onInviteeAccepted: inviteeAccepted,
        onInviteeRejected: inviteeRejected,
        onReceiveNewInvitation: (SignalingInfo info) {
          receiveNewInvitation(info);
          final appLogic = Get.find<AppController>();
          appLogic.promptLiveNotification(info);
        },
        onInviteeAcceptedByOtherDevice: inviteeAcceptedByOtherDevice,
        onInviteeRejectedByOtherDevice: inviteeRejectedByOtherDevice,
        onHangup: beHangup,
        onRoomParticipantConnected: roomParticipantConnected,
        onRoomParticipantDisconnected: roomParticipantDisconnected,
        // onMeetingStreamChanged: meetingSteamChanged,
      ));

    initializedSubject.sink.add(initialized);
  }

  Future login(String userID, String token) async {
    try {
      var user = await OpenIM.iMManager.login(
        userID: userID,
        token: token,
        defaultValue: () async => UserInfo(userID: userID),
      );
      userInfo = UserFullInfo.fromJson(user.toJson()).obs;
      _queryMyFullInfo();
      _queryAtAllTag();
    } catch (e, s) {
      Logger.print('e: $e  s:$s');
      myLogger.e({"message": "im登录错误", "error": e, "stack": s});
      await _handleLoginRepeatError(e);
      // rethrow;
      return Future.error(e, s);
    }
  }

  Future logout() {
    myLogger.w({"message": "im_controller, 退出登录"});
    return OpenIM.iMManager.logout();
  }

  /// @所有人ID
  void _queryAtAllTag() async {
    atAllTag = OpenIM.iMManager.conversationManager.atAllTag;
    // atAllTag = await OpenIM.iMManager.conversationManager.getAtAllTag();
  }

  void _queryMyFullInfo() async {
    final data = await Apis.queryMyFullInfo();
    if (data is UserFullInfo) {
      userInfo.update((val) {
        val?.allowAddFriend = data.allowAddFriend;
        val?.allowBeep = data.allowBeep;
        val?.allowVibration = data.allowVibration;
        val?.nickname = data.nickname;
        val?.faceURL = data.faceURL;
        val?.phoneNumber = data.phoneNumber;
        val?.email = data.email;
        val?.birth = data.birth;
        val?.gender = data.gender;
      });
    }
  }

  _handleLoginRepeatError(e) async {
    if (e is PlatformException && e.code == "13002") {
      myLogger
          .e({"message": "_handleLoginRepeatError, ${json.encode(e)}, 退出登录"});
      await logout();
      await DataSp.removeLoginCertificate();
    }
  }
}
