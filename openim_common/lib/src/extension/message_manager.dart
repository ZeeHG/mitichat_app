import 'dart:convert';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:openim_common/openim_common.dart';

extension MessageManagerExt on MessageManager {
  /// 通话消息；语音/视频通话
  /// [ type ] video/voice
  /// [ state ] 已拒绝/对方已拒绝/已取消/对方已取消/其他
  Future<Message> createCallMessage({
    required String type,
    required String state,
    int? duration,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.call,
          "data": {
            'duration': duration,
            'state': state,
            'type': type,
          },
        }),
        extension: '',
        description: '',
      );

  /// 自定义表情消息
  Future<Message> createCustomEmojiMessage({
    required String url,
    int? width,
    int? height,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.emoji,
          "data": {
            'url': url,
            'width': width,
            'height': height,
          },
        }),
        extension: '',
        description: '',
      );

  /// 根据tag下发通知
  /// 包含语音内容或文字内容
  Future<Message> createTagMessage({
    String? url,
    int? duration,
    String? text,
  }) =>
      createCustomMessage(
        data: json.encode({
          "customType": CustomMessageType.tag,
          "data": {
            'url': url,
            'duration': duration,
            'text': text,
          },
        }),
        extension: '',
        description: '',
      );

  /// 视频会议
  Future<Message> createMeetingMessage({
    required String inviterUserID,
    required String inviterNickname,
    String? inviterFaceURL,
    required String subject,
    required String id,
    required int start,
    required int duration,
  }) =>
      createCustomMessage(
          data: json.encode({
            "customType": CustomMessageType.meeting,
            "data": {
              'inviterUserID': inviterUserID,
              'inviterNickname': inviterNickname,
              'inviterFaceURL': inviterFaceURL,
              'subject': subject,
              'id': id,
              'start': start,
              'duration': duration,
            },
          }),
          extension: '',
          description: '');

  /// 失败提示消息
  Future<Message> createFailedHintMessage({required int type}) => createCustomMessage(
        data: json.encode({
          "customType": type,
          "data": {},
        }),
        extension: '',
        description: '',
      );
}

extension MessageExt on Message {
  /// 引用消息
  Message? get quoteMessage {
    Message? quoteMsg;
    if (contentType == MessageType.quote) {
      quoteMsg = quoteElem?.quoteMessage;
    } else if (contentType == MessageType.atText) {
      quoteMsg = atTextElem?.quoteMessage;
    }
    return quoteMsg;
  }

  /// 群公告消息
  bool get isNoticeType {
    final isGroupNtf = contentType! == MessageType.groupInfoSetAnnouncementNotification;
    if (isGroupNtf) {
      try {
        final map = json.decode(notificationElem!.detail!);
        final ntf = GroupNotification.fromJson(map);
        return IMUtils.isNotNullEmptyStr(ntf.group?.notification);
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  /// 群公告内容
  String? get noticeContent {
    final isGroupNtf = contentType! == MessageType.groupInfoSetAnnouncementNotification;
    if (isGroupNtf) {
      try {
        final map = json.decode(notificationElem!.detail!);
        final ntf = GroupNotification.fromJson(map);
        return ntf.group?.notification;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return null;
  }

  /// 通话消息
  bool get isCallType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.call == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  /// 会议消息
  bool get isMeetingType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.meeting == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  /// 被删好友
  bool get isDeletedByFriendType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.deletedByFriend == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  /// 被拉黑
  bool get isBlockedByFriendType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.blockedByFriend == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  /// 自己定表情
  bool get isEmojiType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.emoji == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  /// 标签
  bool get isTagType {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        return CustomMessageType.tag == customType;
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return false;
  }

  /// 标签内容
  TagNotificationContent? get tagContent {
    if (isCustomType) {
      try {
        var map = json.decode(customElem!.data!);
        var customType = map['customType'];
        if (CustomMessageType.tag == customType) {
          var data = map['data'];
          if (null != data) {
            return TagNotificationContent.fromJson(data);
          }
        }
      } catch (e, s) {
        Logger.print('$e $s');
      }
    }
    return null;
  }

  /// 是否是阅后即焚消息
  bool get isPrivateType => attachedInfoElem?.isPrivateChat == true;

  bool get isTextType => contentType == MessageType.text;

  bool get isAtTextType => contentType == MessageType.atText;

  bool get isPictureType => contentType == MessageType.picture;

  bool get isVoiceType => contentType == MessageType.voice;

  bool get isVideoType => contentType == MessageType.video;

  bool get isFileType => contentType == MessageType.file;

  bool get isLocationType => contentType == MessageType.location;

  bool get isQuoteType => contentType == MessageType.quote;

  bool get isMergerType => contentType == MessageType.merger;

  bool get isCardType => contentType == MessageType.card;

  bool get isCustomFaceType => contentType == MessageType.customFace;

  bool get isCustomType => contentType == MessageType.custom;

  bool get isRevokeType => contentType == MessageType.revokeMessageNotification;

  /// 公告或其他通知以消息类型显示
  bool get isNotificationType => contentType! >= 1000;

  bool get isTagTextType => isCustomType && tagContent?.textElem != null;

  bool get isTagVoiceType => isCustomType && tagContent?.soundElem != null;
}

class CustomMessageType {
  static const call = 901;
  static const emoji = 902;
  static const tag = 903;
  static const moments = 904;
  static const meeting = 905;
  static const blockedByFriend = 910;
  static const deletedByFriend = 911;
  static const removedFromGroup = 912;
  static const groupDisbanded = 913;
}

extension FullUserInfoExt on FullUserInfo {
 UserInfo get simpleUserInfo {
   return UserInfo(
     userID: userID,
     nickname: nickname,
     faceURL: faceURL
   );
 }
}
