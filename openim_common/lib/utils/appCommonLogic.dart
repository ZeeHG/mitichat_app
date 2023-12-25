import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:app_installer/app_installer.dart';
import 'package:collection/collection.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:rxdart/rxdart.dart';
import '../openim_common.dart';
import 'package:device_info_plus/device_info_plus.dart';

class AppCommonLogic extends GetxController {
  AppCommonLogic() {
    getDeviceInfo();
  }

  final isForeground = true.obs;
  // needUpdate, path, version, size
  final appCacheInfo = <String, dynamic>{}.obs;
  IosDeviceInfo? iosInfo;
  AndroidDeviceInfo? androidInfo;
  String deviceModel = "";

  get isZh => Get.locale!.languageCode.toLowerCase().contains("zh");

  void setForeground(bool status) => isForeground.value = status;

  void setAppCacheInfo(
          {required bool needUpdate,
          required String path,
          required String version,
          required String size}) =>
      appCacheInfo.value = {
        "needUpdate": needUpdate,
        "path": path,
        "version": version,
        "size": size,
      };

  void tryUpdateAppFromCache() async {
    if (Platform.isAndroid &&
        isForeground.value &&
        null != appCacheInfo["needUpdate"] &&
        appCacheInfo["needUpdate"] &&
        appCacheInfo["path"].isNotEmpty &&
        appCacheInfo["version"].isNotEmpty &&
        appCacheInfo["size"].isNotEmpty) {
      try {
        PackageInfo packageInfo = await PackageInfo.fromPlatform();
        final cacheVersion = double.parse(appCacheInfo["version"] ?? '0');
        final curVersion = double.parse(packageInfo!.buildNumber ?? '0');
        final file = await IMUtils.getFile(path: appCacheInfo["path"]);

        myLogger.i(
            {"message": "回到前台更新app, apk版本=$cacheVersion, app版本=$curVersion"});
        // 更新
        if (cacheVersion > curVersion &&
            file != null &&
            await file.length() == int.parse(appCacheInfo["size"])) {
          myLogger.i({"message": "在前台更新app"});
          AppInstaller.installApk(appCacheInfo["path"]);
        }
      } finally {
        // 修改状态
        appCacheInfo.value = {};
      }
    }
  }

  Future<dynamic> getDeviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    if (Platform.isIOS) {
      if (null != iosInfo) return iosInfo;
      iosInfo = await deviceInfo.iosInfo;
      deviceModel = iosInfo?.utsname?.machine ?? "iosModel";
      myLogger.i({"message": "设备信息", "data": iosInfo});
      return iosInfo;
    } else {
      if (null != androidInfo) return androidInfo;
      androidInfo = await deviceInfo.androidInfo;
      deviceModel = (androidInfo?.manufacturer ?? "androidManufacturer") + "+"  + (androidInfo?.model ?? "androidModel");
      myLogger.i({"message": "设备信息", "data": androidInfo});
      return androidInfo;
    }
  }
}
