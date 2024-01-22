import 'package:openim_common/utils/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class Permissions {
  Permissions._();

  static Permission photosPermission = Permission.photos;

  static Permission videosPermission = Permission.videos;

  static Future<bool> overAndroid13() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      return androidInfo.version.sdkInt > 32;
    }
    return false;
  }

  static Future<bool> checkSystemAlertWindow() async {
    // return Permission.systemAlertWindow.isGranted;
    return batchCheckPermissions([Permission.systemAlertWindow]);
  }

  // static Future<bool> checkStorage() async {
  //   return await Permission.storage.isGranted;
  // }

  static void camera(Function()? onGranted) async {
    // if (await Permission.camera.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   onGranted?.call();
    // }
    // if (await Permission.camera.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    // }

    await batchRequestAndCheckPermissions([Permission.camera],
        onAgree: onGranted);
  }

  static Future<void> storage(Function()? onGranted,
      {List<Permission>? permissions}) async {
    if (await overAndroid13()) {
      if (null == permissions) {
        onGranted?.call();
        return;
      }
      await batchRequestPermissions(permissions);
      if (await checkStorageV2(permissions)) {
        onGranted?.call();
      }
    } else {
      // if (await Permission.storage.request().isGranted) {
      //   onGranted?.call();
      // }
      await batchRequestAndCheckPermissions([Permission.storage],
          onAgree: onGranted);
    }
  }

  // static void manageExternalStorage(Function()? onGranted) async {
  //   if (await Permission.manageExternalStorage.request().isGranted) {
  //     // Either the permission was already granted before or the user just granted it.
  //     onGranted?.call();
  //   }
  //   if (await Permission.storage.isPermanentlyDenied) {
  //     // The user opted to never again see the permission request dialog for this
  //     // app. The only way to change the permission's status now is to let the
  //     // user manually enable it in the system settings.
  //   }
  // }

  static void microphone(Function()? onGranted) async {
    // if (await Permission.microphone.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   onGranted?.call();
    // }
    // if (await Permission.microphone.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    // }

    await batchRequestAndCheckPermissions([Permission.microphone],
        onAgree: onGranted);
  }

  static void location(Function()? onGranted) async {
    // if (await Permission.location.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   onGranted?.call();
    // }
    // if (await Permission.location.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    // }

    await batchRequestAndCheckPermissions([Permission.location],
        onAgree: onGranted);
  }

  static void speech(Function()? onGranted) async {
    // if (await Permission.speech.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   onGranted?.call();
    // }
    // if (await Permission.speech.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    // }

    await batchRequestAndCheckPermissions([Permission.speech],
        onAgree: onGranted);
  }

  static void photos(Function()? onGranted) async {
    // if (await Permission.photos.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   onGranted?.call();
    // }
    // if (await Permission.photos.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    // }

    await batchRequestAndCheckPermissions([Permission.photos],
        onAgree: onGranted);
  }

  static Future<bool> notification() async {
    // if (await Permission.notification.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   return true;
    // }
    // if (await Permission.notification.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    // }

    // return false;

    return await batchRequestAndCheckPermissions([Permission.notification]);
  }

  static void ignoreBatteryOptimizations(Function()? onGranted) async {
    // if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
    //   // Either the permission was already granted before or the user just granted it.
    //   onGranted?.call();
    // }
    // if (await Permission.ignoreBatteryOptimizations.isPermanentlyDenied) {
    //   // The user opted to never again see the permission request dialog for this
    //   // app. The only way to change the permission's status now is to let the
    //   // user manually enable it in the system settings.
    // }

    await batchRequestAndCheckPermissions(
        [Permission.ignoreBatteryOptimizations],
        onAgree: onGranted);
  }

  static void cameraAndMicrophone(Function()? onGranted) async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      // Permission.speech,
    ];
    // bool isAllGranted = true;
    // for (var permission in permissions) {
    //   final state = await permission.request();
    //   isAllGranted = isAllGranted && state.isGranted;
    // }
    // if (isAllGranted) {
    //   onGranted?.call();
    // }

    await batchRequestAndCheckPermissions(permissions);
  }

  static Future<bool> media() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
    ];
    // bool isAllGranted = true;
    // for (var permission in permissions) {
    //   final state = await permission.request();
    //   isAllGranted = isAllGranted && state.isGranted;
    // }

    // return Future.value(isAllGranted);

    return await batchRequestAndCheckPermissions(permissions);
  }

  static void storageAndMicrophone(Function()? onGranted) async {
    final permissions = await overAndroid13()
        ? [
            Permission.microphone,
          ]
        : [
            Permission.storage,
            Permission.microphone,
            // Permission.speech,
          ];
    // bool isAllGranted = true;
    // for (var permission in permissions) {
    //   final state = await permission.request();
    //   isAllGranted = isAllGranted && state.isGranted;
    // }
    // if (isAllGranted) {
    //   onGranted?.call();
    // }

    await batchRequestAndCheckPermissions(permissions, onAgree: onGranted);
  }

  static Future<Map<Permission, PermissionStatus>> request(
      List<Permission> permissions) async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }

  static void requestBasePermissions() async {
    final permissions = [
      Permission.photos,
      Permission.audio,
      Permission.videos,
      Permission.manageExternalStorage,
      Permission.scheduleExactAlarm,
      Permission.phone,
      Permission.sms,
      Permission.ignoreBatteryOptimizations,
      Permission.systemAlertWindow,
      Permission.requestInstallPackages,
      Permission.accessNotificationPolicy,
      Permission.notification,
      Permission.location,
      Permission.reminders,
      Permission.criticalAlerts,
      if (!(await overAndroid13())) Permission.storage,
      Permission.camera,
      Permission.microphone,
    ];

    for (var permission in permissions) {
      PermissionStatus status = await permission.status;
      if (!status.isGranted) {
        await permission.request();
      }
    }
  }

  static Future<void> batchRequestPermissions(
      List<Permission> permissions) async {
    for (final permission in permissions) {
      PermissionStatus status = await permission.status;
      if (!status.isGranted) {
        await permission.request();
      }
    }
  }

  static Future<bool> batchCheckPermissions(
      List<Permission> permissions) async {
    bool agree = true;
    final map = {};
    for (final permission in permissions) {
      PermissionStatus status = await permission.status;
      map[permission.toString()] = status.toString();
      if (![
        PermissionStatus.granted,
        PermissionStatus.provisional,
        PermissionStatus.limited
      ].contains(status)) {
        agree = false;
      }
    }
    myLogger.w({"message": "权限检查", "data": map});
    return agree;
  }

  static Future<bool> batchRequestAndCheckPermissions(
      List<Permission> permissions,
      {Function()? onAgree,
      Function()? onDisagree,
      Future<dynamic> Function()? onAgreeAsync,
      Future<dynamic> Function()? onDisAgreeAsync}) async {
    await batchRequestPermissions(permissions);
    bool isAgree = await batchCheckPermissions(permissions);
    if (isAgree) {
      onAgree?.call();
      await onAgreeAsync?.call();
    } else {
      await onDisagree?.call();
      await onDisAgreeAsync?.call();
    }
    return isAgree;
  }

  static Future<bool> checkStorageV2(List<Permission>? permissions) async {
    if (await overAndroid13()) {
      if (null == permissions) return true;
      // PermissionStatus status;
      // for (final permission in permissions) {
      //   status = await permission.status;
      //   if (![
      //     PermissionStatus.granted,
      //     PermissionStatus.provisional,
      //     PermissionStatus.limited
      //   ].contains(status)) {
      //     return false;
      //   }
      // }
      // return true;
      return batchCheckPermissions(permissions);
    } else {
      // return await Permission.storage.isGranted;
      return await batchCheckPermissions([Permission.storage]);
    }
  }

  static Future<List<PermissionStatus>> getPermissionsStatus(
      List<Permission> permissions) async {
    return await Future.wait(
        permissions.map((item) async => await item.status).toList());
  }

  static void openSettings() async {
    await openAppSettings();
  }
}
