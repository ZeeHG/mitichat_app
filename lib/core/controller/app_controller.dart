import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:dart_date/dart_date.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart' as im;
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:openim_common/openim_common.dart';
import 'package:sound_mode/sound_mode.dart';
import 'package:sound_mode/utils/ringer_mode_statuses.dart';
import 'package:vibration/vibration.dart';

// import '../../utils/upgrade_manager.dart';
import 'im_controller.dart';
import 'push_controller.dart';

// 下载0, 后台1, 消息message.seq
class AppController extends SuperController {
  var isRunningBackground = false;
  var isAppBadgeSupported = false;
  var notificationSeq = 3000;
  var hadShowMessageIdList = [];

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: true,
    requestBadgePermission: true,
    requestSoundPermission: true,
    onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {},
  );

  // MeetingBridge? meetingBridge = PackageBridge.meetingBridge;

  RTCBridge? rtcBridge = PackageBridge.rtcBridge;

  // bool get shouldMuted =>
  //     meetingBridge?.hasConnection == true || rtcBridge?.hasConnection == true;

  bool get shouldMuted => true;

  final _ring = 'assets/audio/message_ring.wav';
  final _audioPlayer = AudioPlayer(
      // Handle audio_session events ourselves for the purpose of this demo.
      // handleInterruptions: false,
      // androidApplyAudioAttributes: false,
      // handleAudioSessionActivation: false,
      );

  late BaseDeviceInfo deviceInfo;

  /// discoverPageURL
  /// ordinaryUserAddFriend,
  /// bossUserID,
  /// adminURL ,
  /// allowSendMsgNotFriend
  /// needInvitationCodeRegister
  /// robots
  final clientConfigMap = <String, dynamic>{}.obs;

  Future<void> runningBackground(bool run) async {
    Logger.print('-----App running background : $run-------------');

    if (isRunningBackground && !run) {}
    isRunningBackground = run;
    Get.find<IMController>().backgroundSubject.sink.add(run);
    if (!run) {
      _cancelAllNotifications();
    } else {
      // _startForegroundService();
    }
  }

  @override
  void onInit() async {
    queryClientConfig();
    _requestPermissions();
    _initPlayer();
    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (notificationResponse) {
        myLogger.i({
          "message": "点击本地通知",
          "data": {
            "id": notificationResponse.id,
            "actionId": notificationResponse.actionId,
            "input": notificationResponse.input,
            "notificationResponseType":
                notificationResponse.notificationResponseType,
            "payload": notificationResponse.payload,
          }
        });
      },
    );
    // _startForegroundService();
    isAppBadgeSupported = await FlutterAppBadger.isAppBadgeSupported();
    super.onInit();
  }

  void _requestPermissions() async {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
            alert: true, badge: true, sound: true, critical: true);
  }

  Future<void> showNotification(im.Message message,
      {bool showNotification = true}) async {
    if (_isGlobalNotDisturb() ||
            message.attachedInfoElem?.notSenderNotificationPush == true ||
            message.contentType == im.MessageType.typing ||
            message.sendID ==
                OpenIM.iMManager
                    .userID /* ||
        message.contentType! >= 1000*/
        ) return;

    // 开启免打扰的不提示
    var sourceID = message.sessionType == ConversationType.single
        ? message.sendID
        : message.groupID;
    if (sourceID != null && message.sessionType != null) {
      var i = await OpenIM.iMManager.conversationManager.getOneConversation(
        sourceID: sourceID,
        sessionType: message.sessionType!,
      );
      if (i.recvMsgOpt != 0) return;
    }

    if (showNotification) {
      promptSoundOrNotification(message);
    }
  }

  Future<void> promptLiveNotification(SignalingInfo signalingInfo) async {
    if (Platform.isAndroid && isRunningBackground) {
      const androidPlatformChannelSpecifics =
          AndroidNotificationDetails('push', 'push',
              channelDescription: 'message push',
              importance: Importance.max,
              priority: Priority.max,
              playSound: false,
              enableVibration: false,
              // 启动后通知要很久才消失
              // fullScreenIntent: true,
              silent: false,
              // 无效
              channelShowBadge: false,
              category: AndroidNotificationCategory.call,
              visibility: NotificationVisibility.public,
              // 无效
              number: 0,
              ticker: 'one message');
      const NotificationDetails platformChannelSpecifics =
          NotificationDetails(android: androidPlatformChannelSpecifics);
      final isGroup = signalingInfo.invitation?.sessionType == 2;
      final isAudio = signalingInfo.invitation?.mediaType == 'audio';
      final id = isGroup
          ? signalingInfo.invitation?.groupID
          : signalingInfo.invitation?.inviterUserID;
      try {
        final list =
            await OpenIM.iMManager.friendshipManager.getFriendListMap();
        final friendJson = list.firstWhereOrNull((element) {
          final fullUser = FullUserInfo.fromJson(element);
          return fullUser.userID == id;
        });
        ISUserInfo? friendInfo;
        if (null != friendJson) {
          final info = FullUserInfo.fromJson(friendJson);
          friendInfo = info.friendInfo != null
              ? ISUserInfo.fromJson(info.friendInfo!.toJson())
              : ISUserInfo.fromJson(info.publicInfo!.toJson());
        }

        if (isGroup) {
          final list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
          final groupInfo =
              list.firstWhereOrNull((element) => element.groupID == id);
          GroupMembersInfo? member;
          if (null != groupInfo) {
            final memberList =
                await OpenIM.iMManager.groupManager.getGroupMemberList(
              groupID: groupInfo.groupID,
              count: 999,
            );
            member = memberList.firstWhereOrNull((element) =>
                element.userID == signalingInfo.invitation?.inviterUserID);
          }

          await flutterLocalNotificationsPlugin.show(
              notificationSeq + DateTime.now().secondsSinceEpoch,
              groupInfo?.groupName ?? StrLibrary.defaultNotificationTitle4,
              "${(null != friendInfo && friendInfo.showName.isNotEmpty) ? friendInfo.showName : member?.nickname ?? StrLibrary.friend}: ${isAudio ? '[${StrLibrary.callVoice}]' : '[${StrLibrary.callVideo}]'}",
              platformChannelSpecifics,
              payload: null);
        } else {
          await flutterLocalNotificationsPlugin.show(
              notificationSeq + DateTime.now().secondsSinceEpoch,
              friendInfo?.showName ?? StrLibrary.defaultNotificationTitle3,
              isAudio
                  ? '[${StrLibrary.callVoice}]'
                  : '[${StrLibrary.callVideo}]',
              platformChannelSpecifics,
              payload: null);
        }
      } catch (e, s) {
        myLogger.e({
          "message": "通话消息本地通知出错",
          "data": signalingInfo.toJson(),
          "error": e,
          "stack": s
        });
        await flutterLocalNotificationsPlugin.show(
            notificationSeq + DateTime.now().secondsSinceEpoch,
            StrLibrary.defaultNotificationTitle3,
            isAudio ? '[${StrLibrary.callVoice}]' : '[${StrLibrary.callVideo}]',
            platformChannelSpecifics,
            payload: null);
      }
    }
  }

  Future<void> promptSoundOrNotification(im.Message message) async {
    if (hadShowMessageIdList.contains(message.clientMsgID)) {
      myLogger.e({"message": "出现重复通知", "data": message.toJson()});
      return;
    }
    hadShowMessageIdList.add(message.clientMsgID);
    if (!isRunningBackground) {
      if (Platform.isAndroid) {
        _playMessageSound();
      }
    } else {
      if (Platform.isAndroid) {
        const androidPlatformChannelSpecifics =
            AndroidNotificationDetails('push', 'push',
                channelDescription: 'message push',
                importance: Importance.max,
                priority: Priority.max,
                playSound: true,
                enableVibration: true,
                // 启动后通知要很久才消失
                // fullScreenIntent: true,
                silent: false,
                // 无效
                channelShowBadge: false,
                category: AndroidNotificationCategory.message,
                visibility: NotificationVisibility.public,
                // 无效
                number: 0,
                ticker: 'one message');
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);

        try {
          // final id = message.seq!;
          notificationSeq = notificationSeq + 1;
          String text = StrLibrary.defaultNotification;
          String? noticeTypeMsgGroupName;
          if (message.isTextType) {
            text = message.textElem!.content!;
          } else if (message.isAtTextType) {
            text = IMUtils.replaceMessageAtMapping(message, {});
          } else if (message.isQuoteType) {
            text = message.quoteElem?.text ?? text;
          } else if (message.isPictureType) {
            text = StrLibrary.defaultImgNotification;
          } else if (message.isVideoType) {
            text = StrLibrary.defaultVideoNotification;
          } else if (message.isVoiceType) {
            text = StrLibrary.defaultVoiceNotification;
          } else if (message.isFileType) {
            text = StrLibrary.defaultFileNotification;
          } else if (message.isLocationType) {
            text = StrLibrary.defaultLocationNotification;
          } else if (message.isMergerType) {
            text = StrLibrary.defaultMergeNotification;
          } else if (message.isCardType) {
            text = StrLibrary.defaultCardNotification;
          } else if (message.contentType! >= 1000) {
            // 尝试解析通知类型
            noticeTypeMsgGroupName =
                IMUtils.parseNtfMap(message)?["group"]?["groupName"];
            String? str = IMUtils.parseNtf(message, isConversation: true);
            if (null == str) {
              text = StrLibrary.defaultNotificationTitle;
              myLogger.e({
                "message": "contentType>=1000的消息解析失败",
                "data": message.toJson()
              });
            } else {
              text = str;
            }
          } else {
            // 其他类型暂时不展示
            myLogger.w(
                {"message": "sdk收到一条消息, 未匹配需要暂时的情况", "data": message.toJson()});
          }

          final list =
              await OpenIM.iMManager.friendshipManager.getFriendListMap();
          final friendJson = list.firstWhereOrNull((element) {
            final fullUser = FullUserInfo.fromJson(element);
            return fullUser.userID == message.sendID;
          });
          ISUserInfo? friendInfo;
          if (null != friendJson) {
            final info = FullUserInfo.fromJson(friendJson);
            friendInfo = info.friendInfo != null
                ? ISUserInfo.fromJson(info.friendInfo!.toJson())
                : ISUserInfo.fromJson(info.publicInfo!.toJson());
          }
          if (message.isSingleChat) {
            if (null == friendInfo) {
              myLogger.e({"message": "收到单聊消息, 找不到好友信息, ${message.sendID}"});
            }
            await flutterLocalNotificationsPlugin.show(
                notificationSeq,
                friendInfo?.showName ?? StrLibrary.defaultNotificationTitle3,
                text,
                platformChannelSpecifics,
                payload: json.encode(message.toJson()));
          } else if (message.isGroupChat) {
            final list =
                await OpenIM.iMManager.groupManager.getJoinedGroupList();
            final groupInfo = list.firstWhereOrNull(
                (element) => element.groupID == message.groupID);
            if (null == groupInfo) {
              myLogger.e({"message": "收到群聊消息, 找不到群组信息, ${message.groupID}"});
            }
            await flutterLocalNotificationsPlugin.show(
                notificationSeq,
                groupInfo?.groupName ??
                    noticeTypeMsgGroupName ??
                    StrLibrary.defaultNotificationTitle4,
                message.isNoticeType
                    ? "${StrLibrary.groupAc}: ${text}"
                    : ("${(null != friendInfo && friendInfo.showName.isNotEmpty) ? friendInfo.showName : message.senderNickname ?? StrLibrary.friend}: ${text}"),
                platformChannelSpecifics,
                payload: json.encode(message.toJson()));
          } else {
            myLogger.w({
              "message":
                  "收到意外通知类型的消息, 消息类型(sessionType: ${message.sessionType})",
              "data": message.toJson(),
            });
            await flutterLocalNotificationsPlugin.show(
                notificationSeq,
                StrLibrary.defaultNotificationTitle2,
                text,
                platformChannelSpecifics,
                payload: json.encode(message.toJson()));
          }
        } catch (e, s) {
          myLogger.e({
            "message": "message消息本地通知出错",
            "data": message.toJson(),
            "error": e,
            "stack": s
          });
          await flutterLocalNotificationsPlugin.show(
              notificationSeq, "error", "error", platformChannelSpecifics,
              payload: null);
        }
      }
    }
  }

  Future<void> _cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }

  Future<void> _startForegroundService() async {
    // await getAppInfo();
    if (!Platform.isAndroid) return;
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'keep', 'keep',
        playSound: false,
        enableVibration: false,
        channelDescription: 'keep alive',
        importance: Importance.defaultImportance,
        priority: Priority.defaultPriority,
        ticker: ' ');

    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.startForegroundService(
          1, 'miti', 'running...',
          notificationDetails: androidPlatformChannelSpecifics,
          payload: ' ',
          // foregroundServiceTypes: {
          //   // AndroidServiceForegroundType.foregroundServiceTypeSystemExempted,
          //   // AndroidServiceForegroundType.foregroundServiceTypePhoneCall,
          //   // AndroidServiceForegroundType.foregroundServiceTypeDataSync,
          //   AndroidServiceForegroundType.foregroundServiceTypeRemoteMessaging,

          //   // AndroidServiceForegroundType.foregroundServiceTypeMediaPlayback,
          //   // AndroidServiceForegroundType.foregroundServiceTypeConnectedDevice,
          // }
        );
  }

  Future<void> _stopForegroundService() async {
    if (!Platform.isAndroid) return;
    await flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.stopForegroundService();
  }

  void showBadge(count) {
    if (isAppBadgeSupported) {
      OpenIM.iMManager.messageManager.setAppBadge(count);

      if (count == 0) {
        removeBadge();
        PushController.resetBadge();
      } else {
        FlutterAppBadger.updateBadgeCount(count);
        PushController.setBadge(count);
      }
    }
  }

  void removeBadge() {
    FlutterAppBadger.removeBadge();
  }

  @override
  void onClose() {
    // backgroundSubject.close();
    // _stopForegroundService();
    // closeSubject();
    _audioPlayer.dispose();
    super.onClose();
  }

  Locale? getCurLocale(BuildContext context) {
    Locale? locale = Get.locale;
    String windowLocaleStr =
        View.of(context).platformDispatcher.locale.toString();
    
    int? lang = DataSp.getLanguage();
    int index = (lang != null && lang != 0)
        ? lang
        : (windowLocaleStr.startsWith("zh_")
            ? 1
            : windowLocaleStr.startsWith("en_")
                ? 2
                : windowLocaleStr.startsWith("ja_")
                    ? 3
                    : windowLocaleStr.startsWith("ko_")
                        ? 4
                        : windowLocaleStr.startsWith("es_")
                            ? 5
                            : 0);
    switch (index) {
      case 1:
        locale = const Locale('zh', 'CN');
        break;
      case 2:
        locale = const Locale('en', 'US');
        break;
      case 3:
        locale = const Locale('ja', 'JP');
        break;
      case 4:
        locale = const Locale('ko', 'KR');
        break;
      case 5:
        locale = const Locale('es', 'ES');
        break;
    }
    return locale;
  }

  @override
  void onReady() {
    // _startForegroundService();
    _getDeviceInfo();
    _cancelAllNotifications();
    // autoCheckVersionUpgrade();
    super.onReady();
  }

  /// 全局免打扰
  bool _isGlobalNotDisturb() {
    bool isRegistered = Get.isRegistered<IMController>();
    if (isRegistered) {
      var logic = Get.find<IMController>();
      return logic.userInfo.value.globalRecvMsgOpt == 2;
    }
    return false;
  }

  void _initPlayer() {
    _audioPlayer.setAsset(_ring, package: 'openim_common');
    // _audioPlayer.setLoopMode(LoopMode.off);
    // _audioPlayer.setVolume(1.0);
    _audioPlayer.playerStateStream.listen((state) {
      switch (state.processingState) {
        case ProcessingState.idle:
        case ProcessingState.loading:
        case ProcessingState.buffering:
        case ProcessingState.ready:
          break;
        case ProcessingState.completed:
          _stopMessageSound();
          // _audioPlayer.seek(null);
          break;
      }
    });
  }

  /// 播放提示音
  void _playMessageSound() async {
    if (shouldMuted) {
      return;
    }
    bool isRegistered = Get.isRegistered<IMController>();
    bool isAllowVibration = true;
    bool isAllowBeep = true;
    if (isRegistered) {
      var logic = Get.find<IMController>();
      isAllowVibration = logic.userInfo.value.allowVibration == 1;
      isAllowBeep = logic.userInfo.value.allowBeep == 1;
    }
    // 获取系统静音、震动状态
    RingerModeStatus ringerStatus = await SoundMode.ringerModeStatus;

    if (!_audioPlayer.playerState.playing &&
        isAllowBeep &&
        (ringerStatus == RingerModeStatus.normal ||
            ringerStatus == RingerModeStatus.unknown)) {
      _audioPlayer.setAsset(_ring, package: 'openim_common');
      _audioPlayer.setLoopMode(LoopMode.off);
      _audioPlayer.setVolume(1.0);
      _audioPlayer.play();
    }

    if (isAllowVibration &&
        (ringerStatus == RingerModeStatus.normal ||
            ringerStatus == RingerModeStatus.vibrate ||
            ringerStatus == RingerModeStatus.unknown)) {
      if (await Vibration.hasVibrator() == true) {
        Vibration.vibrate();
      }
    }
  }

  /// 关闭提示音
  void _stopMessageSound() async {
    if (_audioPlayer.playerState.playing) {
      _audioPlayer.stop();
    }
  }

  void _getDeviceInfo() async {
    final deviceInfoPlugin = DeviceInfoPlugin();
    deviceInfo = await deviceInfoPlugin.deviceInfo;
  }

  Future queryClientConfig() async {
    myLogger.i({"message": "获取客户端配置"});
    Map<String, dynamic> defaultConfig = {
      "allowSendMsgNotFriend": "0",
      "needInvitationCodeRegister": "1"
    };
    Map<String, dynamic> map = defaultConfig;
    try {
      map = await Apis.getClientConfig();
    } catch (e, s) {
      myLogger.e({
        "message": "获取客户端配置异常, 使用默认配置",
        "error": {"error": e, "defalutConfig": defaultConfig},
        "stack": s
      });
    } finally {
      clientConfigMap.assignAll(map);
    }
    return clientConfigMap;
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    // TODO: implement onResumed
    // autoCheckVersionUpgrade();
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
