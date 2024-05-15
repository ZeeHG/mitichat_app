import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/utils/message_util.dart';
import 'package:miti_common/miti_common.dart';
// import 'package:openim_meeting/openim_meeting.dart';
import 'package:rxdart/rxdart.dart';

import 'ctrl/app_ctrl.dart';

enum IMSdkStatus {
  connectionFailed,
  connecting,
  connectionSucceeded,
  syncStart,
  synchronizing,
  syncEnded,
  syncFailed,
}

class IMCallback {
  final appCtrl = Get.find<AppCtrl>();

  /// 收到消息撤回
  Function(RevokedInfo info)? onRecvMessageRevoked;

  /// 收到C2C消息已读回执
  Function(List<ReadReceiptInfo> list)? onRecvC2CReadReceipt;

  /// 收到群消息已读回执
  Function(GroupMessageReceipt receipt)? onRecvGroupReadReceipt;

  /// 收到新消息
  Function(Message msg)? onRecvNewMessage;

  /// 收到新消息
  Function(Message msg)? onRecvOfflineMessage;

  /// 消息发送进度回执
  Function(String msgId, int progress)? onMsgSendProgress;

  /// 已加入黑名单
  Function(BlacklistInfo u)? onBlacklistAdd;

  /// 已从黑名单移除
  Function(BlacklistInfo u)? onBlacklistDeleted;

  /// upload logs
  Function(int current, int size)? onUploadProgress;

  var recvGroupReadReceiptSubject = BehaviorSubject<GroupMessageReceipt>();

  /// 新增会话
  var conversationAddedSubject = BehaviorSubject<List<ConversationInfo>>();

  /// 旧会话更新
  var conversationChangedSubject = BehaviorSubject<List<ConversationInfo>>();

  /// 未读消息数
  var unreadMsgCountEventSubject = PublishSubject<int>();

  /// 好友申请列表变化（包含自己发出的以及收到的）
  var friendApplicationChangedSubject =
      BehaviorSubject<FriendApplicationInfo>();

  /// 新增好友
  var friendAddSubject = BehaviorSubject<FriendInfo>();

  /// 删除好友
  var friendDelSubject = BehaviorSubject<FriendInfo>();

  /// 好友信息改变
  var friendInfoChangedSubject = BehaviorSubject<FriendInfo>();

  /// 自己信息更新
  var selfInfoUpdatedSubject = BehaviorSubject<UserInfo>();

  /// 用户在线状态更新
  var userStatusChangedSubject = BehaviorSubject<UserStatusInfo>();

  /// 组信息更新
  var groupInfoUpdatedSubject = BehaviorSubject<GroupInfo>();

  /// 组申请列表变化（包含自己发出的以及收到的）
  var groupApplicationChangedSubject = BehaviorSubject<GroupApplicationInfo>();

  var initializedSubject = PublishSubject<bool>();

  /// 群成员收到：群成员已进入
  var memberAddedSubject = BehaviorSubject<GroupMembersInfo>();

  /// 群成员收到：群成员已退出
  var memberDeletedSubject = BehaviorSubject<GroupMembersInfo>();

  /// 群成员信息变化
  var memberInfoChangedSubject = PublishSubject<GroupMembersInfo>();

  /// 被踢
  var joinedGroupDeletedSubject = BehaviorSubject<GroupInfo>();

  /// 拉人
  var joinedGroupAddedSubject = BehaviorSubject<GroupInfo>();

  var onKickedOfflineSubject = PublishSubject();

  var imSdkStatusSubject = BehaviorSubject<IMSdkStatus>();

  var roomParticipantDisconnectedSubject = PublishSubject<RoomCallingInfo>();

  var roomParticipantConnectedSubject = PublishSubject<RoomCallingInfo>();

  var momentsSubject = PublishSubject<WorkMomentsNotification>();

  var inviteApplySubject = PublishSubject<Map<String, dynamic>>();

  var inviteApplyHandleSubject = PublishSubject<Map<String, dynamic>>();

  // var customBusinessSubject = PublishSubject();

  // var meetingSteamChangedSubject = PublishSubject<dynamic>();

  void imSdkStatus(IMSdkStatus status) {
    imSdkStatusSubject.add(status);
  }

  void kickedOffline(String type) {
    myLogger.e({
      "message":
          "触发im_controller的onKickedOffline或者kickedOffline, type=$type, 退出登录"
    });
    onKickedOfflineSubject.add(type);
  }

  void selfInfoUpdated(UserInfo u) {
    selfInfoUpdatedSubject.addSafely(u);
  }

  void userStatusChanged(UserStatusInfo u) {
    userStatusChangedSubject.addSafely(u);
  }

  void uploadLogsProgress(int current, int size) {
    onUploadProgress?.call(current, size);
  }

  void recvMessageRevoked(RevokedInfo info) {
    onRecvMessageRevoked?.call(info);
  }

  void recvC2CMessageReadReceipt(List<ReadReceiptInfo> list) {
    onRecvC2CReadReceipt?.call(list);
  }

  void recvGroupMessageReadReceipt(GroupMessageReceipt receipt) {
    onRecvGroupReadReceipt?.call(receipt);
    recvGroupReadReceiptSubject.addSafely(receipt);
  }

  void recvNewMessage(Message msg) {
    appCtrl.showNotification(msg);
    if (Get.isRegistered<MessageUtil>()) {
      final messageUtil = Get.find<MessageUtil>();
      messageUtil.cacheVoiceMessageList([msg]);
    }
    onRecvNewMessage?.call(msg);
  }

  void recvOfflineMessage(Message msg) {
    appCtrl.showNotification(msg);
    if (Get.isRegistered<MessageUtil>()) {
      final messageUtil = Get.find<MessageUtil>();
      messageUtil.cacheVoiceMessageList([msg]);
    }
    onRecvOfflineMessage?.call(msg);
  }

  void recvCustomBusinessMessage(String s) {
    // customBusinessSubject.add(s);
    final result = jsonDecode(s);
    final key = result['key'];
    final data = result['data'];
    if ("wm_at" == key ||
        "wm_like" == key ||
        "wm_comment" == key ||
        "wm_delete_comment" == key) {
      final json = jsonDecode(data);
      json["key"] = key;
      momentsSubject.add(WorkMomentsNotification.fromJson(json));
    }

    if (["invite_apply", "invite_apply_handle"].contains(key)) {
      // final invite_apply = {
      //   "user": {
      //     "userID": "3257074535",
      //     "account": "ffdd",
      //     "nickname": "ffdd",
      //     "level": 1,
      //     "mitiID": "3257074535"
      //   },
      //   "inviteUserID": "2770111344",
      //   "inviteTime": 1715771089,
      //   "key": "invite_apply"
      // };

      // final invite_apply_handle = {
      //   "invitedUser": "3257074535",
      //   "inviteUser": {
      //     "userID": "2770111344",
      //     "account": "aaa",
      //     "nickname": "aaa",
      //     "level": 1,
      //     "mitiID": "a11111"
      //   },
      //   "handleResult": 1,
      //   "handleTime": 1715771155,
      //   "key": "invite_apply_handle"
      // };
      var json = jsonDecode(data);
      json = json["body"];
      json["key"] = key;
      if ("invite_apply" == key) {
        inviteApplySubject.add(json);
      } else if ("invite_apply_handle" == key) {
        inviteApplyHandleSubject.add(json);
      }
    }
  }

  void progressCallback(String msgId, int progress) {
    onMsgSendProgress?.call(msgId, progress);
  }

  void blacklistAdded(BlacklistInfo u) {
    onBlacklistAdd?.call(u);
  }

  void blacklistDeleted(BlacklistInfo u) {
    onBlacklistDeleted?.call(u);
  }

  void friendApplicationAccepted(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationAdded(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationDeleted(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendApplicationRejected(FriendApplicationInfo u) {
    friendApplicationChangedSubject.addSafely(u);
  }

  void friendInfoChanged(FriendInfo u) {
    friendInfoChangedSubject.addSafely(u);
  }

  void friendAdded(FriendInfo u) {
    friendAddSubject.addSafely(u);
  }

  void friendDeleted(FriendInfo u) {
    friendDelSubject.addSafely(u);
  }

  void conversationChanged(List<ConversationInfo> list) {
    conversationChangedSubject.addSafely(list);
  }

  void newConversation(List<ConversationInfo> list) {
    conversationAddedSubject.addSafely(list);
  }

  void groupApplicationAccepted(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupApplicationAdded(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupApplicationDeleted(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupApplicationRejected(GroupApplicationInfo info) {
    groupApplicationChangedSubject.add(info);
  }

  void groupInfoChanged(GroupInfo info) {
    groupInfoUpdatedSubject.addSafely(info);
  }

  void groupMemberAdded(GroupMembersInfo info) {
    memberAddedSubject.add(info);
  }

  void groupMemberDeleted(GroupMembersInfo info) {
    memberDeletedSubject.add(info);
  }

  void groupMemberInfoChanged(GroupMembersInfo info) {
    memberInfoChangedSubject.add(info);
  }

  /// 创建群： 初始成员收到；邀请进群：被邀请者收到
  void joinedGroupAdded(GroupInfo info) {
    joinedGroupAddedSubject.add(info);
  }

  /// 退出群：退出者收到；踢出群：被踢者收到
  void joinedGroupDeleted(GroupInfo info) {
    joinedGroupDeletedSubject.add(info);
  }

  void totalUnreadMsgCountChanged(int count) {
    // appCtrl.showBadge(count);
    unreadMsgCountEventSubject.addSafely(count);
  }

  /// 群通话信息变更
  void roomParticipantConnected(RoomCallingInfo info) {
    roomParticipantConnectedSubject.add(info);
  }

  /// 群通话信息变更
  void roomParticipantDisconnected(RoomCallingInfo info) {
    roomParticipantDisconnectedSubject.add(info);
  }

  // void meetingSteamChanged(MeetingStreamEvent event) {
  //   MeetingClient().subject?.add(event);
  // }

  void close() {
    initializedSubject.close();
    friendApplicationChangedSubject.close();
    friendAddSubject.close();
    friendDelSubject.close();
    friendInfoChangedSubject.close();
    selfInfoUpdatedSubject.close();
    groupInfoUpdatedSubject.close();
    conversationAddedSubject.close();
    conversationChangedSubject.close();
    memberAddedSubject.close();
    memberDeletedSubject.close();
    memberInfoChangedSubject.close();
    onKickedOfflineSubject.close();
    groupApplicationChangedSubject.close();
    momentsSubject.close();
    inviteApplySubject.close();
    inviteApplyHandleSubject.close();
    imSdkStatusSubject.close();
    roomParticipantConnectedSubject.close();
    roomParticipantDisconnectedSubject.close();
    joinedGroupDeletedSubject.close();
    joinedGroupAddedSubject.close();
    // meetingSteamChangedSubject.close();
    // customBusinessSubject.close();

    recvGroupReadReceiptSubject.close();
    unreadMsgCountEventSubject.close();
    userStatusChangedSubject.close();
  }

  void reBuildSubject() {
    close();
    recvGroupReadReceiptSubject = BehaviorSubject<GroupMessageReceipt>();

    /// 新增会话
    conversationAddedSubject = BehaviorSubject<List<ConversationInfo>>();

    /// 旧会话更新
    conversationChangedSubject = BehaviorSubject<List<ConversationInfo>>();

    /// 未读消息数
    unreadMsgCountEventSubject = PublishSubject<int>();

    /// 好友申请列表变化（包含自己发出的以及收到的）
    friendApplicationChangedSubject = BehaviorSubject<FriendApplicationInfo>();

    /// 新增好友
    friendAddSubject = BehaviorSubject<FriendInfo>();

    /// 删除好友
    friendDelSubject = BehaviorSubject<FriendInfo>();

    /// 好友信息改变
    friendInfoChangedSubject = BehaviorSubject<FriendInfo>();

    /// 自己信息更新
    selfInfoUpdatedSubject = BehaviorSubject<UserInfo>();

    /// 用户在线状态更新
    userStatusChangedSubject = BehaviorSubject<UserStatusInfo>();

    /// 组信息更新
    groupInfoUpdatedSubject = BehaviorSubject<GroupInfo>();

    /// 组申请列表变化（包含自己发出的以及收到的）
    groupApplicationChangedSubject = BehaviorSubject<GroupApplicationInfo>();

    initializedSubject = PublishSubject<bool>();

    /// 群成员收到：群成员已进入
    memberAddedSubject = BehaviorSubject<GroupMembersInfo>();

    /// 群成员收到：群成员已退出
    memberDeletedSubject = BehaviorSubject<GroupMembersInfo>();

    /// 群成员信息变化
    memberInfoChangedSubject = PublishSubject<GroupMembersInfo>();

    /// 被踢
    joinedGroupDeletedSubject = BehaviorSubject<GroupInfo>();

    /// 拉人
    joinedGroupAddedSubject = BehaviorSubject<GroupInfo>();

    onKickedOfflineSubject = PublishSubject();

    imSdkStatusSubject = BehaviorSubject<IMSdkStatus>();

    roomParticipantDisconnectedSubject = PublishSubject<RoomCallingInfo>();

    roomParticipantConnectedSubject = PublishSubject<RoomCallingInfo>();

    momentsSubject = PublishSubject<WorkMomentsNotification>();

    inviteApplySubject = PublishSubject<Map<String, dynamic>>();

    inviteApplyHandleSubject = PublishSubject<Map<String, dynamic>>();

    // customBusinessSubject = PublishSubject();

    // meetingSteamChangedSubject = PublishSubject<dynamic>();
  }
}
