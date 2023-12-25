import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';

class Permissions {
  Permissions._();

  static Future<bool> checkSystemAlertWindow() async {
    return Permission.systemAlertWindow.isGranted;
  }

  static Future<bool> checkStorage() async {
    return await Permission.storage.isGranted;
  }

  static void camera(Function()? onGranted) async {
    if (await Permission.camera.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.camera.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void storage(Function()? onGranted) async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void manageExternalStorage(Function()? onGranted) async {
    if (await Permission.manageExternalStorage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void microphone(Function()? onGranted) async {
    if (await Permission.microphone.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.microphone.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void location(Function()? onGranted) async {
    if (await Permission.location.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.location.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void speech(Function()? onGranted) async {
    if (await Permission.speech.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.speech.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void photos(Function()? onGranted) async {
    if (await Permission.photos.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.photos.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static Future<bool> notification() async {
    if (await Permission.notification.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      return true;
    }
    if (await Permission.notification.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }

    return false;
  }

  static void ignoreBatteryOptimizations(Function()? onGranted) async {
    if (await Permission.ignoreBatteryOptimizations.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.ignoreBatteryOptimizations.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }
  }

  static void cameraAndMicrophone(Function()? onGranted) async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      // Permission.speech,
    ];
    bool isAllGranted = true;
    for (var permission in permissions) {
      final state = await permission.request();
      isAllGranted = isAllGranted && state.isGranted;
    }
    if (isAllGranted) {
      onGranted?.call();
    }
  }

  static Future<bool> media() async {
    final permissions = [
      Permission.camera,
      Permission.microphone,
      Permission.photos,
    ];
    bool isAllGranted = true;
    for (var permission in permissions) {
      final state = await permission.request();
      isAllGranted = isAllGranted && state.isGranted;
    }

    return Future.value(isAllGranted);
  }

  static void storageAndMicrophone(Function()? onGranted) async {
    final permissions = [
      Permission.storage,
      Permission.microphone,
      // Permission.speech,
    ];
    bool isAllGranted = true;
    for (var permission in permissions) {
      final state = await permission.request();
      isAllGranted = isAllGranted && state.isGranted;
    }
    if (isAllGranted) {
      onGranted?.call();
    }
  }

  static Future<Map<Permission, PermissionStatus>> request(List<Permission> permissions) async {
    // You can request multiple permissions at once.
    Map<Permission, PermissionStatus> statuses = await permissions.request();
    return statuses;
  }




  static void storage2(Function()? onGranted, Function()? onFinally) async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
      onGranted?.call();
    }
    if (await Permission.storage.isPermanentlyDenied) {
      // The user opted to never again see the permission request dialog for this
      // app. The only way to change the permission's status now is to let the
      // user manually enable it in the system settings.
    }

    onFinally?.call();
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
      Permission.storage,
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
    for (var permission in permissions) {
      PermissionStatus status = await permission.status;
      if (!status.isGranted) {
        await permission.request();
      }
    }
  }

  static Future<List<PermissionStatus>> getPermissionsStatus(
      List<Permission> permissions) async {
    return await Future.wait(
        permissions.map((item) async => await item.status).toList());
  }

  // 存储兼容性测试, 不判断isGranted, 一加等机型缺少storage一直为false
  static Future<void> requestStorage([Function()? onGranted]) async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        // use [Permissions.storage.status]
        await batchRequestPermissions([Permission.storage]);
      } else {
        // use [Permissions.photos.status]
        await batchRequestPermissions(
            [Permission.photos, Permission.audio, Permission.videos, Permission.storage]);
      }
    } else {
      await batchRequestPermissions([Permission.storage]);
    }
    onGranted?.call();
  }

  static void openSettings() async {
    await openAppSettings();
  }
}
