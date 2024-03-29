import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:miti_common/miti_common.dart';
import 'package:path_provider/path_provider.dart';

class Config {
  //初始化全局信息
  static Future init(Function() runApp) async {
    WidgetsFlutterBinding.ensureInitialized();
    try {
      final path = (await getApplicationDocumentsDirectory()).path;
      cachePath = '$path/';
      await DataSp.init();
      await Hive.initFlutter(path);
      // await SpeechToTextUtil.instance.initSpeech();
      HttpUtil.init();
    } catch (_) {}

    runApp();

    // 设置屏幕方向
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    // 状态栏透明（Android）
    var brightness = Platform.isAndroid ? Brightness.dark : Brightness.light;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarBrightness: brightness,
      statusBarIconBrightness: brightness,
    ));
  }

  static late String cachePath;
  static const uiW = 375.0;
  static const uiH = 812.0;

  /// 默认公司配置
  static const String deptName = "miti";
  static const String deptID = '0';

  /// 全局字体size
  static const double textScaleFactor = 1.0;

  /// 秘钥
  static const secret = 'miti123';

  static const mapKey = 'R42BZ-TFLTT-GJGX3-VREBH-OD5F5-VLBTD';

  /// 离线消息默认类型
  static OfflinePushInfo offlinePushInfo = OfflinePushInfo(
    title: StrLibrary.offlineMessage,
    desc: "",
    iOSBadgeCount: true,
    iOSPushSound: '+1',
  );

  /// 二维码：scheme
  static const friendScheme = "miti.chat/addFriend/";
  static const groupScheme = "miti.chat/joinGroup/";

  /// ip
  /// web.rentsoft.cn
  /// 203.56.175.233
  /// static const host = "www.bopufund.com";
  /// static const host = "10.25.2.24";
  static const host = "www.miti.chat";

  // static const _ipRegex = '((2[0-4]\\d|25[0-5]|[01]?\\d\\d?)\\.){3}(2[0-4]\\d|25[0-5]|[01]?\\d\\d?)';
  static const _ipRegex =
      r'((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)';

  static const _domainRegex =
      r'^(?:(?=[^\.]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}$';

  static const _ipWithProtocolRegex =
      r'^(http://|https://)((2[0-4]\d|25[0-5]|[01]?\d\d?)\.){3}(2[0-4]\d|25[0-5]|[01]?\d\d?)$';

  static const _domainWithProtocolRegex =
      r'^(http://|https://)(?:(?=[^\.]{1,63}\.)(xn--)?[a-z0-9]+(-[a-z0-9]+)*\.)+[a-z]{2,63}$';

  static bool get _isIP => RegExp(_ipRegex).hasMatch(host);

  static bool get serverIpIsIP => RegExp(_ipRegex).hasMatch(serverIp);

  static bool targetIsIP(String target) => RegExp(_ipRegex).hasMatch(target);

  static bool targetIsDomain(String target) =>
      RegExp(_domainRegex, caseSensitive: false).hasMatch(target);

  static bool targetIsDomainOrIP(String target) =>
      targetIsDomain(target) || targetIsIP(target);

  static bool targetIsIPWithProtocol(String target) =>
      RegExp(_ipWithProtocolRegex).hasMatch(target);

  static bool targetIsDomainWithProtocol(String target) =>
      RegExp(_domainWithProtocolRegex, caseSensitive: false).hasMatch(target);

  static bool targetIsDomainOrIPWithProtocol(String target) =>
      targetIsIPWithProtocol(target) || targetIsDomainWithProtocol(target);

  static String get hostWithProtocol =>
      _isIP ? "http://$host" : "https://$host";

  /// 服务器IP
  static String get serverIp {
    String? ip;
    var server = DataSp.getServerConfig();
    if (null != server) {
      ip = server['serverIP'];
    }
    return ip ?? host;
  }

  /// 商业版管理后台
  /// $apiScheme://$host/admin_api/
  /// $apiScheme://$host:10009
  /// 端口：10009
  // static String get chatTokenUrl {
  //   String? url;
  //   var server = DataSp.getServerConfig();
  //   if (null != server) {
  //     url = server['chatTokenUrl'];
  //   }
  //   return url ??
  //       (_isIP ? "http://$host:10009" : "https://$host/admin_api");
  // }

  /// 登录注册手机验 证服务器地址
  /// $apiScheme://$host/chat/
  /// $apiScheme://$host:10008
  /// 端口：10008
  static String get appAuthUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['authUrl'];
    }
    // to b
    // return url ??
    //     (_isIP ? "http://$host:10010" : "https://$host/organization");
    // to c
    return url ?? (_isIP ? "http://$host:10008" : "https://$host/chat");
  }

  /// IM sdk api地址
  /// $apiScheme://$host/api/
  /// $apiScheme://$host:10002
  /// 端口：10002
  static String get imApiUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['apiUrl'];
    }
    return url ?? (_isIP ? 'http://$host:10002' : "https://$host/api");
  }

  /// IM ws 地址
  /// $socketScheme://$host/msg_gateway
  /// $socketScheme://$host:10001
  /// 端口：10001
  static String get imWsUrl {
    String? url;
    var server = DataSp.getServerConfig();
    if (null != server) {
      url = server['wsUrl'];
    }
    return url ?? (_isIP ? "ws://$host:10001" : "wss://$host/msg_gateway");
  }

  /// 图片存储
  static String get objectStorage {
    String? storage;
    var server = DataSp.getServerConfig();
    if (null != server) {
      storage = server['objectStorage'];
    }
    return storage ?? 'minio';
  }

  // 用户id, 隐藏开关
  static const testUserIds = [
    // my2
    // "7541478128",
    "1686677011",
    "1800018477",
    "2955365368",
    "3549502745",
    "3726015595",
    "3792530703",
    "3839132661",
    "4320364602",
    "4675068457",
    "4820243086",
    "5123545998",
    "5554614127",
    "6115200582",
    "6655641917",
    "8861997996",
    "9207186213",
    "9321133105",
    "9418318828"
  ];
  static const devUserIds = ["5155462645", "18318990002", "4618921056"];

  // 机器人id
  // 有方医疗-Sophie, Nicole-高尔夫导购, 有方医疗-朱教授, Camera, Nicole-高尔夫导购, 段永平
  static const botIDs = [
    "3216431598",
    "3319670832",
    "4845282902",
    "5020681160",
    "7541408629",
    "8448328647"
  ];
}
