import 'dart:async';
import 'dart:io';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:getuiflut/getuiflut.dart';
import 'package:miti_common/miti_common.dart';

class PushCtrl extends GetxController {
  // String _payloadInfo = 'Null';
  // String _notificationState = "";
  String _getClientId = "";
  // String _getDeviceToken = "";
  // String _onReceivePayload = "";
  // String _onReceiveNotificationResponse = "";
  // String _onAppLinkPayLoad = "";

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> _init() async {
    // Permissions.notification();
    // 安卓初始化
    // initGetuiSdk();
    // iOS 配置, 安卓配置build.gradle文件
    if (Platform.isIOS) {
      Getuiflut().startSdk(
        appId: "Bb8eKvZxNg5MYXza0SU1JA",
        appKey: "zmgSnejQKP6eMt58PPq827",
        appSecret: "9ehEdFOpS06l06lFkG7g28",
      );
    }

    Getuiflut().addEventHandler(
      // 注册收到 cid 的回调
      onReceiveClientId: (String message) async {
        _getClientId = message;
        myLogger.i({
          "message": "getui onReceiveClientId",
          "data": "获取到${_getClientId}"
        });
      },
      onReceiveMessageData: (Map<String, dynamic> msg) async {
        // _payloadInfo = msg['payload'];
        myLogger.i({"message": "getui onReceiveMessageData", "data": msg});
      },
      onNotificationMessageArrived: (Map<String, dynamic> msg) async {
        // _notificationState = 'Arrived';
        myLogger
            .i({"message": "getui onNotificationMessageArrived", "data": msg});
      },
      onNotificationMessageClicked: (Map<String, dynamic> msg) async {
        // _notificationState = 'Clicked';
        myLogger
            .i({"message": "getui onNotificationMessageClicked", "data": msg});
      },
      // 注册 DeviceToken 回调
      onRegisterDeviceToken: (String message) async {
        // _getDeviceToken = "$message";
        myLogger.i({"message": "getui onRegisterDeviceToken", "data": message});
      },
      // SDK收到透传消息回调
      onReceivePayload: (Map<String, dynamic> message) async {
        // _onReceivePayload = "$message";
        myLogger.i({"message": "getui onReceivePayload", "data": message});
      },
      // 点击通知回调
      onReceiveNotificationResponse: (Map<String, dynamic> message) async {
        // _onReceiveNotificationResponse = "$message";
        myLogger.i({
          "message": "getui onReceiveNotificationResponse",
          "data": message
        });
      },
      // APPLink中携带的透传payload信息
      onAppLinkPayload: (String message) async {
        // _onAppLinkPayLoad = "$message";
        myLogger.i({"message": "getui onAppLinkPayload", "data": message});
      },
      // 通知服务开启\关闭回调
      onPushModeResult: (Map<String, dynamic> message) async {
        myLogger.i({"message": "getui onPushModeResult", "data": message});
      },
      // SetTag回调
      onSetTagResult: (Map<String, dynamic> message) async {
        myLogger.i({"message": "getui onSetTagResult", "data": message});
      },
      // 设置别名回调
      onAliasResult: (Map<String, dynamic> message) async {
        myLogger.i({"message": "getui onAliasResult", "data": message});
      },
      // 查询Tag回调
      onQueryTagResult: (Map<String, dynamic> message) async {
        myLogger.i({"message": "getui onQueryTagResult", "data": message});
      },
      // APNs通知即将展示回调
      onWillPresentNotification: (Map<String, dynamic> message) async {
        myLogger
            .i({"message": "getui onWillPresentNotification", "data": message});
      },
      // APNs通知设置跳转回调
      onOpenSettingsForNotification: (Map<String, dynamic> message) async {
        myLogger.i({
          "message": "getui onOpenSettingsForNotification",
          "data": message
        });
      },
      onTransmitUserMessageReceive: (Map<String, dynamic> event) async {
        myLogger.i(
            {"message": "getui onTransmitUserMessageReceive", "data": event});
      },
      onGrantAuthorization: (String res) async {
        myLogger.i({"message": "getui onGrantAuthorization", "data": res});
      },
      onLiveActivityResult: (Map<String, dynamic> event) {
        myLogger.i({"message": "getui onLiveActivityResult", "data": event});
        return Future.value();
      },
    );
  }

  /// 初始化个推sdk
  Future<void> initGetuiSdk() async {
    try {
      Getuiflut.initGetuiSdk;
    } catch (e) {
      e.toString();
    }
  }

  ///////////SDK Public Function//////////

  void activityCreate() {
    Getuiflut().onActivityCreate();
  }

  Future<String> getClientId() async {
    return _getClientId;
  }

  /// 仅android 停止SDK服务
  void stopPush() {
    Getuiflut().turnOffPush();
  }

  /// 开启SDK服务
  void startPush() {
    Getuiflut().turnOnPush();
  }

  ///
  /// 绑定别名功能:后台可以根据别名进行推送
  /// alias 别名字符串
  /// aSn   绑定序列码, Android中无效，仅在iOS有效
  void login(String uid) {
    if (!Platform.isIOS) return;
    Getuiflut().bindAlias(uid, _getClientId);
    print("==========, login, cid: ${_getClientId}");
  }

  void logout() {
    if (!Platform.isIOS) return;
    myLogger.w({"message": "getui push_controller登出取消解绑个推"});
    Getuiflut().unbindAlias(OpenIM.iMManager.userID, _getClientId, true);
  }

  /// 给用户打标签 , 后台可以根据标签进行推送
  void setTag() {
    List test = List.filled(1, 'abc');
    Getuiflut().setTag(test);
  }

  ////////////ios Public Function////////////

  /// 仅ios 同步服务端角标
  static void setBadge(int badge) {
    Getuiflut().setBadge(badge);
  }

  /// 仅ios 同步App本地角标
  void setLocalBadge() {
    Getuiflut().setLocalBadge(0);
  }

  /// 仅ios 复位服务端角标
  static void resetBadge() {
    Getuiflut().resetBadge();
  }

  /// 仅ios
  void setPushMode() {
    Getuiflut().setPushMode(0);
  }

  /// 获取冷启动Apns参数
  Future<void> getLaunchNotification() async {
    Map info;
    try {
      info = await Getuiflut.getLaunchNotification;
    } catch (e) {
      Logger.print(e.toString());
    }
  }

  @override
  void onInit() {
    _init();
    super.onInit();
  }
}
