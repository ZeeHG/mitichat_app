import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../chat_logic.dart';

class SetBackgroundImageLogic extends GetxController {
  // final chatLogic = Get.find<ChatLogic>();
  final chatLogic = Get.find<ChatLogic>(tag: GetTags.chat);

  void selectPicture() {
    IMViews.openPhotoSheet(
      toUrl: false,
      items: [
        if (chatLogic.background.isNotEmpty)
          SheetItem(
            label: StrRes.reset,
            textStyle: Styles.ts_FF381F_17sp,
            onTap: recover,
          )
      ],
      onData: (path, url) async {
        if (path != null) {
          chatLogic.changeBackground(path);
        }
      },
    );
  }

  recover() {
    chatLogic.clearBackground();
  }
}
