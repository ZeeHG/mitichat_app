import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../chat_logic.dart';

class BackgroundSettingLogic extends GetxController {
  // final chatLogic = Get.find<ChatLogic>();
  final chatLogic = Get.find<ChatLogic>(tag: GetTags.chat);

  void selectPicture() {
    IMViews.openPhotoSheet(
      toUrl: false,
      items: [
        if (chatLogic.background.isNotEmpty)
          SheetItem(
            label: StrLibrary.reset,
            textStyle: Styles.ts_FF4E4C_16sp,
            onTap: chatLogic.clearBackground,
          )
      ],
      onData: (path, url) async {
        if (path != null) {
          chatLogic.changeBackground(path);
        }
      },
    );
  }
}
