import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/controller/im_controller.dart';

class MyQrcodeLogic extends GetxController {
  final imLogic = Get.find<IMController>();

  String buildQRContent() {
    return '${Config.friendScheme}${imLogic.userInfo.value.userID}';
  }
}
