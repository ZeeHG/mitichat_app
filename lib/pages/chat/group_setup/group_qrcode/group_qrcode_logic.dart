import 'package:get/get.dart';
import 'package:miti/pages/chat/group_setup/group_setup_logic.dart';
import 'package:miti_common/miti_common.dart';

class GroupQrcodeLogic extends GetxController {
  final groupSetupLogic = Get.find<GroupSetupLogic>();

  String buildQRContent() {
    return '${Config.groupScheme}${groupSetupLogic.groupInfo.value.groupID}';
  }
}
