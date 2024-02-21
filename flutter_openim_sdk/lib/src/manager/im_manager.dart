import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_openim_sdk/src/logger.dart';

class IMManager {
  MethodChannel _channel;
  late ConversationManager conversationManager;
  late FriendshipManager friendshipManager;
  late MessageManager messageManager;
  late GroupManager groupManager;
  late UserManager userManager;
  late SignalingManager signalingManager;

  late OnConnectListener _connectListener;
  OnListenerForService? _listenerForService;
  OnUploadFileListener? _uploadFileListener;
  OnUploadLogsListener? _uploadLogsListener;

  late String userID;
  late UserInfo userInfo;
  bool isLogined = false;
  String? token;

  IMManager(this._channel) {
    conversationManager = ConversationManager(_channel);
    friendshipManager = FriendshipManager(_channel);
    messageManager = MessageManager(_channel);
    groupManager = GroupManager(_channel);
    userManager = UserManager(_channel);
    signalingManager = SignalingManager(_channel);
    _addNativeCallback(_channel);
  }

  void _addNativeCallback(MethodChannel _channel) {
    _channel.setMethodCallHandler((call) {
      try {
        Logger.print('Flutter : $call');
        if (call.method == ListenerType.connectListener) {
          String type = call.arguments['type'];
          switch (type) {
            case 'onConnectFailed':
              int? errCode = call.arguments['errCode'];
              String? errMsg = call.arguments['errMsg'];
              _connectListener.connectFailed(errCode, errMsg);
              break;
            case 'onConnecting':
              _connectListener.connecting();
              break;
            case 'onConnectSuccess':
              _connectListener.connectSuccess();
              break;
            case 'onKickedOffline':
              _connectListener.kickedOffline();
              break;
            case 'onUserTokenExpired':
              _connectListener.userTokenExpired();
              break;
          }
        } else if (call.method == ListenerType.userListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];
          switch (type) {
            case 'onSelfInfoUpdated':
              userInfo = Utils.toObj(data, (map) => UserInfo.fromJson(map));
              userManager.listener.selfInfoUpdated(userInfo);
              break;
            case 'onUserStatusChanged':
              final status =
                  Utils.toObj(data, (map) => UserStatusInfo.fromJson(map));
              userManager.listener.userStatusChanged(status);
              break;
          }
        } else if (call.method == ListenerType.groupListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];
          switch (type) {
            case 'onGroupApplicationAccepted':
              final i = Utils.toObj(
                  data, (map) => GroupApplicationInfo.fromJson(map));
              groupManager.listener.groupApplicationAccepted(i);
              break;
            case 'onGroupApplicationAdded':
              final i = Utils.toObj(
                  data, (map) => GroupApplicationInfo.fromJson(map));
              groupManager.listener.groupApplicationAdded(i);
              break;
            case 'onGroupApplicationDeleted':
              final i = Utils.toObj(
                  data, (map) => GroupApplicationInfo.fromJson(map));
              groupManager.listener.groupApplicationDeleted(i);
              break;
            case 'onGroupApplicationRejected':
              final i = Utils.toObj(
                  data, (map) => GroupApplicationInfo.fromJson(map));
              groupManager.listener.groupApplicationRejected(i);
              break;
            case 'onGroupDismissed':
              final i = Utils.toObj(data, (map) => GroupInfo.fromJson(map));
              groupManager.listener.groupDismissed(i);
              break;
            case 'onGroupInfoChanged':
              final i = Utils.toObj(data, (map) => GroupInfo.fromJson(map));
              groupManager.listener.groupInfoChanged(i);
              break;
            case 'onGroupMemberAdded':
              final i =
                  Utils.toObj(data, (map) => GroupMembersInfo.fromJson(map));
              groupManager.listener.groupMemberAdded(i);
              break;
            case 'onGroupMemberDeleted':
              final i =
                  Utils.toObj(data, (map) => GroupMembersInfo.fromJson(map));
              groupManager.listener.groupMemberDeleted(i);
              break;
            case 'onGroupMemberInfoChanged':
              final i =
                  Utils.toObj(data, (map) => GroupMembersInfo.fromJson(map));
              groupManager.listener.groupMemberInfoChanged(i);
              break;
            case 'onJoinedGroupAdded':
              final i = Utils.toObj(data, (map) => GroupInfo.fromJson(map));
              groupManager.listener.joinedGroupAdded(i);
              break;
            case 'onJoinedGroupDeleted':
              final i = Utils.toObj(data, (map) => GroupInfo.fromJson(map));
              groupManager.listener.joinedGroupDeleted(i);
              break;
          }
        } else if (call.method == ListenerType.advancedMsgListener) {
          var type = call.arguments['type'];
          // var id = call.arguments['data']['id'];
          switch (type) {
            case 'onMsgDeleted':
              var value = call.arguments['data']['message'];
              final msg = Utils.toObj(value, (map) => Message.fromJson(map));
              messageManager.msgListener.msgDeleted(msg);
              break;
            case 'onNewRecvMessageRevoked':
              var value = call.arguments['data']['messageRevoked'];
              var info = Utils.toObj(value, (map) => RevokedInfo.fromJson(map));
              messageManager.msgListener.newRecvMessageRevoked(info);
              break;
            case 'onRecvC2CReadReceipt':
              var value = call.arguments['data']['msgReceiptList'];
              var list =
                  Utils.toList(value, (map) => ReadReceiptInfo.fromJson(map));
              messageManager.msgListener.recvC2CReadReceipt(list);
              break;
            case 'onRecvGroupReadReceipt':
              var value = call.arguments['data']['groupMsgReceiptList'];
              var list = Utils.toObj(
                  value, (map) => GroupMessageReceipt.fromJson(map));
              messageManager.msgListener.recvGroupReadReceipt(list);
              break;
            case 'onRecvMessageExtensionsAdded':
              var msgID = call.arguments['data']['msgID'];
              var value = call.arguments['data']['reactionExtensionList'];
              var list = Utils.toList(value, (map) => KeyValue.fromJson(map));
              messageManager.msgListener
                  .recvMessageExtensionsAdded(msgID, list);
              break;
            case 'onRecvMessageExtensionsChanged':
              var msgID = call.arguments['data']['msgID'];
              var value = call.arguments['data']['reactionExtensionList'];
              var list = Utils.toList(value, (map) => KeyValue.fromJson(map));
              messageManager.msgListener
                  .recvMessageExtensionsChanged(msgID, list);
              break;
            case 'onRecvMessageExtensionsDeleted':
              var msgID = call.arguments['data']['msgID'];
              var value = call.arguments['data']['reactionExtensionKeyList'];
              var list = Utils.toList(value, (map) => '$map');
              messageManager.msgListener
                  .recvMessageExtensionsDeleted(msgID, list);
              break;

            case 'onRecvNewMessage':
              var value = call.arguments['data']['message'];
              final msg = Utils.toObj(value, (map) => Message.fromJson(map));
              messageManager.msgListener.recvNewMessage(msg);
              break;
            case 'onRecvOfflineNewMessage':
              var value = call.arguments['data']['message'];
              final msg = Utils.toObj(value, (map) => Message.fromJson(map));
              messageManager.msgListener.recvOfflineNewMessage(msg);
              break;
            case 'onRecvOnlineOnlyMessage':
              var value = call.arguments['data']['message'];
              final msg = Utils.toObj(value, (map) => Message.fromJson(map));
              messageManager.msgListener.recvOnlineOnlyMessage(msg);
              break;
          }
        } else if (call.method == ListenerType.msgSendProgressListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];
          String msgID = data['clientMsgID'] ?? '';
          int progress = data['progress'] ?? 100;
          switch (type) {
            case 'onProgress':
              messageManager.msgSendProgressListener?.progress(
                msgID,
                progress,
              );
              break;
          }
        } else if (call.method == ListenerType.conversationListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];
          switch (type) {
            case 'onSyncServerStart':
              conversationManager.listener.syncServerStart();
              break;
            case 'onSyncServerFinish':
              conversationManager.listener.syncServerFinish();
              break;

            case 'onSyncServerFailed':
              conversationManager.listener.syncServerFailed();
              break;
            case 'onNewConversation':
              var list =
                  Utils.toList(data, (map) => ConversationInfo.fromJson(map));
              conversationManager.listener.newConversation(list);
              break;
            case 'onConversationChanged':
              var list =
                  Utils.toList(data, (map) => ConversationInfo.fromJson(map));
              conversationManager.listener.conversationChanged(list);
              break;
            case 'onTotalUnreadMessageCountChanged':
              conversationManager.listener
                  .totalUnreadMessageCountChanged(data ?? 0);
              break;
          }
        } else if (call.method == ListenerType.friendListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];

          switch (type) {
            case 'onBlackAdded':
              final u = Utils.toObj(data, (map) => BlacklistInfo.fromJson(map));
              friendshipManager.listener.blackAdded(u);
              break;
            case 'onBlackDeleted':
              final u = Utils.toObj(data, (map) => BlacklistInfo.fromJson(map));
              friendshipManager.listener.blackDeleted(u);
              break;
            case 'onFriendAdded':
              final u = Utils.toObj(data, (map) => FriendInfo.fromJson(map));
              friendshipManager.listener.friendAdded(u);
              break;
            case 'onFriendApplicationAccepted':
              final u = Utils.toObj(
                  data, (map) => FriendApplicationInfo.fromJson(map));
              friendshipManager.listener.friendApplicationAccepted(u);
              break;
            case 'onFriendApplicationAdded':
              final u = Utils.toObj(
                  data, (map) => FriendApplicationInfo.fromJson(map));
              friendshipManager.listener.friendApplicationAdded(u);
              break;
            case 'onFriendApplicationDeleted':
              final u = Utils.toObj(
                  data, (map) => FriendApplicationInfo.fromJson(map));
              friendshipManager.listener.friendApplicationDeleted(u);
              break;
            case 'onFriendApplicationRejected':
              final u = Utils.toObj(
                  data, (map) => FriendApplicationInfo.fromJson(map));
              friendshipManager.listener.friendApplicationRejected(u);
              break;
            case 'onFriendDeleted':
              final u = Utils.toObj(data, (map) => FriendInfo.fromJson(map));
              friendshipManager.listener.friendDeleted(u);
              break;
            case 'onFriendInfoChanged':
              final u = Utils.toObj(data, (map) => FriendInfo.fromJson(map));
              friendshipManager.listener.friendInfoChanged(u);
              break;
          }
        } else if (call.method == ListenerType.signalingListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];
          dynamic info;
          switch (type) {
            case 'onRoomParticipantConnected':
            case 'onRoomParticipantDisconnected':
              info = Utils.toObj(data, (map) => RoomCallingInfo.fromJson(map));
              break;
            case 'onStreamChange':
              info =
                  Utils.toObj(data, (map) => MeetingStreamEvent.fromJson(map));
              break;
            case 'onReceiveCustomSignal':
              info = Utils.toObj(data, (map) => CustomSignaling.fromJson(map));
              break;
            default:
              info = Utils.toObj(data, (map) => SignalingInfo.fromJson(map));
              break;
          }
          switch (type) {
            case 'onInvitationCancelled':
              signalingManager.listener.invitationCancelled(info);
              break;
            case 'onInvitationTimeout':
              signalingManager.listener.invitationTimeout(info);
              break;
            case 'onInviteeAccepted':
              signalingManager.listener.inviteeAccepted(info);
              break;
            case 'onInviteeRejected':
              signalingManager.listener.inviteeRejected(info);
              break;
            case 'onReceiveNewInvitation':
              signalingManager.listener.receiveNewInvitation(info);
              break;
            case 'onInviteeAcceptedByOtherDevice':
              signalingManager.listener.inviteeAcceptedByOtherDevice(info);
              break;
            case 'onInviteeRejectedByOtherDevice':
              signalingManager.listener.inviteeRejectedByOtherDevice(info);
              break;
            case 'onHangUp':
              signalingManager.listener.hangup(info);
              break;
            case 'onRoomParticipantConnected':
              signalingManager.listener.roomParticipantConnected(info);
              break;
            case 'onRoomParticipantDisconnected':
              signalingManager.listener.roomParticipantDisconnected(info);
              break;
            case 'onStreamChange':
              signalingManager.listener.streamChangedEvent(info);
              break;
            case 'onReceiveCustomSignal':
              signalingManager.listener.receiveCustomSignal(info);
              break;
          }
        } else if (call.method == ListenerType.customBusinessListener) {
          String type = call.arguments['type'];
          String data = call.arguments['data'];
          switch (type) {
            case 'onRecvCustomBusinessMessage':
              messageManager.customBusinessListener
                  ?.recvCustomBusinessMessage(data);
              break;
          }
        } else if (call.method == ListenerType.messageKvInfoListener) {
          String type = call.arguments['type'];
          String data = call.arguments['data'];
          switch (type) {
            case 'onMessageKvInfoChanged':
              final list =
                  Utils.toList(data, (map) => MessageKv.fromJson(map)).toList();
              messageManager.messageKvInfoListener?.messageKvInfoChanged(list);
              break;
          }
        } else if (call.method == ListenerType.listenerForService) {
          String type = call.arguments['type'];
          String data = call.arguments['data'];
          switch (type) {
            case 'onFriendApplicationAccepted':
              final u = Utils.toObj(
                  data, (map) => FriendApplicationInfo.fromJson(map));
              _listenerForService?.friendApplicationAccepted(u);
              break;
            case 'onFriendApplicationAdded':
              final u = Utils.toObj(
                  data, (map) => FriendApplicationInfo.fromJson(map));
              _listenerForService?.friendApplicationAdded(u);
              break;
            case 'onGroupApplicationAccepted':
              final i = Utils.toObj(
                  data, (map) => GroupApplicationInfo.fromJson(map));
              _listenerForService?.groupApplicationAccepted(i);
              break;
            case 'onGroupApplicationAdded':
              final i = Utils.toObj(
                  data, (map) => GroupApplicationInfo.fromJson(map));
              _listenerForService?.groupApplicationAdded(i);
              break;
            case 'onRecvNewMessage':
              final msg = Utils.toObj(data, (map) => Message.fromJson(map));
              _listenerForService?.recvNewMessage(msg);
              break;
          }
        } else if (call.method == ListenerType.uploadLogsListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];
          switch (type) {
            case 'onProgress':
              int size = data['size'];
              int current = data['current'];
              _uploadLogsListener?.onProgress(current, size);
          }
        } else if (call.method == ListenerType.uploadFileListener) {
          String type = call.arguments['type'];
          dynamic data = call.arguments['data'];
          switch (type) {
            case 'complete':
              String id = data['id'];
              int size = data['size'];
              String url = data['url'];
              int type = data['type'];
              _uploadFileListener?.complete(id, size, url, type);
              break;
            case 'hashPartComplete':
              String id = data['id'];
              String partHash = data['partHash'];
              String fileHash = data['fileHash'];
              _uploadFileListener?.hashPartComplete(id, partHash, fileHash);
              break;
            case 'hashPartProgress':
              String id = data['id'];
              int index = data['index'];
              int size = data['size'];
              String partHash = data['partHash'];
              _uploadFileListener?.hashPartProgress(id, index, size, partHash);
              break;
            case 'open':
              String id = data['id'];
              int size = data['size'];
              _uploadFileListener?.open(id, size);
              break;
            case 'partSize':
              String id = data['id'];
              int partSize = data['partSize'];
              int num = data['num'];
              _uploadFileListener?.partSize(id, partSize, num);
              break;
            case 'uploadProgress':
              String id = data['id'];
              int fileSize = data['fileSize'];
              int streamSize = data['streamSize'];
              int storageSize = data['storageSize'];
              _uploadFileListener?.uploadProgress(
                  id, fileSize, streamSize, storageSize);
              break;
            case 'uploadID':
              String id = data['id'];
              String uploadID = data['uploadID'];
              _uploadFileListener?.uploadID(id, uploadID);
              break;
            case 'uploadPartComplete':
              String id = data['id'];
              int index = data['index'];
              int partSize = data['partSize'];
              String partHash = data['partHash'];
              _uploadFileListener?.uploadPartComplete(
                  id, index, partSize, partHash);
              break;
          }
        }
      } catch (error, stackTrace) {
        Logger.print(
            "回调失败了。${call.method} ${call.arguments['type']} ${call.arguments['data']} $error $stackTrace");
      }
      return Future.value(null);
    });
  }

  Future<bool?> init(
    InitConfig config,
    OnConnectListener listener, {
    String? operationID,
  }) {
    this._connectListener = listener;
    if (config.logFilePath == null) {
      config.logFilePath = config.dataDir;
    }
    return _channel.invokeMethod(
      'initSDK',
      _buildParam(
        {
          ...config.toMap(),
          "operationID": Utils.checkOperationID(operationID),
        },
      ),
    );
  }

  /// Initialize the SDK
  /// [platform] Platform ID [IMPlatform]
  /// [apiAddr] SDK API address
  /// [wsAddr] SDK WebSocket address
  /// [dataDir] SDK database storage directory
  /// [objectStorage] Object storage minio
  /// [logLevel] Log level, 1: no printing
  /// [enabledEncryption] true: encryption
  /// [enabledCompression] true: compression
  Future<dynamic> initSDK({
    required int platformID,
    required String apiAddr,
    required String wsAddr,
    required String dataDir,
    required OnConnectListener listener,
    int logLevel = 6,
    String objectStorage = 'minio',
    bool isCompression = false,
    bool isLogStandardOutput = true,
    String? logFilePath,
    String? operationID,
  }) {
    this._connectListener = listener;
    return _channel.invokeMethod(
      'initSDK',
      _buildParam(
        {
          "platformID": platformID,
          "apiAddr": apiAddr,
          "wsAddr": wsAddr,
          "dataDir": dataDir,
          "logLevel": logLevel,
          "objectStorage": objectStorage,
          "isCompression": isCompression,
          "isLogStandardOutput": isLogStandardOutput,
          "logFilePath": logFilePath,
          "operationID": Utils.checkOperationID(operationID),
        },
      ),
    );
  }

  /// Deinitialize the SDK
  Future<dynamic> unInitSDK() {
    return _channel.invokeMethod('unInitSDK', _buildParam({}));
  }

  /// Login
  /// [userID] User ID
  /// [token] Login token obtained from the business server
  /// [defaultValue] Default value to use if login fails
  Future<UserInfo> login({
    required String userID,
    required String token,
    String? operationID,
    Future<UserInfo> Function()? defaultValue,
    bool checkLoginStatus = true,
  }) async {
    int? status;
    if (checkLoginStatus) {
      // 1: logout 2: logging  3: logged
      status = await getLoginStatus();
    }
    if (status != LoginStatus.logging && status != LoginStatus.logged) {
      await _channel.invokeMethod(
        'login',
        _buildParam({
          'userID': userID,
          'token': token,
          'operationID': Utils.checkOperationID(operationID),
        }),
      );
    }
    this.isLogined = true;
    this.userID = userID;
    this.token = token;
    try {
      return this.userInfo = await userManager.getSelfUserInfo();
    } catch (error, stackTrace) {
      log('login e: $error  s: $stackTrace');
      if (null != defaultValue) {
        return this.userInfo = await (defaultValue.call());
      }
      return Future.error(error, stackTrace);
    }
    // return uInfo;
  }

  /// Logout
  Future<dynamic> logout({String? operationID}) async {
    var value = await _channel.invokeMethod(
      'logout',
      _buildParam({
        'operationID': Utils.checkOperationID(operationID),
      }),
    );
    this.isLogined = false;
    this.token = null;
    return value;
  }

  /// Get login status
  /// 1: logout 2: logging  3: logged
  Future<int?> getLoginStatus({
    String? operationID,
  }) =>
      _channel.invokeMethod<int>(
        'getLoginStatus',
        _buildParam({
          'operationID': Utils.checkOperationID(operationID),
        }),
      );

  /// Get the current logged-in user ID
  Future<String> getLoginUserID() async => userID;

  /// Get the current logged-in user information
  Future<UserInfo> getLoginUserInfo() async => userInfo;

  /// [id] Same as [OnUploadFileListener] ID, to distinguish which file callback it is
  Future uploadFile({
    required String id,
    required String filePath,
    required String fileName,
    String? contentType,
    String? cause,
    String? operationID,
  }) =>
      _channel.invokeMethod(
        'uploadFile',
        _buildParam({
          'id': id,
          'filePath': filePath,
          'name': fileName,
          'contentType': contentType,
          'cause': cause,
          'operationID': Utils.checkOperationID(operationID),
        }),
      );

  /// Update the Firebase client registration token
  /// [fcmToken] Firebase token
  Future updateFcmToken({
    required String fcmToken,
    required int expireTime,
    String? operationID,
  }) =>
      _channel.invokeMethod(
          'updateFcmToken',
          _buildParam({
            'fcmToken': fcmToken,
            'expireTime': expireTime,
            'operationID': Utils.checkOperationID(operationID),
          }));

  /// 上传日志
  /// [uploadlogParams] system_type、ex
  Future uploadLogs({
    String? operationID,
  }) =>
      _channel.invokeMethod(
          'uploadLogs',
          _buildParam({
            'operationID': Utils.checkOperationID(operationID),
          }));

  void setUploadLogsListener(OnUploadLogsListener listener) {
    _uploadLogsListener = listener;
  }

  void setUploadFileListener(OnUploadFileListener listener) {
    _uploadFileListener = listener;
  }

  ///
  Future setListenerForService(OnListenerForService listener) {
    if (Platform.isAndroid) {
      this._listenerForService = listener;
      return _channel.invokeMethod('setListenerForService', _buildParam({}));
    } else {
      throw UnsupportedError("only supprot android platform");
    }
  }

  MethodChannel get channel => _channel;

  static Map _buildParam(Map param) {
    param["ManagerName"] = "imManager";
    return param;
  }
}
