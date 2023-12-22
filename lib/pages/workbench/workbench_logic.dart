import 'dart:io';

// import 'package:flutter_openim_unimp/flutter_openim_unimp.dart';
import 'package:get/get.dart';
import 'package:openim/core/controller/app_controller.dart';
import 'package:openim_common/openim_common.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WorkbenchLogic extends GetxController {
  final refreshCtrl = RefreshController();
  final appLogic = Get.find<AppController>();
  final list = <Rx<UniMPInfo>>[].obs;
  final url = ''.obs;

  @override
  void onReady() {
    // refreshList();
    super.onReady();

    final temp = appLogic.clientConfigMap['discoverPageURL'];

    if (temp == null) {
      appLogic.queryClientConfig().then((value) {
        if (value['discoverPageURL'] == null) {
          url.value = 'https://www.openim.io';
        } else {
          url.value = value['discoverPageURL'];
        }
      });
    } else {
      url.value = temp;
    }
  }

  void refreshList() async {
    try {
      final list = await Apis.queryUniMPList();
      this.list.assignAll(list.map((e) => e.obs));
    } catch (e, s) {
      Logger.print('$e $s');
    }
    refreshCtrl.refreshCompleted();
  }

  void startUniMP(Rx<UniMPInfo> uniMPInfo) {
    Permissions.storage(() async {
      if (uniMPInfo.value.url != null) {
        final dir = "${(await getTemporaryDirectory()).absolute.path}/unimp/";
        final url = uniMPInfo.value.url;
        final size = uniMPInfo.value.size;
        final appID = uniMPInfo.value.appID;
        // "http://203.56.175.233:21376/__UNI__7460850.wgt",
        // final key = base64Encode(utf8.encode(uniMPInfo.value.url!));
        // final appID = '_uni__$key';
        final wgtPath = '$dir$appID.wgt';
        final file = File(wgtPath);
        if ((await file.exists()) && ((await file.length()) == size)) {
          openMinMP(appID!, wgtPath);
        } else {
          if (uniMPInfo.value.progress == 0 || uniMPInfo.value.progress == null) {
            HttpUtil.download(
              url!,
              cachePath: wgtPath,
              onProgress: (int count, int total) {
                final length = total < 0 ? size! : total;
                uniMPInfo.update((val) {
                  val?.progress = ((count / length) * 100).toInt();
                  if (count == length) {
                    openMinMP(appID!, wgtPath);
                  }
                });
              },
            ).catchError((_) {
              uniMPInfo.value.progress = 0;
              IMViews.showToast('下载失败！');
            });
          }
        }
      }
    });
  }

  void openMinMP(String appID, String wgtPath) async {
    // final success = await FlutterOpenimUnimp().releaseWgtToRunPath(
    //   appID: appID,
    //   wgtPath: wgtPath,
    // );
    // if (success == true) {
    //   FlutterOpenimUnimp().openUniMP(appID: appID);
    // }
  }
}
