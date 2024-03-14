import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/controller/app_controller.dart';
import '../../../core/controller/im_controller.dart';

import 'dart:convert';
import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';
import '../../../core/controller/im_controller.dart';
import '../../../core/controller/push_controller.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as path_package;

class AboutUsLogic extends GetxController {
  final version = "".obs;
  final buildNumber = "".obs;
  final appName = "App".obs;
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final uploadLogsProgress = (0.0).obs;
  final cid = "".obs;
  final pushLogic = Get.find<PushController>();
  final betaTestLogic = Get.find<BetaTestLogic>();
  final appCommonLogic = Get.find<AppCommonLogic>();
  final showDev = false.obs;

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    appName.value = packageInfo.appName;
    buildNumber.value = packageInfo.buildNumber;
  }

  // void checkUpdate() {
  //   appLogic.checkUpdate();
  // }

  void uploadLogs() async {
    try {
      uploadLogsProgress.value = 0.01;
      OpenIM.iMManager
          .uploadLogs()
          .then((value) => IMViews.showToast(StrLibrary.uploaded));

      imLogic.onUploadProgress = (current, size) {
        uploadLogsProgress.value = current / size;
      };
    } catch (e, s) {
      IMViews.showToast(StrLibrary.uploadFail);
      myLogger.e({"message": "uploadLogs, 上传IM日志出错", "error": e, "stack": s});
    }
  }

  void startDev() {
    // if (betaTestLogic.isDevUser(imLogic.userInfo.value.userID!) ||
    //     betaTestLogic.isTestUser(imLogic.userInfo.value.userID!)) {
    //   showDev.value = true;
    // }
    showDev.value = true;
  }

  void uploadLogsByDate([String? date]) async {
    try {
      var dateStr = "open-im-sdk-core.${date ?? myLoggerDateStr}";
      var result = await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.uploadFile(
          id: const Uuid().v4(),
          filePath: Config.cachePath + dateStr,
          fileName: (imLogic.userInfo.value.userID ?? "null") +
              "_im_" +
              dateStr +
              "_${appCommonLogic.deviceModel}_" +
              DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()) +
              ".log",
        ),
      );
      IMViews.showToast(StrLibrary.uploaded);
      if (result is String) {
        String url = jsonDecode(result)['url'];
        IMUtils.copy(text: !url.isEmpty ? url : "log url is not empty");
      } else {
        IMViews.showToast(StrLibrary.copyFail);
      }
    } catch (e, s) {
      IMViews.showToast(StrLibrary.uploadFail);
      myLogger.e({
        "message": "uploadLogsByDate, 上传IM日志(按日期)出错",
        "error": {"date": "${date ?? myLoggerDateStr}", "error": e, "stack": s}
      });
    }
  }

  Future<String?> uploadAppLogsByDate(
      {Map<String, String>? logInfo,
      bool toast = true,
      bool copy = true}) async {
    try {
      var fn = () => OpenIM.iMManager.uploadFile(
            id: const Uuid().v4(),
            filePath: logInfo?["path"] ?? myLoggerPath,
            fileName: (imLogic.userInfo.value.userID ?? "null") +
                "_app_" +
                (logInfo?["date"] ?? myLoggerDateStr) +
                "_${appCommonLogic.deviceModel}_" +
                DateFormat('yyyy-MM-dd_HH-mm-ss').format(DateTime.now()) +
                ".log",
          );
      var result;
      if (null != logInfo) {
        result = await fn();
      } else {
        result = await LoadingView.singleton.start(
          fn: fn,
        );
      }
      if (toast) IMViews.showToast(StrLibrary.uploaded);
      if (result is String) {
        String url = jsonDecode(result)['url'];
        if (copy) IMUtils.copy(text: !url.isEmpty ? url : "url is not empty");
        return url;
      } else {
        if (toast) IMViews.showToast(StrLibrary.copyFail);
      }
    } catch (e, s) {
      if (toast) IMViews.showToast(StrLibrary.uploadFail);
      myLogger.e({
        "message": "uploadAppLogs, 上传APP日志(按日期)出错",
        "error": {
          "date": "${logInfo?["date"] ?? myLoggerDateStr}",
          "error": e,
          "stack": s
        }
      });
    }
  }

  // 2000-01-01.log, 上传最新的日志不要同时修改日志, md5有可能会校验不正确
  void uploadAppLogs() async {
    final logDir = Directory(myLoggerDirPath);
    List<FileSystemEntity> files =
        logDir.listSync(recursive: false, followLinks: false);
    var logInfoList = [];
    for (FileSystemEntity file in files) {
      if (path_package.basename(file.path).contains('.log')) {
        logInfoList.insert(0, {
          "path": file.path,
          "date": path_package.basenameWithoutExtension(file.path)
        });
      }
    }
    var result = [];
    try {
      result = await LoadingView.singleton.start(
          fn: () => Future.wait(logInfoList
              .map((logInfo) => uploadAppLogsByDate(
                  logInfo: logInfo, toast: false, copy: false))
              .toList()));
    } finally {
      // IMViews.showToast(StrLibrary .uploaded);
      IMUtils.copy(text: result.join(", "));
    }
  }

  @override
  void onReady() async {
    getPackageInfo();
    cid.value = await pushLogic.getClientId();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
