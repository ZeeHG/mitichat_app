import 'dart:io';
import 'package:permission_handler/permission_handler.dart';
import 'package:app_installer/app_installer.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';

import '../widgets/upgrade_view.dart';

class UpgradeManger {
  PackageInfo? packageInfo;
  UpgradeInfoV2? upgradeInfoV2;
  var isShowUpgradeDialog = false;
  var isNowIgnoreUpdate = false;
  final subject = PublishSubject<double>();
  final appCommonLogic = Get.find<AppCommonLogic>();

  void closeSubject() {
    subject.close();
  }

  void ignoreUpdate() {
    DataSp.putIgnoreVersion(
        upgradeInfoV2!.buildVersion! + upgradeInfoV2!.buildVersionNo!);
    Get.back();
  }

  void laterUpdate() {
    isNowIgnoreUpdate = true;
    Get.back();
  }

  getAppInfo() async {
    packageInfo ??= await PackageInfo.fromPlatform();
  }

  void nowUpdate() async {
    if (Platform.isAndroid) {
      final result = await Permissions.notification();
      if (!result) {
        await IMViews.showToast(StrRes.upgradePermissionTips, duration: 2.seconds);
        openAppSettings();
        return;
      }
      Permissions.storage(() async {
        var path = await IMUtils.createTempFile(
          dir: 'apk',
          name: '${packageInfo!.appName}_${upgradeInfoV2!.buildVersionNo}.apk',
        );
        final file = await IMUtils.getFile(path: path);
        if (file != null &&
            await file.length() == int.parse(upgradeInfoV2!.buildFileSize!)) {
          myLogger.i({"message": "从已下载的apk安装"});
          AppInstaller.installApk(path);
          return;
        }
        NotificationService notificationService = NotificationService();
        int lastProgress = -1;
        myLogger.i({"message": "开始下载apk"});
        HttpUtil.download(
          upgradeInfoV2!.downloadURL!,
          cachePath: path,
          onProgress: (int count, int total) async {
            subject.add(count / total);
            int progress = ((count / total) * 100).toInt();
            if (progress > lastProgress) {
              lastProgress = progress;
              notificationService.createNotification(
                  100, progress, 0, StrRes.downloading);
            }
            if (count == total) {
              if (appCommonLogic.isForeground.value) {
                myLogger.i({"message": "下载apk完成, 前台开始安装"});
                AppInstaller.installApk(path);
              } else {
                myLogger.i({"message": "下载apk完成, 处于后台, 记录更新标记"});
                AppInstaller.installApk(path);
                // 后台无法安装时标记下
                appCommonLogic.setAppCacheInfo(
                    needUpdate: true,
                    path: path,
                    version: upgradeInfoV2!.buildVersionNo!,
                    size: upgradeInfoV2!.buildFileSize!);
              }
            }
          },
        ).catchError((s, t) {
          notificationService.createNotification(
              100, 0, 0, StrRes.downloadFail);
        });
      });
    } else {
      // if (await canLaunch(upgradeInfo!.url!)) {
      //   launch(upgradeInfo!.url!);
      // }
    }
  }

  void checkUpdate() async {
    if (!Platform.isAndroid) return;
    CancelToken cancelToken = CancelToken();
    LoadingView.singleton
        .wrap(
            asyncFunction: () async {
              await getAppInfo();
              return Apis.checkUpgradeV2(cancelToken: cancelToken);
            },
            cancelToken: cancelToken)
        .then((value) {
      upgradeInfoV2 = value;
      if (!canUpdate) {
        IMViews.showToast('已是最新版本');
        return;
      }
      Get.dialog(
        UpgradeViewV2(
          upgradeInfo: upgradeInfoV2!,
          packageInfo: packageInfo!,
          onNow: nowUpdate,
          subject: subject,
        ),
        routeSettings: const RouteSettings(name: 'upgrade_dialog'),
      );
    });
  }

  /// 自动检测更新
  autoCheckVersionUpgrade() async {
    if (!Platform.isAndroid) return;
    if (isShowUpgradeDialog || isNowIgnoreUpdate) return;
    await getAppInfo();
    upgradeInfoV2 = await Apis.checkUpgradeV2();
    String? ignore = DataSp.getIgnoreVersion();
    if (ignore ==
        upgradeInfoV2!.buildVersion! + upgradeInfoV2!.buildVersionNo!) {
      isNowIgnoreUpdate = true;
      return;
    }
    if (!canUpdate) return;
    isShowUpgradeDialog = true;
    Get.dialog(
      UpgradeViewV2(
        upgradeInfo: upgradeInfoV2!,
        packageInfo: packageInfo!,
        onLater: laterUpdate,
        onIgnore: ignoreUpdate,
        onNow: nowUpdate,
        subject: subject,
      ),
      routeSettings: const RouteSettings(name: 'upgrade_dialog'),
    ).whenComplete(() => isShowUpgradeDialog = false);
  }

  bool get canUpdate =>
      (double.parse(upgradeInfoV2!.buildVersionNo! ?? '0')) >
      (double.parse(packageInfo!.buildNumber ?? '0'));
}

class NotificationService {
  // Handle displaying of notifications.
  static final NotificationService _notificationService =
      NotificationService._internal();
  final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  final AndroidInitializationSettings _androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal() {
    init();
  }

  void init() async {
    final InitializationSettings initializationSettings =
        InitializationSettings(
      android: _androidInitializationSettings,
    );
    await _flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  void createNotification(int count, int i, int id, String status) {
    //show the notifications.
    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'download', 'miti download',
        channelDescription: 'miti download',
        channelShowBadge: false,
        importance: Importance.max,
        priority: Priority.high,
        onlyAlertOnce: true,
        showProgress: true,
        maxProgress: count,
        progress: i);
    var platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    _flutterLocalNotificationsPlugin
        .show(id, status, '$i%', platformChannelSpecifics, payload: 'item x');
  }
}
