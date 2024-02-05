import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:ui';
import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:mime/mime.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti/utils/conversation_util.dart';
import 'package:openim_common/openim_common.dart';
// import 'package:openim_live/openim_live.dart';
import 'package:openim_meeting/openim_meeting.dart';
import 'package:photo_browser/photo_browser.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:rxdart/rxdart.dart' hide Rx;
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:video_compress/video_compress.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import 'package:wechat_camera_picker/wechat_camera_picker.dart';

import '../../core/controller/app_controller.dart';
import '../../core/controller/im_controller.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../contacts/select_contacts/select_contacts_logic.dart';
import '../conversation/conversation_logic.dart';
import 'group_setup/group_member_list/group_member_list_logic.dart';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart'
    as cacheManager;

class ChatLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final appLogic = Get.find<AppController>();
  final conversationLogic = Get.find<ConversationLogic>();
  final cacheLogic = Get.find<CacheController>();
  final downloadLogic = Get.find<DownloadController>();

  final inputCtrl = TextEditingController();
  final focusNode = FocusNode();
  final scrollController = ScrollController();
  final refreshController = RefreshController();
  final browserController = PhotoBrowserController();
  var mediaMessages = <Message>[];
  bool playOnce = false; // 点击的当前视频只能播放一次
  // final clickSubject = PublishSubject<Message>();
  final forceCloseToolbox = PublishSubject<bool>();
  final forceCloseMenuSub = PublishSubject<bool>();
  final sendStatusSub = PublishSubject<MsgStreamEv<bool>>();
  final sendProgressSub = BehaviorSubject<MsgStreamEv<int>>();
  final downloadProgressSub = PublishSubject<MsgStreamEv<double>>();
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final hadTranslateMessageList = <Message>[].obs;
  final showEncryptTips = false.obs;
  late StreamSubscription ccSub;
  late StreamSubscription foregroundChangeSub;
  final appCommonLogic = Get.find<AppCommonLogic>();
  final conversationUtil = Get.find<ConversationUtil>();
  final aiUtil = Get.find<AiUtil>();

  late Rx<ConversationInfo> conversationInfo;
  Message? searchMessage;
  final nickname = ''.obs;
  final faceUrl = ''.obs;
  Timer? typingTimer;
  final typing = false.obs;
  final intervalSendTypingMsg = IntervalDo();
  Message? quoteMsg;
  final messageList = <Message>[].obs;
  final quoteContent = "".obs;
  final multiSelMode = false.obs;
  final multiSelList = <Message>[].obs;
  final atUserNameMappingMap = <String, String>{};
  final atUserInfoMappingMap = <String, UserInfo>{};
  final curMsgAtUser = <String>[];
  var _lastCursorIndex = -1;
  final onlineStatus = false.obs;
  final onlineStatusDesc = ''.obs;
  Timer? onlineStatusTimer;
  final favoriteList = <String>[].obs;
  final scaleFactor = Config.textScaleFactor.obs;
  final background = "".obs;
  final memberUpdateInfoMap = <String, GroupMembersInfo>{};
  final groupMessageReadMembers = <String, List<String>>{};
  final groupMutedStatus = 0.obs;
  final groupMemberRoleLevel = 1.obs;
  final muteEndTime = 0.obs;
  GroupInfo? groupInfo;
  GroupMembersInfo? groupMembersInfo;
  List<GroupMembersInfo> ownerAndAdmin = [];

  // sdk的isNotInGroup不能用
  final isInGroup = true.obs;
  final memberCount = 0.obs;
  final privateMessageList = <Message>[];
  final isInBlacklist = false.obs;
  final _audioPlayer = AudioPlayer();
  final _currentPlayClientMsgID = "".obs;
  final isShowPopMenu = false.obs;

  // final _showMenuCacheMessageList = <Message>[];
  final scrollingCacheMessageList = <Message>[];
  final announcement = ''.obs;
  late StreamSubscription memberAddSub;
  late StreamSubscription memberDelSub;
  late StreamSubscription joinedGroupAddedSub;
  late StreamSubscription joinedGroupDeletedSub;
  late StreamSubscription memberInfoChangedSub;
  late StreamSubscription groupInfoUpdatedSub;
  late StreamSubscription friendInfoChangedSub;
  StreamSubscription? userStatusChangedSub;
  final extraMessageList = <Message>[].obs;

  late StreamSubscription connectionSub;
  final syncStatus = IMSdkStatus.syncEnded.obs;

  // late StreamSubscription signalingMessageSub;

  /// super group
  int? lastMinSeq;
  final showCallingMember = false.obs;
  final participants = <Participant>[].obs;
  late RoomCallingInfo roomCallingInfo;

  /// 同步中收到了新消息
  bool _isReceivedMessageWhenSyncing = false;
  bool _isStartSyncing = false;
  bool _isFirstLoad = false;

  final copyTextMap = <String?, String?>{};
  final revokedTextMessage = <String, String>{};

  String? groupOwnerID;

  MeetingBridge? meetingBridge = PackageBridge.meetingBridge;

  RTCBridge? rtcBridge = PackageBridge.rtcBridge;

  bool get rtcIsBusy =>
      meetingBridge?.hasConnection == true || rtcBridge?.hasConnection == true;

  String? get userID => conversationInfo.value.userID;

  String? get groupID => conversationInfo.value.groupID;

  bool get isSingleChat => null != userID && userID!.trim().isNotEmpty;

  bool get isGroupChat => null != groupID && groupID!.trim().isNotEmpty;

  String get memberStr => isSingleChat ? "" : "";

  bool get isAiSingleChat => isSingleChat && aiUtil.isAi(userID);

  List<Message> get messageListV2 {
    return [
      ...messageList.value,
      ...(disabledChatInput ? extraMessageList.value : [])
    ];
  }

  /// 是当前聊天窗口
  bool isCurrentChat(Message message) {
    var senderId = message.sendID;
    var receiverId = message.recvID;
    var groupId = message.groupID;
    // var sessionType = message.sessionType;
    var isCurSingleChat = message.isSingleChat &&
        isSingleChat &&
        (senderId == userID ||
            // 其他端当前登录用户向uid发送的消息
            senderId == OpenIM.iMManager.userID && receiverId == userID);
    var isCurGroupChat =
        message.isGroupChat && isGroupChat && groupID == groupId;
    return isCurSingleChat || isCurGroupChat;
  }

  void scrollBottom() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(0);
    });
  }

  // Query multimedia messages and prepare for large image browsing.
  void _searchMediaMessage() async {
    final messageList = await OpenIM.iMManager.messageManager
        .searchLocalMessages(
            conversationID: conversationInfo.value.conversationID,
            messageTypeList: [MessageType.picture, MessageType.video],
            count: 100000);
    mediaMessages =
        messageList.searchResultItems?.first.messageList?.reversed.toList() ??
            [];
  }

  @override
  void onReady() async {
    _queryOwnerAndAdmin();
    _checkInBlacklist();
    _isJoinedGroup();
    // _queryMyGroupMemberInfo();
    _readDraftText();
    _queryUserOnlineStatus();
    _resetGroupAtType();
    super.onReady();
  }

  @override
  void onInit() {
    var arguments = Get.arguments;
    conversationInfo = Rx(Get.arguments['conversationInfo']);
    searchMessage = arguments['searchMessage'];
    nickname.value = conversationInfo.value.showName ?? '';
    faceUrl.value = conversationInfo.value.faceURL ?? '';
    _createWaitingAiMessage();
    _clearUnreadCount();
    _initChatConfig();
    _initPlayListener();
    _setSdkSyncDataListener();
    _searchMediaMessage();
    // 获取在线状态
    // _startQueryOnlineStatus();
    // 新增消息监听
    imLogic.onRecvNewMessage = (Message message) {
      // 如果是当前窗口的消息
      if (isCurrentChat(message)) {
        // 对方正在输入消息
        if (message.contentType == MessageType.typing) {
          if (message.typingElem?.msgTips == 'yes') {
            // 对方正在输入
            if (null == typingTimer) {
              typing.value = true;
              typingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
                // 两秒后取消定时器
                typing.value = false;
                typingTimer?.cancel();
                typingTimer = null;
              });
            }
          } else {
            // 对方停止输入
            typing.value = false;
            typingTimer?.cancel();
            typingTimer = null;
          }
        } else {
          if (!messageList.contains(message) &&
              !scrollingCacheMessageList.contains(message)) {
            // 只会自动翻译在线窗口新增消息
            if (isAutoTranslate &&
                showTranslateMenu(message) &&
                null != message.clientMsgID &&
                message.sendID != OpenIM.iMManager.userID) {
              translate(message, useFilter: true);
            }
            _isReceivedMessageWhenSyncing = true;
            _parseAnnouncement(message);
            if (isShowPopMenu.value || scrollController.offset != 0) {
              scrollingCacheMessageList.add(message);
            } else {
              if (message.contentType == MessageType.picture ||
                  message.contentType == MessageType.video) {
                mediaMessages.add(message);
              }
              messageList.add(message);
              scrollBottom();
            }
            // ios 退到后台再次唤醒消息乱序
            // messageList.sort((a, b) {
            //   if (a.sendTime! > b.sendTime!) {
            //     return 1;
            //   } else if (a.sendTime! > b.sendTime!) {
            //     return -1;
            //   } else {
            //     return 0;
            //   }
            // });
          }
        }
      }
    };

    // 已被撤回消息监听（新版本）
    imLogic.onRecvMessageRevoked = (RevokedInfo info) {
      var message = messageList
          .firstWhereOrNull((e) => e.clientMsgID == info.clientMsgID);
      message?.notificationElem = NotificationElem(detail: jsonEncode(info));
      message?.contentType = MessageType.revokeMessageNotification;
      // message?.content = jsonEncode(info);
      // message?.contentType = MessageType.advancedRevoke;
      formatQuoteMessage(info.clientMsgID!);

      if (null != message) {
        messageList.refresh();
      }
    };
    // 消息已读回执监听
    imLogic.onRecvC2CReadReceipt = (List<ReadReceiptInfo> list) {
      try {
        for (var readInfo in list) {
          if (readInfo.userID == userID) {
            for (var e in messageList) {
              if (readInfo.msgIDList?.contains(e.clientMsgID) == true) {
                e.isRead = true;
                e.hasReadTime = _timestamp;
              }
            }
          }
        }
        messageList.refresh();
      } catch (e) {}
    };
    // 消息已读回执监听
    imLogic.onRecvGroupReadReceipt = (GroupMessageReceipt receipt) {
      if (receipt.conversationID == conversationInfo.value.conversationID) {
        for (var element in receipt.groupMessageReadInfo) {
          // enum all message
          final msg = messageList
              .firstWhereOrNull((e) => e.clientMsgID == element.clientMsgID);
          if (msg != null) {
            msg.attachedInfoElem?.groupHasReadInfo?.unreadCount =
                element.unreadCount;
            msg.attachedInfoElem?.groupHasReadInfo?.hasReadCount =
                element.hasReadCount;
          }
        }
        messageList.refresh();
      }
    };
    // 消息发送进度
    imLogic.onMsgSendProgress = (String msgId, int progress) {
      sendProgressSub.addSafely(
        MsgStreamEv<int>(id: msgId, value: progress),
      );
    };

    joinedGroupAddedSub = imLogic.joinedGroupAddedSubject.listen((event) {
      if (event.groupID == groupID) {
        isInGroup.value = true;
        _queryGroupInfo();
      }
    });

    joinedGroupDeletedSub = imLogic.joinedGroupDeletedSubject.listen((event) {
      if (event.groupID == groupID) {
        isInGroup.value = false;
        inputCtrl.clear();
      }
    });

    // 有新成员进入
    memberAddSub = imLogic.memberAddedSubject.listen((info) {
      var groupId = info.groupID;
      if (groupId == groupID) {
        _putMemberInfo([info]);
      }
    });

    memberDelSub = imLogic.memberDeletedSubject.listen((info) {
      if (info.groupID == groupID && info.userID == OpenIM.iMManager.userID) {
        isInGroup.value = false;
        inputCtrl.clear();
      }
    });

    // 成员信息改变
    memberInfoChangedSub = imLogic.memberInfoChangedSubject.listen((info) {
      if (info.groupID == groupID) {
        if (info.userID == OpenIM.iMManager.userID) {
          muteEndTime.value = info.muteEndTime ?? 0;
          groupMemberRoleLevel.value = info.roleLevel ?? GroupRoleLevel.member;
          _mutedClearAllInput();
        }
        _putMemberInfo([info]);

        final index = ownerAndAdmin
            .indexWhere((element) => element.userID == info.userID);
        if (info.roleLevel == GroupRoleLevel.member) {
          ownerAndAdmin.removeAt(index);
        } else if (info.roleLevel == GroupRoleLevel.admin ||
            info.roleLevel == GroupRoleLevel.owner) {
          if (index == -1) {
            ownerAndAdmin.add(info);
          } else {
            ownerAndAdmin[index] = info;
          }
        }
        messageList.refresh();
      }
    });

    // 群信息变化
    groupInfoUpdatedSub = imLogic.groupInfoUpdatedSubject.listen((value) {
      if (groupID == value.groupID) {
        nickname.value = value.groupName ?? '';
        faceUrl.value = value.faceURL ?? '';
        groupMutedStatus.value = value.status ?? 0;
        memberCount.value = value.memberCount ?? 0;
        _mutedClearAllInput();
      }
    });

    // 好友信息变化
    friendInfoChangedSub = imLogic.friendInfoChangedSubject.listen((value) {
      if (userID == value.userID) {
        nickname.value = value.getShowName();
        faceUrl.value = value.faceURL ?? '';
      }
    });
    // 自定义消息点击事件
    // clickSubject.listen((Message message) {
    //   parseClickEvent(message);
    // });

    // 输入框监听
    inputCtrl.addListener(() {
      intervalSendTypingMsg.run(
        fuc: () => sendTypingMsg(focus: true),
        milliseconds: 2000,
      );
      clearCurAtMap();
      _updateDartText(createDraftText());
    });

    // 输入框聚焦
    focusNode.addListener(() {
      _lastCursorIndex = inputCtrl.selection.start;
      focusNodeChanged(focusNode.hasFocus);
    });

    // 通话消息处理
    // imLogic.onSignalingMessage = (value) {
    //   if (value.isSingleChat && value.userID == userID ||
    //       value.isGroupChat && value.groupID == groupID) {
    //     messageList.add(value.message);
    //     scrollBottom();
    //   }
    // };

    imLogic.roomParticipantConnectedSubject.listen((value) {
      if (value.groupID == groupID) {
        roomCallingInfo = value;
        participants.assignAll(value.participant ?? []);
      }
    });
    imLogic.roomParticipantDisconnectedSubject.listen((value) {
      if (value.groupID == groupID) {
        roomCallingInfo = value;
        participants.assignAll(value.participant ?? []);
      }
    });
    // signalingMessageSub = imLogic.signalingMessageSubject.listen((value) {
    //   print('====value.userID:${value.userID}===uid: $uid == gid:$gid');
    //   if (value.isSingleChat && value.userID == uid ||
    //       value.isGroupChat && value.groupID == gid) {
    //     messageList.add(value.message);
    //     scrollBottom();
    //   }
    // });

    // imLogic.conversationChangedSubject.listen((newList) {
    //   for (var newValue in newList) {
    //     if (newValue.conversationID == info?.conversationID) {
    //       burnAfterReading.value = newValue.isPrivateChat!;
    //       break;
    //     }
    //   }
    // });

    ccSub = imLogic.conversationChangedSubject.listen((newList) {
      for (var newValue in newList) {
        if (newValue.conversationID == conversationID) {
          conversationInfo.update((val) {
            val?.burnDuration = newValue.burnDuration ?? 30;
            val?.isPrivateChat = newValue.isPrivateChat;
            val?.isPinned = newValue.isPinned;
            // 免打扰 0：正常；1：不接受消息；2：接受在线消息不接受离线消息；
            val?.recvMsgOpt = newValue.recvMsgOpt;
            val?.isMsgDestruct = newValue.isMsgDestruct;
            val?.msgDestructTime = newValue.msgDestructTime;
          });
          break;
        }
      }
    });

    super.onInit();
  }

  void formatQuoteMessage(String focusClientMsgID) {
    var quotes = messageList
        .where((element) =>
            element.contentType == MessageType.quote &&
            element.quoteMessage?.clientMsgID == focusClientMsgID)
        .toList();
    quotes.forEach((element) {
      element.quoteMessage?.textElem?.content = '';
    });
  }

  void chatSetup() => isSingleChat
      ? AppNavigator.startChatSetup(conversationInfo: conversationInfo.value)
      : AppNavigator.startGroupChatSetup(
          conversationInfo: conversationInfo.value);

  void clearCurAtMap() {
    curMsgAtUser.removeWhere((uid) => !inputCtrl.text.contains('@$uid '));
  }

  /// 记录群成员信息
  void _putMemberInfo(List<GroupMembersInfo>? list) {
    list?.forEach((member) {
      _setAtMapping(
        userID: member.userID!,
        nickname: member.nickname!,
        faceURL: member.faceURL,
      );
      memberUpdateInfoMap[member.userID!] = member;
    });
    // 更新群成员信息
    messageList.refresh();
    atUserNameMappingMap[OpenIM.iMManager.userID] = StrRes.you;
    atUserInfoMappingMap[OpenIM.iMManager.userID] = OpenIM.iMManager.userInfo;

    // DataSp.putAtUserMap(groupID!, atUserNameMappingMap);
  }

  /// 发送文字内容，包含普通内容，引用回复内容，@内容
  void sendTextMsg() async {
    var content = IMUtils.safeTrim(inputCtrl.text);
    if (content.isEmpty) return;
    Message message;
    if (curMsgAtUser.isNotEmpty) {
      createAtInfoByID(id) => AtUserInfo(
            atUserID: id,
            groupNickname: atUserNameMappingMap[id],
          );

      // 发送 @ 消息
      message = await OpenIM.iMManager.messageManager.createTextAtMessage(
        text: content,
        atUserIDList: curMsgAtUser,
        atUserInfoList: curMsgAtUser.map(createAtInfoByID).toList(),
        quoteMessage: quoteMsg,
      );
    } else if (quoteMsg != null) {
      // 发送引用消息
      message = await OpenIM.iMManager.messageManager.createQuoteMessage(
        text: content,
        quoteMsg: quoteMsg!,
      );
    } else {
      // 发送普通消息
      message = await OpenIM.iMManager.messageManager.createTextMessage(
        text: content,
      );
    }
    _sendMessage(message);
  }

  /// 发送图片
  void sendPicture({required String path}) async {
    final file = await IMUtils.compressImageAndGetFile(File(path));

    var message =
        await OpenIM.iMManager.messageManager.createImageMessageFromFullPath(
      imagePath: file!.path,
    );
    _sendMessage(message);
  }

  /// 发送语音
  void sendVoice(int duration, String path) async {
    var message =
        await OpenIM.iMManager.messageManager.createSoundMessageFromFullPath(
      soundPath: path,
      duration: duration,
    );
    _sendMessage(message);
  }

  ///  发送视频
  void sendVideo({
    required String videoPath,
    required String mimeType,
    required int duration,
    required String thumbnailPath,
  }) async {
    // 插件有bug，有些视频长度*1000
    var d = duration > 1000.0 ? duration / 1000.0 : duration;
    var message =
        await OpenIM.iMManager.messageManager.createVideoMessageFromFullPath(
      videoPath: videoPath,
      videoType: mimeType,
      duration: d.toInt(),
      snapshotPath: thumbnailPath,
    );
    _sendMessage(message);
  }

  /// 发送文件
  void sendFile({required String filePath, required String fileName}) async {
    var message =
        await OpenIM.iMManager.messageManager.createFileMessageFromFullPath(
      filePath: filePath,
      fileName: fileName,
    );
    _sendMessage(message);
  }

  /// 发送位置
  void sendLocation({
    required dynamic location,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createLocationMessage(
      latitude: location['latitude'],
      longitude: location['longitude'],
      description: location['description'],
    );
    _sendMessage(message);
  }

  /// 转发内容的备注信息
  sendForwardRemarkMsg(
    String content, {
    String? userId,
    String? groupId,
  }) async {
    final message = await OpenIM.iMManager.messageManager.createTextMessage(
      text: content,
    );
    _sendMessage(message, userId: userId, groupId: groupId);
  }

  /// 转发
  sendForwardMsg(
    Message originalMessage, {
    String? userId,
    String? groupId,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createForwardMessage(
      message: originalMessage,
    );
    _sendMessage(message, userId: userId, groupId: groupId);
  }

  /// 合并转发
  void sendMergeMsg({
    String? userId,
    String? groupId,
  }) async {
    var summaryList = <String>[];
    String title;
    for (var msg in multiSelList) {
      summaryList.add(IMUtils.createSummary(msg));
      if (summaryList.length >= 2) break;
    }
    if (isGroupChat) {
      title = "群聊${StrRes.chatRecord}";
    } else {
      var partner1 = OpenIM.iMManager.userInfo.getShowName();
      var partner2 = nickname.value;
      title = "$partner1和$partner2${StrRes.chatRecord}";
    }
    var message = await OpenIM.iMManager.messageManager.createMergerMessage(
      messageList: multiSelList,
      title: title,
      summaryList: summaryList,
    );
    _sendMessage(message, userId: userId, groupId: groupId);
  }

  /// 提示对方正在输入
  void sendTypingMsg({bool focus = false}) async {
    if (isSingleChat) {
      OpenIM.iMManager.messageManager.typingStatusUpdate(
        userID: userID!,
        msgTip: focus ? 'yes' : 'no',
      );
    }
  }

  /// 发送名片
  void sendCarte({
    required String userID,
    String? nickname,
    String? faceURL,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createCardMessage(
      userID: userID,
      nickname: nickname!,
      faceURL: faceURL,
    );
    _sendMessage(message);
  }

  /// 发送自定义消息
  void sendCustomMsg({
    required String data,
    required String extension,
    required String description,
  }) async {
    var message = await OpenIM.iMManager.messageManager.createCustomMessage(
      data: data,
      extension: extension,
      description: description,
    );
    _sendMessage(message);
  }

  void _sendMessage(
    Message message, {
    String? userId,
    String? groupId,
    bool addToUI = true,
  }) {
    log('send : ${json.encode(message)}');
    userId = IMUtils.emptyStrToNull(userId);
    groupId = IMUtils.emptyStrToNull(groupId);
    if (null == userId && null == groupId ||
        userId == userID && userId != null ||
        groupId == groupID && groupId != null) {
      if (addToUI) {
        // 失败重复不需要添加到ui
        messageList.add(message);
        scrollBottom();
      }
    }
    Logger.print('uid:$userID userId:$userId gid:$groupID groupId:$groupId');
    _reset(message);
    // 借用当前聊天窗口，给其他用户或群发送信息，如合并转发，分享名片。
    bool useOuterValue = null != userId || null != groupId;
    setConversationConfig(waitingST: message.sendTime);
    OpenIM.iMManager.messageManager
        .sendMessage(
          message: message,
          userID: useOuterValue ? userId : userID,
          groupID: useOuterValue ? groupId : groupID,
          offlinePushInfo: Config.offlinePushInfo,
        )
        .then((value) => _sendSucceeded(message, value))
        .catchError((error, _) => _senFailed(message, groupId, error, _))
        .whenComplete(() => _completed());
    if (!mediaMessages.contains(message)) {
      mediaMessages.add(message);
    }
  }

  setConversationConfig({int? waitingST}) {
    if (isAiSingleChat) {
      conversationUtil.updateStore(conversationID, waitingST: waitingST);
    }
  }

  ///  消息发送成功
  void _sendSucceeded(Message oldMsg, Message newMsg) {
    Logger.print('message send success----');
    setConversationConfig(waitingST: newMsg.sendTime);
    // message.status = MessageStatus.succeeded;
    oldMsg.update(newMsg);
    sendStatusSub.addSafely(MsgStreamEv<bool>(
      id: oldMsg.clientMsgID!,
      value: true,
    ));
  }

  ///  消息发送失败
  void _senFailed(Message message, String? groupId, error, stack) async {
    Logger.print('message send failed e :$error  $stack');
    setConversationConfig(waitingST: -1);
    message.status = MessageStatus.failed;
    sendStatusSub.addSafely(MsgStreamEv<bool>(
      id: message.clientMsgID!,
      value: false,
    ));
    if (error is PlatformException) {
      int code = int.tryParse(error.code) ?? 0;
      if (isSingleChat) {
        int? customType;
        if (code == SDKErrorCode.hasBeenBlocked) {
          customType = CustomMessageType.blockedByFriend;
        } else if (code == SDKErrorCode.notFriend) {
          customType = CustomMessageType.deletedByFriend;
        }
        if (null != customType) {
          final hintMessage = (await OpenIM.iMManager.messageManager
              .createFailedHintMessage(type: customType))
            ..status = 2
            ..isRead = true;
          messageList.add(hintMessage);
          OpenIM.iMManager.messageManager.insertSingleMessageToLocalStorage(
            message: hintMessage,
            receiverID: userID,
            senderID: OpenIM.iMManager.userID,
          );
        }
      } else {
        if ((code == SDKErrorCode.userIsNotInGroup ||
                code == SDKErrorCode.groupDisbanded) &&
            null == groupId) {
          final status = groupInfo?.status;
          final hintMessage = (await OpenIM.iMManager.messageManager
              .createFailedHintMessage(
                  type: status == 2
                      ? CustomMessageType.groupDisbanded
                      : CustomMessageType.removedFromGroup))
            ..status = 2
            ..isRead = true;
          messageList.add(hintMessage);
          OpenIM.iMManager.messageManager.insertGroupMessageToLocalStorage(
            message: hintMessage,
            groupID: groupID,
            senderID: OpenIM.iMManager.userID,
          );
        }
      }
    }
  }

  void _reset(Message message) {
    if (message.contentType == MessageType.text ||
        message.contentType == MessageType.atText ||
        message.contentType == MessageType.quote) {
      inputCtrl.clear();
      setQuoteMsg(null);
    }
    closeMultiSelMode();
  }

  /// todo
  void _completed() {
    messageList.refresh();
    // setQuoteMsg(-1);
    // closeMultiSelMode();
    // inputCtrl.clear();
  }

  /// 设置被回复的消息体
  void setQuoteMsg(Message? message) {
    if (message == null) {
      quoteMsg = null;
      quoteContent.value = '';
    } else {
      quoteMsg = message;
      var name = quoteMsg!.senderNickname;
      quoteContent.value = "$name：${IMUtils.parseMsg(quoteMsg!)}";
      focusNode.requestFocus();
    }
  }

  /// 删除消息
  void deleteMsg(Message message) async {
    LoadingView.singleton.wrap(asyncFunction: () => _deleteMessage(message));
  }

  /// 批量删除
  void _deleteMultiMsg() async {
    await LoadingView.singleton.wrap(asyncFunction: () async {
      for (var e in multiSelList) {
        await _deleteMessage(e);
      }
    });
    closeMultiSelMode();
  }

  _deleteMessage(Message message) async {
    try {
      await OpenIM.iMManager.messageManager
          .deleteMessageFromLocalAndSvr(
            conversationID: conversationInfo.value.conversationID,
            clientMsgID: message.clientMsgID!,
          )
          .then((value) => privateMessageList.remove(message))
          .then((value) => messageList.remove(message))
          .then((value) => mediaMessages.removeWhere((element) =>
              element.clientMsgID == message.clientMsgID &&
              (message.contentType == MessageType.video ||
                  message.contentType == MessageType.picture)));
    } catch (e) {
      await OpenIM.iMManager.messageManager
          .deleteMessageFromLocalStorage(
            conversationID: conversationInfo.value.conversationID,
            clientMsgID: message.clientMsgID!,
          )
          .then((value) => privateMessageList.remove(message))
          .then((value) => messageList.remove(message));
    }
  }

  /// 合并转发
  // void mergeForward() async {
  //   final result = await AppNavigator.startSelectContacts(
  //     action: SelAction.forward,
  //     ex: sprintf(StrRes.mergeForwardHint, [multiSelList.length]),
  //   );
  //   if (null != result) {
  //     final customEx = result['customEx'];
  //     final checkedList = result['checkedList'];
  //     for (var info in checkedList) {
  //       final userID = IMUtils.convertCheckedToUserID(info);
  //       final groupID = IMUtils.convertCheckedToGroupID(info);
  //       if (customEx is String && customEx.isNotEmpty) {
  //         sendForwardRemarkMsg(customEx, userId: userID, groupId: groupID);
  //       }
  //       sendMergeMsg(userId: userID, groupId: groupID);
  //     }
  //   }
  // }

  /// 转发
  void forward(Message? message) async {
    final result = await AppNavigator.startSelectContacts(
      action: SelAction.forward,
      ex: null != message
          ? IMUtils.parseMsg(message)
          : sprintf(StrRes.mergeForwardHint, [multiSelList.length]),
    );
    if (null != result) {
      final customEx = result['customEx'];
      final checkedList = result['checkedList'];
      for (var info in checkedList) {
        final userID = IMUtils.convertCheckedToUserID(info);
        final groupID = IMUtils.convertCheckedToGroupID(info);
        if (customEx is String && customEx.isNotEmpty) {
          sendForwardRemarkMsg(customEx, userId: userID, groupId: groupID);
        }
        if (null != message) {
          sendForwardMsg(message, userId: userID, groupId: groupID);
        } else {
          sendMergeMsg(userId: userID, groupId: groupID);
        }
      }
    }
  }

  /// 大于1000为通知类消息
  /// 语音消息必须点击才能视为已读
  void markMessageAsRead(Message message, bool visible) async {
    if (visible &&
        message.contentType! < 1000 &&
        message.contentType! != MessageType.voice) {
      var data = IMUtils.parseCustomMessage(message);
      if (null != data && data['viewType'] == CustomMessageType.call) {
        return;
      }
      _markMessageAsRead(message);
    }
  }

  /// 标记消息为已读
  _markMessageAsRead(Message message) async {
    Logger.print('mark as read：${message.clientMsgID!} ${message.isRead}');
    if (!message.isRead! && message.sendID != OpenIM.iMManager.userID) {
      Logger.print('mark as read：${message.clientMsgID!} ${message.isRead}');
      // 多端同步问题
      try {
        if (isGroupChat) {
          await OpenIM.iMManager.messageManager.sendGroupMessageReadReceipt(
              conversationInfo.value.conversationID, [message.clientMsgID!]);
        } else {
          await OpenIM.iMManager.conversationManager
              .markConversationMessageAsRead(
                  conversationID: conversationInfo.value.conversationID);
        }
      } catch (_) {}
      message.isRead = true;
      message.hasReadTime = _timestamp;
      messageList.refresh();
      // message.attachedInfoElem!.hasReadTime = _timestamp;
    }
  }

  _clearUnreadCount() {
    if (conversationInfo.value.unreadCount > 0) {
      OpenIM.iMManager.conversationManager.markConversationMessageAsRead(
          conversationID: conversationInfo.value.conversationID);
    }
  }

  /// 多选删除
  void mergeDelete() => _deleteMultiMsg();

  void onTapAutoTranslate() {
    translateLogic.setTargetLangAndAutoTranslate(conversationInfo.value);
  }

  void multiSelMsg(Message message, bool checked) {
    if (checked) {
      // 合并最多20条限制
      if (multiSelList.length >= 20) {
        Get.dialog(CustomDialog(title: StrRes.forwardMaxCountHint));
      } else {
        multiSelList.add(message);
        multiSelList.sort((a, b) {
          if (a.createTime! > b.createTime!) {
            return 1;
          } else if (a.createTime! < b.createTime!) {
            return -1;
          } else {
            return 0;
          }
        });
      }
    } else {
      multiSelList.remove(message);
    }
  }

  void openMultiSelMode(Message message) {
    multiSelMode.value = true;
    multiSelMsg(message, true);
  }

  void closeMultiSelMode() {
    multiSelMode.value = false;
    multiSelList.clear();
  }

  /// 触摸其他地方强制关闭工具箱
  void closeToolbox() {
    forceCloseToolbox.addSafely(true);
  }

  /// 打开地图
  void onTapLocation() async {
    var location = await Get.to(
      const ChatWebViewMap(mapAppKey: Config.mapKey),
      transition: Transition.cupertino,
      popGesture: true,
    );
    if (null != location) {
      Logger.print(location);
      sendLocation(location: location);
    }
  }

  /// 打开相册
  void onTapAlbum() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(Get.context!,
        pickerConfig:
            AssetPickerConfig(selectPredicate: (_, entity, isSelected) {
      // 视频限制5分钟的时长
      if (entity.videoDuration > const Duration(seconds: 5 * 60)) {
        IMViews.showToast(
            sprintf(StrRes.selectVideoLimit, [5]) + StrRes.minute);
        return false;
      }
      return true;
    }));
    if (null != assets) {
      for (var asset in assets) {
        _handleAssets(asset);
      }
    }
  }

  void onTapSearch() => AppNavigator.startSearchChatHistory(
        conversationInfo: conversationInfo.value,
      );

  /// 打开相机
  void onTapCamera() async {
    final AssetEntity? entity = await CameraPicker.pickFromCamera(
      Get.context!,
      locale: Get.locale,
      pickerConfig: CameraPickerConfig(
        enableAudio: true,
        enableRecording: true,
        enableScaledPreview: false,
        resolutionPreset: ResolutionPreset.medium,
        maximumRecordingDuration: 60.seconds,
        onMinimumRecordDurationNotMet: () {
          IMViews.showToast(StrRes.tapTooShort);
        },
      ),
    );
    _handleAssets(entity);
  }

  /// 打开系统文件浏览器
  void onTapFile() async {
    await FilePicker.platform.clearTemporaryFiles();
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      // type: FileType.custom,
      // allowedExtensions: ['jpg', 'pdf', 'doc'],
    );

    if (result != null) {
      for (var file in result.files) {
        // String? mimeType = IMUtils.getMediaType(file.name);
        String? mimeType = lookupMimeType(file.name);
        if (mimeType != null) {
          if (mimeType.contains('image/')) {
            sendPicture(path: file.path!);
            continue;
          } else if (mimeType.contains('video/')) {
            try {
              final videoPath = file.path!;
              final mediaInfo = await VideoCompress.getMediaInfo(videoPath);
              var thumbnailFile = await VideoCompress.getFileThumbnail(
                videoPath,
                quality: 60,
              );
              sendVideo(
                videoPath: videoPath,
                mimeType: mimeType,
                duration: mediaInfo.duration!.toInt(),
                thumbnailPath: thumbnailFile.path,
              );
              continue;
            } catch (e, s) {
              Logger.print('e :$e  s:$s');
            }
          }
        }
        sendFile(filePath: file.path!, fileName: file.name);
      }
    } else {
      // User canceled the picker
    }
  }

  /// 名片
  void onTapCarte() async {
    var result = await AppNavigator.startSelectContacts(
      action: SelAction.carte,
    );
    if (result is UserInfo || result is FriendInfo) {
      sendCarte(
        userID: result.userID!,
        nickname: result.nickname,
        faceURL: result.faceURL,
      );
    }
  }

  void _handleAssets(AssetEntity? asset) async {
    if (null != asset) {
      Logger.print('--------assets type-----${asset.type}');
      var path = (await asset.file)!.path;
      Logger.print('--------assets path-----$path');
      switch (asset.type) {
        case AssetType.image:
          sendPicture(path: path);
          break;
        case AssetType.video:
          var thumbnailFile = await IMUtils.getVideoThumbnail(File(path));
          LoadingView.singleton.show();
          final file = await IMUtils.compressVideoAndGetFile(File(path));
          LoadingView.singleton.dismiss();

          sendVideo(
            videoPath: file!.path,
            mimeType: asset.mimeType ?? IMUtils.getMediaType(path) ?? '',
            duration: asset.duration,
            // duration: mediaInfo.duration?.toInt() ?? 0,
            thumbnailPath: thumbnailFile.path,
          );
          // sendVoice(duration: asset.duration, path: path);
          break;
        default:
          break;
      }
    }
  }

  /// 处理消息点击事件
  void parseClickEvent(Message msg) async {
    log('parseClickEvent:${jsonEncode(msg)}');
    if (msg.contentType == MessageType.custom) {
      var data = msg.customElem!.data;
      var map = json.decode(data!);
      var customType = map['customType'];
      if (CustomMessageType.call == customType && !isInBlacklist.value) {
        // if (rtcIsBusy) {
        //   IMViews.showToast(StrRes.callingBusy);
        //   return;
        // }
        // var type = map['data']['type'];
        // imLogic.call(
        //   callObj: CallObj.single,
        //   callType: type == "audio" ? CallType.audio : CallType.video,
        //   inviteeUserIDList: [if (isSingleChat) userID!],
        // );
      } else if (CustomMessageType.meeting == customType) {
        if (rtcIsBusy) {
          IMViews.showToast(StrRes.callingBusy);
          return;
        }
        var data = msg.customElem!.data;
        var map = json.decode(data!);
        MeetingClient().join(Get.context!, meetingID: map['data']['id']);
      } else if (CustomMessageType.tag == customType) {
        final data = map['data'];
        if (null != data['soundElem']) {
          final soundElem = SoundElem.fromJson(data['soundElem']);
          msg.soundElem = soundElem;
          _playVoiceMessage(msg);
        }
      }
      return;
    }
    if (msg.contentType == MessageType.voice) {
      _playVoiceMessage(msg);
      // 收听则为已读
      _markMessageAsRead(msg);
      return;
    }
    if (msg.contentType == MessageType.groupInfoSetAnnouncementNotification) {
      AppNavigator.startEditGroupAnnouncement(
        groupID: groupInfo!.groupID,
      );
      return;
    }

    IMUtils.parseClickEvent(
      msg,
      messageList: messageList,
      onViewUserInfo: viewUserInfo,
    );
  }

  /// 点击引用消息
  void onTapQuoteMsg(Message message) {
    // if (message.contentType == MessageType.quote) {
    //   parseClickEvent(message.quoteElem!.quoteMessage!);
    // } else if (message.contentType == MessageType.atText) {
    //   parseClickEvent(message.atElem!.quoteMessage!);
    // }
    parseClickEvent(message);
  }

  /// 群聊天长按头像为@用户
  void onLongPressLeftAvatar(Message message) {
    if (isMuted || isInvalidGroup) return;
    if (isGroupChat) {
      // 不查询群成员列表
      _setAtMapping(
        userID: message.sendID!,
        nickname: message.senderNickname!,
        faceURL: message.senderFaceUrl,
      );
      var uid = message.sendID!;
      // var uname = msg.sendernickName;
      if (curMsgAtUser.contains(uid)) return;
      curMsgAtUser.add(uid);
      // 在光标出插入内容
      // 先保存光标前和后内容
      var cursor = inputCtrl.selection.base.offset;
      if (!focusNode.hasFocus) {
        focusNode.requestFocus();
        cursor = _lastCursorIndex;
      }
      if (cursor < 0) cursor = 0;
      // 光标前面的内容
      var start = inputCtrl.text.substring(0, cursor);
      // 光标后面的内容
      var end = inputCtrl.text.substring(cursor);
      var at = '@$uid ';
      inputCtrl.text = '$start$at$end';
      Logger.print('start:$start end:$end  at:$at  content:${inputCtrl.text}');
      inputCtrl.selection = TextSelection.collapsed(offset: '$start$at'.length);
      // inputCtrl.selection = TextSelection.fromPosition(TextPosition(
      //   offset: '$start$at'.length,
      // ));
      _lastCursorIndex = inputCtrl.selection.start;
    }
  }

  void onTapLeftAvatar(Message message) {
    viewUserInfo(UserInfo()
      ..userID = message.sendID
      ..nickname = message.senderNickname
      ..faceURL = message.senderFaceUrl);
  }

  void onTapRightAvatar() {
    viewUserInfo(OpenIM.iMManager.userInfo);
  }

  void clickAtText(id) async {
    var tag = await OpenIM.iMManager.conversationManager.getAtAllTag();
    if (id == tag) return;
    if (null != atUserInfoMappingMap[id]) {
      viewUserInfo(atUserInfoMappingMap[id]!);
    } else {
      viewUserInfo(UserInfo(userID: id));
    }
  }

  void viewUserInfo(UserInfo userInfo) {
    AppNavigator.startUserProfilePane(
      userID: userInfo.userID!,
      nickname: userInfo.nickname,
      faceURL: userInfo.faceURL,
      groupID: groupID,
      offAllWhenDelFriend: isSingleChat,
    );
  }

  void clickLinkText(url, type) async {
    Logger.print('--------link  type:$type-------url: $url---');
    if (type == PatternType.at) {
      clickAtText(url);
      return;
    }
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    }
    // await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';
  }

  /// 读取草稿
  void _readDraftText() {
    var draftText = Get.arguments['draftText'];
    Logger.print('readDraftText:$draftText');
    if (null != draftText && "" != draftText) {
      var map = json.decode(draftText!);
      String text = map['text'];
      Map<String, dynamic> atMap = map['at'];
      Logger.print('text:$text  atMap:$atMap');
      atMap.forEach((key, value) {
        if (!curMsgAtUser.contains(key)) curMsgAtUser.add(key);
        atUserNameMappingMap.putIfAbsent(key, () => value);
      });
      inputCtrl.text = text;
      inputCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: text.length,
      ));
      if (text.isNotEmpty) {
        focusNode.requestFocus();
      }
    }
  }

  /// 生成草稿draftText
  String createDraftText() {
    var atMap = <String, dynamic>{};
    for (var uid in curMsgAtUser) {
      atMap[uid] = atUserNameMappingMap[uid];
    }
    if (inputCtrl.text.isEmpty) {
      return "";
    }
    return json.encode({'text': inputCtrl.text, 'at': atMap});
  }

  /// 退出界面前处理
  exit() async {
    if (multiSelMode.value) {
      closeMultiSelMode();
      return false;
    }
    if (isShowPopMenu.value) {
      forceCloseMenuSub.add(true);
      return false;
    }
    Get.back(result: createDraftText());
    return true;
  }

  void _updateDartText(String text) {
    conversationLogic.updateDartText(
      text: text,
      conversationID: conversationInfo.value.conversationID,
    );
  }

  void focusNodeChanged(bool hasFocus) {
    sendTypingMsg(focus: hasFocus);
    if (hasFocus) {
      Logger.print('focus:$hasFocus');
      scrollBottom();
    }
  }

  void copy(Message message) {
    String? content;
    final textElem = message.tagContent?.textElem;
    if (null != textElem) {
      content = textElem.content;
    } else {
      content = copyTextMap[message.clientMsgID] ?? message.textElem?.content;
    }
    if (null != content) {
      IMUtils.copy(text: content);
    } else {
      myLogger.e({"message": "复制message内容, 默认方式解析content失败, 使用自定义解析"});
      if (message.isTextType) {
        content = message.textElem!.content!;
      } else if (message.isAtTextType) {
        content = IMUtils.replaceMessageAtMapping(message, {});
      } else if (message.isQuoteType) {
        content = message.quoteElem?.text;
      }
      if (null != content) {
        IMUtils.copy(text: content);
      } else {
        IMViews.showToast(StrRes.copyFail);
      }
    }
  }

  Future<List<Message>> findTranslate(List<Message> messages) async {
    final result = await Apis.findTranslate(
        ClientMsgIDs: messages.map((e) => e.clientMsgID!).toList(),
        TargetLang: targetLang);
    List<Message> unFindTranslateMessages = [];
    if (null != result["translationResult"]) {
      messages.forEach((message) {
        final target = result["translationResult"].firstWhere(
            (item) => item["clientMsgID"] == message.clientMsgID,
            orElse: () => null);
        if (null != target) {
          String? origin =
              copyTextMap[message.clientMsgID] ?? message.textElem?.content;
          updateMsgTranslate(
              targetLang: targetLang,
              message: message,
              origin: origin ?? "",
              clientMsgID: message.clientMsgID!,
              content: target["transContent"],
              status: "show");
        } else {
          unFindTranslateMessages.add(message);
        }
      });
    } else {
      return messages;
    }
    return unFindTranslateMessages;
  }

  bool get isAutoTranslate {
    final langConfig = translateLogic.langConfig[conversationID];
    final autoTranslate =
        (null == langConfig || null == langConfig["autoTranslate"])
            ? false
            : langConfig["autoTranslate"];
    return autoTranslate;
  }

  get targetLang {
    final langConfig = translateLogic.langConfig[conversationID];
    final targetLang = (null == langConfig || null == langConfig["targetLang"])
        ? window.locale.toString()
        : langConfig["targetLang"];
    return targetLang;
  }

  bool isDigitOrUrl(String input) {
    // 正则表达式，匹配 URL 或域名
    RegExp regExpUrl = RegExp(
        r"(https?:\/\/)?([\da-z\.-]+)\.([a-z\.]{2,6})([\/\w \.-]*)*\/?$");

    // 正则表达式，匹配纯数字
    RegExp regExpDigit = RegExp(r"^\d+$");

    // 表情包
    RegExp regExpEmoji = RegExp(
      r'^([\u{1F600}-\u{1F64F}]\u{FE0F}?)*$',
      unicode: true,
    );

    // 检查是否匹配 URL / 域名 或全部是数字, 表情
    return regExpUrl.hasMatch(input) ||
        regExpDigit.hasMatch(input) ||
        regExpEmoji.hasMatch(input);
  }

  void translate(Message message, {bool useFilter = false}) async {
    final translateCache =
        translateLogic.msgTranslate[message.clientMsgID]?[targetLang];
    if (null != translateCache) {
      translateLogic.updateMsgAllTranslate(message, {"status": "show"});
      return;
    }
    // String? origin =
    //     copyTextMap[message.clientMsgID] ?? message.textElem?.content;
    String? origin;
    if (message.isTextType) {
      origin = message.textElem!.content;
    } else if (message.isAtTextType) {
      origin = IMUtils.replaceMessageAtMapping(message, {});
    } else if (message.isQuoteType) {
      origin = message.quoteElem?.text;
    }
    if (useFilter && null != origin) {
      if (isDigitOrUrl(origin)) return;
    }
    if (null != origin) {
      // if (detectLangIsTarget(origin, targetLang)) return;
      try {
        translateLogic.updateMsgAllTranslate(message, {"status": "loading"});
        final result = await Apis.translate(
            userID: userID!,
            ClientMsgID: message.clientMsgID!,
            Query: origin,
            TargetLang: targetLang);
        updateMsgTranslate(
            message: message,
            targetLang: targetLang,
            origin: origin,
            clientMsgID: message.clientMsgID!,
            content: result["content"],
            status: "show");
      } catch (e) {
        translateLogic.updateMsgAllTranslate(message, {"status": "fail"});
      }
    } else {
      myLogger.e({
        "message": "翻译message, 获取不到原文",
        "error": {
          "message": json.encode(message),
          "messageCopyTextMap": copyTextMap[message.clientMsgID]
        }
      });
      IMViews.showToast(StrRes.noWorking);
    }
  }

  void unTranslate(Message message) {
    translateLogic.updateMsgAllTranslate(message, {"status": "hide"});
  }

  void tts(Message message) async {
    final ttsCache = ttsLogic.msgTts[message.clientMsgID]?["ttsText"];
    if (null != ttsCache) {
      ttsLogic.updateMsgAllTts(message, {"status": "show"});
      return;
    }
    String? origin = message.soundElem?.sourceUrl;
    if (null != origin) {
      try {
        ttsLogic.updateMsgAllTts(message, {"status": "loading"});
        final result = await Apis.tts(url: origin);
        updateMsgTts(
            message: message,
            origin: origin,
            clientMsgID: message.clientMsgID!,
            ttsText: result["content"],
            status: "show");
      } catch (e) {
        ttsLogic.updateMsgAllTts(message, {"status": "fail"});
      }
    } else {
      myLogger.e({
        "message": "文本转语音message, 获取不到音频",
        "error": {"message": json.encode(message)}
      });
      IMViews.showToast(StrRes.noWorking);
    }
  }

  void unTts(Message message) {
    ttsLogic.updateMsgAllTts(message, {"status": "hide"});
  }

  updateMsgTranslate(
      {required Message message,
      required String targetLang,
      required String content,
      required String origin,
      required String clientMsgID,
      required String status}) {
    translateLogic.updateMsgAllTranslate(message, {
      "targetLang": targetLang,
      targetLang: content,
      "origin": origin,
      "clientMsgID": clientMsgID,
      "status": status
    });
  }

  updateMsgTts(
      {required Message message,
      required String origin,
      required String ttsText,
      required String clientMsgID,
      required String status}) {
    ttsLogic.updateMsgAllTts(message, {
      "ttsText": ttsText,
      "origin": origin,
      "clientMsgID": clientMsgID,
      "status": status
    });
  }

  bool get isBurnAfterReading => conversationInfo.value.isPrivateChat == true;
  String get conversationID => conversationInfo.value.conversationID;

  /// 阅后即焚
  void toggleBurnAfterReading() {
    LoadingView.singleton.wrap(asyncFunction: () async {
      await OpenIM.iMManager.conversationManager.setConversationPrivateChat(
        conversationID: conversationID,
        isPrivate: !isBurnAfterReading,
      );
    });
  }

  Message indexOfMessage(int index, {bool calculate = true}) =>
      IMUtils.calChatTimeInterval(
        messageListV2,
        calculate: calculate,
      ).reversed.elementAt(index);

  ValueKey itemKey(Message message) => ValueKey(message.clientMsgID!);

  @override
  void onClose() {
    _clearUnreadCount();
    // ChatGetTags.caches.removeLast();
    _unSubscribeUserOnlineStatus();
    inputCtrl.dispose();
    focusNode.dispose();
    _audioPlayer.dispose();
    // clickSubject.close();
    forceCloseToolbox.close();
    sendStatusSub.close();
    sendProgressSub.close();
    downloadProgressSub.close();
    memberAddSub.cancel();
    memberDelSub.cancel();
    memberInfoChangedSub.cancel();
    groupInfoUpdatedSub.cancel();
    friendInfoChangedSub.cancel();
    userStatusChangedSub?.cancel();
    foregroundChangeSub?.cancel();
    // signalingMessageSub?.cancel();
    forceCloseMenuSub.close();
    joinedGroupAddedSub.cancel();
    joinedGroupDeletedSub.cancel();
    connectionSub.cancel();
    // onlineStatusTimer?.cancel();
    // destroyMsg();
    super.onClose();
  }

  String? getShowTime(Message message) {
    if (message.exMap['showTime'] == true && !message.isWaitingAiReplayType) {
      return IMUtils.getChatTimeline(message.sendTime!);
    }
    return null;
  }

  void clearAllMessage() {
    messageList.clear();
  }

  void onStartVoiceInput() {
    // SpeechToTextUtil.instance.startListening((result) {
    //   inputCtrl.text = result.recognizedWords;
    // });
  }

  void onStopVoiceInput() {
    // SpeechToTextUtil.instance.stopListening();
  }

  /// 添加表情
  void onAddEmoji(String emoji) {
    var input = inputCtrl.text;
    if (_lastCursorIndex != -1 && input.isNotEmpty) {
      var part1 = input.substring(0, _lastCursorIndex);
      var part2 = input.substring(_lastCursorIndex);
      inputCtrl.text = '$part1$emoji$part2';
      _lastCursorIndex = _lastCursorIndex + emoji.length;
    } else {
      inputCtrl.text = '$input$emoji';
      _lastCursorIndex = emoji.length;
    }
    inputCtrl.selection = TextSelection.fromPosition(TextPosition(
      offset: _lastCursorIndex,
    ));
  }

  /// 删除表情
  void onDeleteEmoji() {
    final input = inputCtrl.text;
    final regexEmoji = emojiFaces.keys
        .toList()
        .join('|')
        .replaceAll('[', '\\[')
        .replaceAll(']', '\\]');
    final list = [regexAt, regexEmoji];
    final pattern = '(${list.toList().join('|')})';
    final atReg = RegExp(regexAt);
    final emojiReg = RegExp(regexEmoji);
    var reg = RegExp(pattern);
    var cursor = _lastCursorIndex;
    if (cursor == 0) return;
    Match? match;
    if (reg.hasMatch(input)) {
      for (var m in reg.allMatches(input)) {
        var matchText = m.group(0)!;
        var start = m.start;
        var end = start + matchText.length;
        if (end == cursor) {
          match = m;
          break;
        }
      }
    }
    var matchText = match?.group(0);
    if (matchText != null) {
      var start = match!.start;
      var end = start + matchText.length;
      if (atReg.hasMatch(matchText)) {
        String id = matchText.replaceFirst("@", "").trim();
        if (curMsgAtUser.remove(id)) {
          inputCtrl.text = input.replaceRange(start, end, '');
          cursor = start;
        } else {
          inputCtrl.text = input.replaceRange(cursor - 1, cursor, '');
          --cursor;
        }
      } else if (emojiReg.hasMatch(matchText)) {
        inputCtrl.text = input.replaceRange(start, end, "");
        cursor = start;
      } else {
        inputCtrl.text = input.replaceRange(cursor - 1, cursor, '');
        --cursor;
      }
    } else {
      inputCtrl.text = input.replaceRange(cursor - 1, cursor, '');
      --cursor;
    }
    _lastCursorIndex = cursor;
  }

  // String getSubTile() => typing.value ? StrRes.typing : onlineStatusDesc.value;
  String? get subTile => typing.value ? StrRes.typing : onlineStatusDesc.value;

  bool showOnlineStatus() => !typing.value && onlineStatusDesc.isNotEmpty;

  /// 语音视频通话信息不显示读状态
  bool enabledReadStatus(Message message) {
    if (message.isNotificationType || message.isCallType) {
      return false;
    }
    return true;
  }

  /// 处理输入框输入@字符
  String? openAtList() {
    if (groupInfo != null) {
      var cursor = inputCtrl.selection.baseOffset;
      AppNavigator.startGroupMemberList(
        groupInfo: groupInfo!,
        opType: GroupMemberOpType.at,
      )?.then((list) => _handleAtMemberList(list, cursor));
      return "@";
    }
    return null;
  }

  _handleAtMemberList(memberList, cursor) {
    if (memberList is List<GroupMembersInfo>) {
      var buffer = StringBuffer();
      for (var e in memberList) {
        _setAtMapping(
          userID: e.userID!,
          nickname: e.nickname ?? '',
          faceURL: e.faceURL,
        );
        if (!curMsgAtUser.contains(e.userID)) {
          curMsgAtUser.add(e.userID!);
          buffer.write('@${e.userID} ');
        }
      }
      if (cursor < 0) cursor = 0;
      // 光标前面的内容
      var start = inputCtrl.text.substring(0, cursor);
      // 光标后面的内容
      var end = inputCtrl.text.substring(cursor + 1);
      inputCtrl.text = '$start$buffer$end';
      inputCtrl.selection = TextSelection.fromPosition(TextPosition(
        offset: '$start$buffer'.length,
      ));
      _lastCursorIndex = inputCtrl.selection.start;
    } else {}
  }

  void favoriteManage() => AppNavigator.startFavoriteMange();

  void addEmoji(Message message) {
    if (message.contentType == MessageType.picture) {
      var url = message.pictureElem?.sourcePicture?.url;
      var width = message.pictureElem?.sourcePicture?.width;
      var height = message.pictureElem?.sourcePicture?.height;
      cacheLogic.addFavoriteFromUrl(url, width, height);
      IMViews.showToast(StrRes.addSuccessfully);
    } else if (message.contentType == MessageType.customFace) {
      var index = message.faceElem?.index;
      var data = message.faceElem?.data;
      if (-1 != index) {
      } else if (null != data) {
        var map = json.decode(data);
        var url = map['url'];
        var width = map['width'];
        var height = map['height'];
        cacheLogic.addFavoriteFromUrl(url, width, height);
        IMViews.showToast(StrRes.addSuccessfully);
      }
    }
  }

  /// 发送自定表情
  void sendFavoritePic(int index, String url) async {
    var emoji = cacheLogic.favoriteList.elementAt(index);
    var message = await OpenIM.iMManager.messageManager.createFaceMessage(
      data: json.encode(
          {'url': emoji.url, 'width': emoji.width, 'height': emoji.height}),
    );
    _sendMessage(message);
  }

  void _initChatConfig() async {
    scaleFactor.value = DataSp.getChatFontSizeFactor();
    var path = DataSp.getChatBackground(otherId) ?? '';
    if (path.isNotEmpty && (await File(path).exists())) {
      background.value = path;
    }
  }

  /// 修改聊天字体
  changeFontSize(double factor) async {
    await DataSp.putChatFontSizeFactor(factor);
    scaleFactor.value = factor;
    IMViews.showToast(StrRes.setSuccessfully);
  }

  /// 修改聊天背景
  changeBackground(String path) async {
    await DataSp.putChatBackground(otherId, path);
    background.value = path;
    IMViews.showToast(StrRes.setSuccessfully);
  }

  String get otherId => isSingleChat ? userID! : groupID!;

  /// 清除聊天背景
  clearBackground() async {
    await DataSp.clearChatBackground(otherId);
    background.value = '';
    IMViews.showToast(StrRes.setSuccessfully);
  }

  /// 拨视频或音频
  void call() async {
    if (rtcIsBusy) {
      IMViews.showToast(StrRes.callingBusy);
      return;
    }
    if (isGroupChat) {
      if (participants.isNotEmpty) {
        var confirm = await Get.dialog(CustomDialog(
          title: StrRes.groupCallHint,
          rightText: StrRes.joinIn,
        ));
        if (confirm == true) {
          joinGroupCalling();
        }
        return;
      }
      IMViews.openIMGroupCallSheet(groupID!, (index) async {
        if (null != groupInfo) {
          final list = await AppNavigator.startGroupMemberList(
            groupInfo: groupInfo!,
            opType: GroupMemberOpType.call,
          );
          // if (list is List<GroupMembersInfo>) {
          //   final uidList = list.map((e) => e.userID!).toList();
          //   imLogic.call(
          //     callObj: CallObj.group,
          //     callType: index == 0 ? CallType.audio : CallType.video,
          //     groupID: groupID,
          //     inviteeUserIDList: uidList,
          //   );
          // }
        }
      });
    } else {
      IMViews.openIMCallSheet(nickname.value, (index) {
        // imLogic.call(
        //   callObj: CallObj.single,
        //   callType: index == 0 ? CallType.audio : CallType.video,
        //   inviteeUserIDList: [if (isSingleChat) userID!],
        // );
      });
    }
  }

  /// 群消息已读预览
  void viewGroupMessageReadStatus(Message message) {
    AppNavigator.startGroupReadList(
      conversationInfo.value.conversationID,
      message.clientMsgID!,
    );
  }

  /// 失败重发
  void failedResend(Message message) {
    sendStatusSub.addSafely(MsgStreamEv<bool>(
      id: message.clientMsgID!,
      value: true,
    ));
    _sendMessage(message..status = MessageStatus.sending, addToUI: false);
  }

  /// 计算这条消息应该被阅读的人数
  // int getNeedReadCount(Message message) {
  //   if (isSingleChat) return 0;
  //   return groupMessageReadMembers[message.clientMsgID!]?.length ??
  //       _calNeedReadCount(message);
  // }

  /// 1，排除自己
  /// 2，获取比消息发送时间早的入群成员数
  // int _calNeedReadCount(Message message) {
  //   memberList.values.forEach((element) {
  //     if (element.userID != OpenIM.iMManager.uid) {
  //       if ((element.joinTime! * 1000) < message.sendTime!) {
  //         var list = groupMessageReadMembers[message.clientMsgID!] ?? [];
  //         if (!list.contains(element.userID)) {
  //           groupMessageReadMembers[message.clientMsgID!] = list
  //             ..add(element.userID!);
  //         }
  //       }
  //     }
  //   });
  //   return groupMessageReadMembers[message.clientMsgID!]?.length ?? 0;
  // }

  int readTime(Message message) {
    var isPrivate = message.attachedInfoElem?.isPrivateChat ?? false;
    var burnDuration = message.attachedInfoElem?.burnDuration ?? 30;
    if (isPrivate) {
      privateMessageList.addIf(
          () => !privateMessageList.contains(message), message);
      // var hasReadTime = message.attachedInfoElem!.hasReadTime ?? 0;
      var hasReadTime = message.hasReadTime ?? 0;
      if (hasReadTime > 0) {
        var end = hasReadTime + (burnDuration * 1000);

        var diff = (end - _timestamp) ~/ 1000;
        return diff < 0 ? 0 : diff;
      }
    }
    return 0;
  }

  static int get _timestamp => DateTime.now().millisecondsSinceEpoch;

  /// 退出页面即把所有当前已展示的私聊消息删除
  void destroyMsg() {
    for (var message in privateMessageList) {
      OpenIM.iMManager.messageManager.deleteMessageFromLocalAndSvr(
        conversationID: conversationInfo.value.conversationID,
        clientMsgID: message.clientMsgID!,
      );
    }
  }

  /// 获取个人群资料
  Future _queryMyGroupMemberInfo() async {
    if (isGroupChat) {
      var list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: groupID!,
        userIDList: [OpenIM.iMManager.userID],
      );
      groupMembersInfo = list.firstOrNull;
      groupMemberRoleLevel.value =
          groupMembersInfo?.roleLevel ?? GroupRoleLevel.member;
      muteEndTime.value = groupMembersInfo?.muteEndTime ?? 0;
      if (null != groupMembersInfo) {
        memberUpdateInfoMap[OpenIM.iMManager.userID] = groupMembersInfo!;
      }
      _mutedClearAllInput();
    }

    return;
  }

  Future _queryOwnerAndAdmin() async {
    if (isGroupChat) {
      ownerAndAdmin = await OpenIM.iMManager.groupManager
          .getGroupMemberList(groupID: groupID!, filter: 5, count: 20);
    }
    return;
  }

  void _isJoinedGroup() async {
    if (isGroupChat) {
      isInGroup.value = await OpenIM.iMManager.groupManager.isJoinedGroup(
        groupID: groupID!,
      );
      if (isInGroup.value) _queryGroupInfo();
    }
  }

  /// 获取群资料
  void _queryGroupInfo() async {
    if (isGroupChat) {
      // final isJoinedGroup = await OpenIM.iMManager.groupManager.isJoinedGroup(
      //   groupID: groupID!,
      // );
      // if (!isJoinedGroup) return;
      var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
        groupIDList: [groupID!],
      );
      groupInfo = list.firstOrNull;
      groupOwnerID = groupInfo?.ownerUserID;
      if (_isExitUnreadAnnouncement()) {
        announcement.value = groupInfo?.notification ?? '';
      }
      groupMutedStatus.value = groupInfo?.status ?? 0;
      memberCount.value = groupInfo?.memberCount ?? 0;
      _queryMyGroupMemberInfo();
      _queryGroupCallingInfo();
    }
  }

  /// 禁言权限
  /// 1普通成员, 2群主，3管理员
  bool get havePermissionMute =>
      isGroupChat &&
      (groupInfo?.ownerUserID ==
          OpenIM.iMManager
              .userID /*||
          groupMembersInfo?.roleLevel == 2*/
      );

  /// 通知类型消息
  bool isNotificationType(Message message) => message.contentType! >= 1000;

  Map<String, String> getAtMapping(Message message) {
    return {};
  }

  void _queryUserOnlineStatus() {
    if (isSingleChat) {
      OpenIM.iMManager.userManager
          .subscribeUsersStatus([userID!]).then((value) {
        final status =
            value.firstWhereOrNull((element) => element.userID == userID);
        _configUserStatusChanged(status);
      });
      userStatusChangedSub = imLogic.userStatusChangedSubject.listen((value) {
        if (value.userID == userID) {
          _configUserStatusChanged(value);
        }
      });
    }
  }

  void _unSubscribeUserOnlineStatus() {
    if (isSingleChat) {
      OpenIM.iMManager.userManager.unsubscribeUsersStatus([userID!]);
    }
  }

  void _configUserStatusChanged(UserStatusInfo? status) {
    if (status != null) {
      onlineStatus.value = status.status == 1;
      onlineStatusDesc.value = status.status == 0
          ? StrRes.offline
          : _onlineStatusDes(status.platformIDs!) + StrRes.online;
    }
  }

  String _onlineStatusDes(List<int> plamtforms) {
    var des = <String>[];
    for (final platform in plamtforms) {
      switch (platform) {
        case 1:
          des.add('iOS');
          break;
        case 2:
          des.add('Android');
          break;
        case 3:
          des.add('Windows');
          break;
        case 4:
          des.add('Mac');
          break;
        case 5:
          des.add('Web');
          break;
        case 6:
          des.add('mini_web');
          break;
        case 7:
          des.add('Linux');
          break;
        case 8:
          des.add('Android_pad');
          break;
        case 9:
          des.add('iPad');
          break;
        default:
      }
    }

    return des.join('/');
  }

  /// 搜索定位消息位置
  void lockMessageLocation(Message message) {
    // var upList = list.sublist(0, 15);
    // var downList = list.sublist(15);
    // messageList.assignAll(downList);
    // WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    //   scrollController.jumpTo(scrollController.position.maxScrollExtent - 50);
    //   messageList.insertAll(0, upList);
    // });
  }

  void _checkInBlacklist() async {
    if (userID != null) {
      var list = await OpenIM.iMManager.friendshipManager.getBlacklist();
      var user = list.firstWhereOrNull((e) => e.userID == userID);
      isInBlacklist.value = user != null;
    }
  }

  void _setAtMapping({
    required String userID,
    required String nickname,
    String? faceURL,
  }) {
    atUserNameMappingMap[userID] = nickname;
    atUserInfoMappingMap[userID] = UserInfo(
      userID: userID,
      nickname: nickname,
      faceURL: faceURL,
    );
    // DataSp.putAtUserMap(groupID!, atUserNameMappingMap);
  }

  /// 未超过24小时
  bool isExceed24H(Message message) {
    int milliseconds = message.sendTime!;
    return !DateUtil.isToday(milliseconds);
  }

  bool isPlaySound(Message message) {
    return _currentPlayClientMsgID.value == message.clientMsgID!;
  }

  void _initPlayListener() {
    _audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          _currentPlayClientMsgID.value = "";
          break;
      }
    });
  }

  /// 播放语音消息
  void _playVoiceMessage(Message message) async {
    var isClickSame = _currentPlayClientMsgID.value == message.clientMsgID;
    if (_audioPlayer.playerState.playing) {
      _currentPlayClientMsgID.value = "";
      _audioPlayer.stop();
    }
    if (!isClickSame) {
      bool isValid = await _initVoiceSource(message);
      if (isValid) {
        _audioPlayer.setVolume(rtcIsBusy ? 0 : 1.0);
        _audioPlayer.seek(Duration.zero);
        _audioPlayer.play();
        _currentPlayClientMsgID.value = message.clientMsgID!;
      }
    }
  }

  void stopVoice() {
    if (_audioPlayer.playerState.playing) {
      _currentPlayClientMsgID.value = '';
      _audioPlayer.stop();
    }
  }

  /// 语音消息资源处理
  Future<bool> _initVoiceSource(Message message) async {
    bool isReceived = message.sendID != OpenIM.iMManager.userID;
    String? path = message.soundElem?.soundPath;
    String? url = message.soundElem?.sourceUrl;
    bool isExistSource = false;
    if (isReceived) {
      if (null != url && url.trim().isNotEmpty) {
        isExistSource = true;
        // _audioPlayer.setUrl(url);
        final audioSource = LockCachingAudioSource(Uri.parse(url));
        await _audioPlayer.setAudioSource(audioSource);
      }
    } else {
      bool existFile = false;
      if (path != null && path.trim().isNotEmpty) {
        var file = File(path);
        existFile = await file.exists();
      }
      if (existFile) {
        isExistSource = true;
        _audioPlayer.setFilePath(path!);
      } else if (null != url && url.trim().isNotEmpty) {
        isExistSource = true;
        // _audioPlayer.setUrl(url);
        final audioSource = LockCachingAudioSource(Uri.parse(url));
        await _audioPlayer.setAudioSource(audioSource);
      }
    }
    return isExistSource;
  }

  /// 显示菜单屏蔽消息插入
  void onPopMenuShowChanged(show) {
    isShowPopMenu.value = show;
    if (!show && scrollingCacheMessageList.isNotEmpty) {
      messageList.addAll(scrollingCacheMessageList);
      scrollingCacheMessageList.clear();
    }
  }

  String? getNewestNickname(Message message) {
    if (isSingleChat) null;
    return memberUpdateInfoMap[message.sendID]?.nickname;
  }

  String? getNewestFaceURL(Message message) {
    if (isSingleChat) return faceUrl.value;
    return memberUpdateInfoMap[message.sendID]?.faceURL;
  }

  /// 存在未读的公告
  bool _isExitUnreadAnnouncement() =>
      conversationInfo.value.groupAtType == GroupAtType.groupNotification;

  /// 是公告消息
  bool isAnnouncementMessage(message) => _getAnnouncement(message) != null;

  String? _getAnnouncement(Message message) {
    if (message.contentType! ==
        MessageType.groupInfoSetAnnouncementNotification) {
      final elem = message.notificationElem!;
      final map = json.decode(elem.detail!);
      final notification = GroupNotification.fromJson(map);
      if (notification.group?.notification != null &&
          notification.group!.notification!.isNotEmpty) {
        return notification.group!.notification!;
      }
    }
    return null;
  }

  /// 新消息为公告
  void _parseAnnouncement(Message message) {
    var ac = _getAnnouncement(message);
    if (null != ac) {
      announcement.value = ac;
      groupInfo?.notification = ac;
    }
  }

  /// 预览公告
  void previewGroupAnnouncement() async {
    if (null != groupInfo) {
      announcement.value = '';
      await AppNavigator.startEditGroupAnnouncement(
          groupID: groupInfo!.groupID);
    }
  }

  void closeGroupAnnouncement() {
    if (null != groupInfo) {
      announcement.value = '';
    }
  }

  _createWaitingAiMessage() async {
    final message = await OpenIM.iMManager.messageManager.createCustomMessage(
      data: json.encode(
          {"customType": CustomMessageType.waitingAiReplay, "data": {}}),
      extension: "",
      description: "",
    );
    message.createTime = -1;
    message.sendTime = -1;
    message.sendID = userID;
    message.recvID = OpenIM.iMManager.userID;
    extraMessageList.add(message);
  }

  bool get disabledChatInput {
    if (!isAiSingleChat || messageList.isEmpty) {
      return false;
    } else {
      final lastMsgSendTime = messageList.last.sendTime;
      final waitingST =
          conversationUtil.getConversationStoreById(conversationID)?.waitingST;
      return null != lastMsgSendTime &&
          null != waitingST &&
          -1 != waitingST &&
          lastMsgSendTime <= waitingST &&
          // 防止时间误差导致禁用, 可能会导致焚烧后最后一条消息不对导致解除
          messageList.last.sendID == OpenIM.iMManager.userID;
    }
  }

  bool get isInvalidGroup => !isInGroup.value && isGroupChat;

  /// 禁言条件；全员禁言，单独禁言，拉入黑名单
  bool get isMuted => isGroupMuted || isUserMuted /* || isInBlacklist.value*/;

  /// 群开启禁言，排除群组跟管理员
  bool get isGroupMuted =>
      groupMutedStatus.value == 3 &&
      groupMemberRoleLevel.value == GroupRoleLevel.member;

  /// 单独被禁言
  bool get isUserMuted =>
      muteEndTime.value > DateTime.now().millisecondsSinceEpoch;

  /// 禁言提示
  String? get hintText =>
      isMuted ? (isGroupMuted ? StrRes.groupMuted : StrRes.youMuted) : null;

  /// 禁言后 清除所有状态
  void _mutedClearAllInput() {
    if (isMuted) {
      inputCtrl.clear();
      setQuoteMsg(null);
      closeMultiSelMode();
    }
  }

  /// 清除所有强提醒
  void _resetGroupAtType() {
    // 删除所有@标识/公告标识
    if (conversationInfo.value.groupAtType != GroupAtType.atNormal) {
      OpenIM.iMManager.conversationManager.resetConversationGroupAtType(
        conversationID: conversationInfo.value.conversationID,
      );
    }
  }

  /// 消息撤回（新版本）
  void revokeMsgV2(Message message) async {
    late bool canRevoke;
    if (isGroupChat) {
      // 撤回自己的消息
      if (message.sendID == OpenIM.iMManager.userID) {
        canRevoke = true;
      } else {
        // 群组或管理员撤回群成员的消息
        var list = await LoadingView.singleton.wrap(
            asyncFunction: () => OpenIM.iMManager.groupManager
                .getGroupOwnerAndAdmin(groupID: groupID!));
        var sender = list.firstWhereOrNull((e) => e.userID == message.sendID);
        var revoker =
            list.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID);

        if (revoker != null && sender == null) {
          // 撤回者是管理员或群主 可以撤回
          canRevoke = true;
        } else if (revoker == null && sender != null) {
          // 撤回者是普通成员，但发送者是管理员或群主 不可撤回
          canRevoke = false;
        } else if (revoker != null && sender != null) {
          if (revoker.roleLevel == sender.roleLevel) {
            // 同级别 不可撤回
            canRevoke = false;
          } else if (revoker.roleLevel == GroupRoleLevel.owner) {
            // 撤回者是群主  可撤回
            canRevoke = true;
          } else {
            // 不可撤回
            canRevoke = false;
          }
        } else {
          // 都是成员 不可撤回
          canRevoke = false;
        }
      }
    } else {
      // 撤回自己的消息
      if (message.sendID == OpenIM.iMManager.userID) {
        canRevoke = true;
      }
    }
    if (canRevoke) {
      try {
        await LoadingView.singleton.wrap(
          asyncFunction: () => OpenIM.iMManager.messageManager.revokeMessage(
            conversationID: conversationInfo.value.conversationID,
            clientMsgID: message.clientMsgID!,
          ),
        );
        mediaMessages.removeWhere(
            (element) => element.clientMsgID == message.clientMsgID);
        message.contentType = MessageType.revokeMessageNotification;
        message.notificationElem =
            NotificationElem(detail: jsonEncode(_buildRevokeInfo(message)));
        formatQuoteMessage(message.clientMsgID!);
        messageList.refresh();
      } catch (e) {
        IMViews.showToast(e.toString());
      }
    } else {
      IMViews.showToast('你没有撤回消息的权限!');
    }
  }

  RevokedInfo _buildRevokeInfo(Message message) {
    return RevokedInfo.fromJson({
      'revokerID': OpenIM.iMManager.userInfo.userID,
      'revokerRole': 0,
      'revokerNickname': OpenIM.iMManager.userInfo.nickname,
      'clientMsgID': message.clientMsgID,
      'revokeTime': 0,
      'sourceMessageSendTime': 0,
      'sourceMessageSendID': message.sendID,
      'sourceMessageSenderNickname': message.senderNickname,
      'sessionType': message.sessionType,
    });
  }

  bool showTranslateMenu(Message message) {
    final status = translateLogic.msgTranslate[message.clientMsgID]?["status"];
    return (message.isTextType ||
            message.isAtTextType ||
            message.isQuoteType) &&
        (null == status || ["hide", "loading", "fail"].contains(status));
  }

  bool showUnTranslateMenu(Message message) {
    final status = translateLogic.msgTranslate[message.clientMsgID]?["status"];
    return (message.isTextType ||
            message.isAtTextType ||
            message.isQuoteType) &&
        (status == "show");
  }

  bool showTtsMenu(Message message) {
    final status = ttsLogic.msgTts[message.clientMsgID]?["status"];
    return message.isVoiceType &&
        (message?.soundElem?.sourceUrl?.isNotEmpty ?? false) &&
        (null == status || ["hide", "loading", "fail"].contains(status));
  }

  bool showUnTtsMenu(Message message) {
    final status = ttsLogic.msgTts[message.clientMsgID]?["status"];
    return message.isVoiceType && status == "show";
  }

  /// 复制菜单
  bool showCopyMenu(Message message) {
    return message.isTextType || message.isAtTextType || message.isTagTextType;
  }

  /// 删除菜单
  bool showDelMenu(Message message) {
    return !message.isPrivateType;
  }

  /// 转发菜单
  bool showForwardMenu(Message message) {
    if (message.isNotificationType ||
        message.isPrivateType ||
        message.isCallType ||
        message.isVoiceType ||
        message.isTagVoiceType) {
      return false;
    }
    return true;
  }

  /// 回复菜单
  bool showReplyMenu(Message message) {
    return message.isTextType ||
        message.isVideoType ||
        message.isPictureType ||
        message.isLocationType ||
        message.isFileType ||
        message.isQuoteType ||
        message.isCardType ||
        message.isAtTextType ||
        message.isTagTextType;
  }

  /// 是否显示撤回消息菜单
  bool showRevokeMenu(Message message) {
    if (message.status != MessageStatus.succeeded ||
        message.isNotificationType ||
        message.isCallType ||
        isExceed24H(message) && isSingleChat) {
      return false;
    }
    if (isGroupChat) {
      // for (var element in ownerAndAdmin) {
      //   printInfo(
      //       info: 'show revoke menu : ${element.nickname} - ${element.userID}');
      // }
      // 群主或管理员
      if (groupMemberRoleLevel.value == GroupRoleLevel.owner ||
          (groupMemberRoleLevel.value == GroupRoleLevel.admin &&
              ownerAndAdmin.firstWhereOrNull(
                      (element) => element.userID == message.sendID) ==
                  null)) {
        return true;
      }
    }
    if (message.sendID == OpenIM.iMManager.userID) {
      if (DateTime.now().millisecondsSinceEpoch - (message.sendTime ??= 0) <
          (1000 * 60 * 5)) {
        return true;
      }
    }
    return false;
  }

  /// 多选菜单
  bool showMultiMenu(Message message) {
    if (message.isNotificationType ||
        message.isPrivateType ||
        message.isCallType) {
      return false;
    }
    return true;
  }

  /// 添加表情菜单
  bool showAddEmojiMenu(Message message) {
    if (message.isPrivateType) {
      return false;
    }
    return message.contentType == MessageType.picture ||
        message.contentType == MessageType.customFace;
  }

  bool showCheckbox(Message message) {
    if (message.isNotificationType ||
        message.isPrivateType ||
        message.isCallType) {
      return false;
    }
    return multiSelMode.value;
  }

  WillPopCallback? willPop() {
    return multiSelMode.value || isShowPopMenu.value
        ? () async => exit()
        : null;
  }

  void expandCallingMemberPanel() {
    showCallingMember.value = !showCallingMember.value;
  }

  void _queryGroupCallingInfo() async {
    roomCallingInfo =
        await OpenIM.iMManager.signalingManager.signalingGetRoomByGroupID(
      groupID: groupInfo!.groupID,
    );
    if (roomCallingInfo.participant != null &&
        roomCallingInfo.participant!.isNotEmpty) {
      participants.assignAll(roomCallingInfo.participant!);
    }
  }

  void joinGroupCalling() async {
    if (rtcIsBusy) {
      IMViews.showToast(StrRes.callingBusy);
      return;
    }
    final certificate = await LoadingView.singleton.wrap(
      asyncFunction: () =>
          OpenIM.iMManager.signalingManager.signalingGetTokenByRoomID(
        roomID: roomCallingInfo.roomID!,
      ),
    );
    final info = roomCallingInfo.invitation!;
    // imLogic.call(
    //   callObj: CallObj.group,
    //   callType: info.mediaType == 'audio' ? CallType.audio : CallType.video,
    //   groupID: info.groupID,
    //   roomID: info.roomID,
    //   inviteeUserIDList: info.inviteeUserIDList ?? [],
    //   inviterUserID: info.inviterUserID,
    //   callState: CallState.join,
    //   credentials: certificate,
    // );
  }

  /// 当滚动位置处于底部时，将新镇的消息放入列表里
  void onScrollToTop() {
    if (scrollingCacheMessageList.isNotEmpty) {
      messageList.addAll(scrollingCacheMessageList);
      scrollingCacheMessageList.clear();
    }
  }

  String get markText {
    String? phoneNumber = imLogic.userInfo.value.phoneNumber;
    if (phoneNumber != null) {
      int start = phoneNumber.length > 4 ? phoneNumber.length - 4 : 0;
      final sub = phoneNumber.substring(start);
      return "${OpenIM.iMManager.userInfo.nickname!}$sub";
    }
    return OpenIM.iMManager.userInfo.nickname ?? '';
  }

  bool isFailedHintMessage(Message message) {
    if (message.contentType == MessageType.custom) {
      var data = message.customElem!.data;
      var map = json.decode(data!);
      var customType = map['customType'];
      return customType == CustomMessageType.deletedByFriend ||
          customType == CustomMessageType.blockedByFriend;
    }
    return false;
  }

  void sendFriendVerification() =>
      AppNavigator.startSendVerificationApplication(userID: userID);

  void _setSdkSyncDataListener() {
    connectionSub = imLogic.imSdkStatusSubject.listen((value) {
      syncStatus.value = value;
      // -1 链接失败 0 链接中 1 链接成功 2 同步开始 3 同步结束 4 同步错误
      if (value == IMSdkStatus.syncStart) {
        _isStartSyncing = true;
      } else if (value == IMSdkStatus.syncEnded) {
        if (/*_isReceivedMessageWhenSyncing &&*/ _isStartSyncing) {
          _isReceivedMessageWhenSyncing = false;
          _isStartSyncing = false;
          _isFirstLoad = true;
          onScrollToBottomLoad();
        }
      } else if (value == IMSdkStatus.syncFailed) {
        _isReceivedMessageWhenSyncing = false;
        _isStartSyncing = false;
      }
    });

    foregroundChangeSub = appCommonLogic.onForegroundChangeSub.listen((value) {
      if (value) {
        _isReceivedMessageWhenSyncing = false;
        _isStartSyncing = false;
        _isFirstLoad = true;
        onScrollToBottomLoad();
      }
    });
  }

  bool get isSyncFailed => syncStatus.value == IMSdkStatus.syncFailed;

  String? get syncStatusStr {
    switch (syncStatus.value) {
      case IMSdkStatus.syncStart:
      case IMSdkStatus.synchronizing:
        return StrRes.synchronizing;
      case IMSdkStatus.syncFailed:
        return StrRes.syncFailed;
      default:
        return null;
    }
  }

  bool showBubbleBg(Message message) {
    return !isNotificationType(message) &&
        !isFailedHintMessage(message) &&
        !isRevokeMessage(message);
  }

  bool isRevokeMessage(Message message) {
    return message.contentType == MessageType.revokeMessageNotification;
  }

  void markRevokedMessage(Message message) {
    if (message.contentType == MessageType.text ||
        message.contentType == MessageType.atText) {
      revokedTextMessage[message.clientMsgID!] = jsonEncode(message);
    }
  }

  bool canEditMessage(Message message) =>
      revokedTextMessage.containsKey(message.clientMsgID);

  void reEditMessage(Message message) {
    final value = revokedTextMessage[message.clientMsgID!]!;
    final json = jsonDecode(value);
    final old = Message.fromJson(json);
    String? content;
    if (old.contentType == MessageType.atText) {
      final atElem = old.atTextElem;
      content = atElem?.text;
      final list = atElem?.atUsersInfo;
      if (null != list) {
        for (final u in list) {
          _setAtMapping(
            userID: u.atUserID!,
            nickname: u.groupNickname!,
          );
          var uid = u.atUserID!;
          if (curMsgAtUser.contains(uid)) return;
          curMsgAtUser.add(uid);
        }
      }
    } else {
      content = old.textElem!.content;
    }
    inputCtrl.text = content ?? '';
    focusNode.requestFocus();
    inputCtrl.selection = TextSelection.fromPosition(TextPosition(
      offset: content?.length ?? 0,
    ));
  }

  Future<AdvancedMessage> _requestHistoryMessage() async {
    final result =
        await OpenIM.iMManager.messageManager.getAdvancedHistoryMessageList(
      conversationID: conversationInfo.value.conversationID,
      count: 20,
      startMsg: _isFirstLoad ? null : messageList.firstOrNull,
      lastMinSeq: _isFirstLoad ? null : lastMinSeq,
    );
    return result;
  }

  Future<bool> onScrollToBottomLoad() async {
    if (isGroupChat && ownerAndAdmin.isEmpty) {
      // 为了做撤回消息的功能,需要先获取群成员信息
      await _queryOwnerAndAdmin();
    }
    late List<Message> list;
    final result = await _requestHistoryMessage();
    if (result.messageList == null || result.messageList!.isEmpty) {
      showEncryptTips.value = true;
      return false;
    }
    _searchMediaMessage();
    list = result.messageList!;
    lastMinSeq = result.lastMinSeq;
    if (_isFirstLoad) {
      _isFirstLoad = false;
      messageList.assignAll(list);
      scrollBottom();
    } else {
      // There is currently a bug on the server side. If the number obtained once is less than one page, get it again.
      if (list.isNotEmpty && list.length < 20) {
        final result = await _requestHistoryMessage();
        if (result.messageList?.isNotEmpty == true) {
          _searchMediaMessage();
          list = result.messageList!;
          lastMinSeq = result.lastMinSeq;
        }
      }
      messageList.insertAll(0, list);
    }
    bool isMore = list.length >= 20;
    if (!isMore) showEncryptTips.value = true;
    return isMore;
  }

// Future<bool> onScrollToTopLoad() async {
//   late List<Message> list;
//   final result = await _requestHistoryMessage();
//   if (result.messageList == null || result.messageList!.isEmpty) return false;
//   list = result.messageList!;
//   lastMinSeq = result.lastMinSeq;
//   messageList.addAll(list);
//   return list.length >= 40;
// }

  /// 推荐好友名片
  recommendFriendCarte(UserInfo userInfo) async {
    final result = await AppNavigator.startSelectContacts(
      action: SelAction.recommend,
      ex: '[${StrRes.carte}]${userInfo.nickname}',
    );
    if (null != result) {
      final customEx = result['customEx'];
      final checkedList = result['checkedList'];
      for (var info in checkedList) {
        final userID = IMUtils.convertCheckedToUserID(info);
        final groupID = IMUtils.convertCheckedToGroupID(info);
        if (customEx is String && customEx.isNotEmpty) {
          // 推荐备注消息
          _sendMessage(
            await OpenIM.iMManager.messageManager.createTextMessage(
              text: customEx,
            ),
            userId: userID,
            groupId: groupID,
          );
        }
        // 名片消息
        _sendMessage(
          await OpenIM.iMManager.messageManager.createCardMessage(
            userID: userInfo.userID!,
            nickname: userInfo.nickname!,
            faceURL: userInfo.faceURL,
          ),
          userId: userID,
          groupId: groupID,
        );
      }
    }
  }
}
