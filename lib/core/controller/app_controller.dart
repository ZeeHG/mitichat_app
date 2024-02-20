import 'dart:convert';
import 'dart:io';
import 'dart:ui';
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

import '../../utils/upgrade_manager.dart';
import 'im_controller.dart';
import 'push_controller.dart';

// 下载0, 后台1, 消息message.seq
class AppController extends SuperController {
  var isRunningBackground = false;
  var isAppBadgeSupported = false;

  final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  final initializationSettingsAndroid =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  /// Note: permissions aren't requested here just to demonstrate that can be
  /// done later
  final DarwinInitializationSettings initializationSettingsDarwin =
      DarwinInitializationSettings(
    requestAlertPermission: false,
    requestBadgePermission: false,
    requestSoundPermission: false,
    onDidReceiveLocalNotification: (
      int id,
      String? title,
      String? body,
      String? payload,
    ) async {},
  );

  MeetingBridge? meetingBridge = PackageBridge.meetingBridge;

  RTCBridge? rtcBridge = PackageBridge.rtcBridge;

  bool get shouldMuted =>
      meetingBridge?.hasConnection == true || rtcBridge?.hasConnection == true;

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
      _startForegroundService();
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

  void _requestPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestExactAlarmsPermission();
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

  Future<void> promptSoundOrNotification(im.Message message) async {
    if (!isRunningBackground) {
      _playMessageSound();
    } else {
      if (Platform.isAndroid) {
        final id = message.seq!;
        String text = StrRes.defaultNotification;
        if (message.isTextType) {
          text = message.textElem!.content!;
        } else if (message.isAtTextType) {
          text = IMUtils.replaceMessageAtMapping(message, {});
        } else if (message.isQuoteType) {
          text = message.quoteElem?.text ?? text;
        } else if (message.isPictureType) {
          text = StrRes.defaultImgNotification;
        } else if (message.isVideoType) {
          text = StrRes.defaultVideoNotification;
        } else if (message.isVoiceType) {
          text = StrRes.defaultVoiceNotification;
        } else if (message.isFileType) {
          text = StrRes.defaultFileNotification;
        } else if (message.isLocationType) {
          text = StrRes.defaultLocationNotification;
        } else if (message.isMergerType) {
          text = StrRes.defaultMergeNotification;
        } else if (message.isCardType) {
          text = StrRes.defaultCardNotification;
        }
        const androidPlatformChannelSpecifics = AndroidNotificationDetails(
            'push', 'push',
            channelDescription: 'message push',
            importance: Importance.max,
            priority: Priority.max,
            playSound: true,
            enableVibration: true,
            fullScreenIntent: true,
            silent: false,
            channelShowBadge : true,
            category: AndroidNotificationCategory.message,
            visibility: NotificationVisibility.public,
            ticker: 'one message');
        const NotificationDetails platformChannelSpecifics =
            NotificationDetails(android: androidPlatformChannelSpecifics);
        await flutterLocalNotificationsPlugin.show(
            id, StrRes.defaultNotificationTitle, text, platformChannelSpecifics,
            payload: json.encode(message.toJson()));
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
        ?.startForegroundService(1, 'miti', 'running...',
            notificationDetails: androidPlatformChannelSpecifics, payload: '');
  }

  Future<void> _stopForegroundService() async {
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

  Locale? getLocale() {
    var local = Get.locale;
    Locale systemLocal = window.locale;
    var language = DataSp.getLanguage();
    var index = (language != null && language != 0)
        ? language
        : (systemLocal.toString().startsWith("zh_")
            ? 1
            : systemLocal.toString().startsWith("en_")
                ? 2
                : systemLocal.toString().startsWith("ja_")
                    ? 3
                    : systemLocal.toString().startsWith("ko_")
                        ? 4
                        : systemLocal.toString().startsWith("es_")
                            ? 5
                            : 0);
    switch (index) {
      case 1:
        local = const Locale('zh', 'CN');
        break;
      case 2:
        local = const Locale('en', 'US');
        break;
      case 3:
        local = const Locale('ja', 'JP');
        break;
      case 4:
        local = const Locale('ko', 'KR');
        break;
      case 5:
        local = const Locale('es', 'ES');
        break;
    }
    return local;
  }

  @override
  void onReady() {
    _startForegroundService();
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
