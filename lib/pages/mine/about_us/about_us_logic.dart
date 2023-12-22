import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/controller/app_controller.dart';
import '../../../core/controller/im_controller.dart';

class AboutUsLogic extends GetxController {
  final version = "".obs;
  final buildNumber = "".obs;
  final appName = "App".obs;
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final uploadLogsProgress = (0.0).obs;

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version.value = packageInfo.version;
    appName.value = packageInfo.appName;
    buildNumber.value = packageInfo.buildNumber;
  }

  void checkUpdate() {
    appLogic.checkUpdate();
  }

  void uploadLogs() async {
    uploadLogsProgress.value = 0.01;
    OpenIM.iMManager.uploadLogs().then((value) => IMViews.showToast(StrRes.uploaded));

    imLogic.onUploadProgress = (current, size) {
      uploadLogsProgress.value = current / size;
    };
  }

  @override
  void onReady() {
    getPackageInfo();
    super.onReady();
  }

  @override
  void onClose() {
    // TODO: implement onClose
    super.onClose();
  }
}
