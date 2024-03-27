import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti_common/miti_common.dart';

class MyQrcodeLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  late final String qrcodeData = '${Config.friendScheme}${imCtrl.userInfo.value.userID}';
}
