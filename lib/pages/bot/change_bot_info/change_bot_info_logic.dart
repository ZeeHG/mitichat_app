import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class ChangeBotInfoLogic extends GetxController {
  final name = TextEditingController();

  void openPhotoSheet() {
    IMViews.openPhotoSheet(
        onData: (path, url) async {
          if (url != null) {
            LoadingView.singleton.start(fn: () => Future(() => 1));
          }
        },
        quality: 15);
  }
}
