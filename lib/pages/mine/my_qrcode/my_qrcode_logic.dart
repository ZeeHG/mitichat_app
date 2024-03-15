import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/ctrl/im_ctrl.dart';

class MyQrcodeLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();

  String buildQRContent() {
    return '${Config.friendScheme}${imCtrl.userInfo.value.userID}';
  }
}
