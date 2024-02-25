import 'package:flutter/services.dart';
import 'package:flutter_background/flutter_background.dart';
import 'package:openim_common/utils/logger.dart';

Future<void> requestBackgroundPermission(
    {bool isRetry = false,
    bool shouldRequestBatteryOptimizationsOff = false}) async {
  try {
    bool hasPermissions = await FlutterBackground.hasPermissions;
    final androidConfig = FlutterBackgroundAndroidConfig(
        notificationTitle: "miti",
        notificationText: "running....",
        notificationImportance: AndroidNotificationImportance.Default,
        notificationIcon:
            const AndroidResource(name: 'ic_launcher', defType: 'mipmap'),
        shouldRequestBatteryOptimizationsOff:
            shouldRequestBatteryOptimizationsOff);
    if (!isRetry) {
      hasPermissions =
          await FlutterBackground.initialize(androidConfig: androidConfig);
    }
    if (hasPermissions && !FlutterBackground.isBackgroundExecutionEnabled) {
      await FlutterBackground.enableBackgroundExecution();
    }
  } catch (e) {
    // The battery optimizations are not turned off.
    myLogger.e(e);
    if (e is PlatformException && (e.message ?? "").contains("battery")) {
      return await Future<void>.delayed(
          const Duration(seconds: 3),
          () => requestBackgroundPermission(
              isRetry: false, shouldRequestBatteryOptimizationsOff: false));
    } else if (!isRetry) {
      return await Future<void>.delayed(const Duration(seconds: 3),
          () => requestBackgroundPermission(isRetry: true));
    }
  }
  myLogger.i(
      {"message": "启动后台服务, ${FlutterBackground.isBackgroundExecutionEnabled}"});
}
