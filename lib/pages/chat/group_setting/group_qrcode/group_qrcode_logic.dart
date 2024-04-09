import 'package:get/get.dart';
import 'package:miti/pages/chat/group_setting/group_setting_logic.dart';
import 'package:miti_common/miti_common.dart';

class GroupQrcodeLogic extends GetxController {
  final groupSetupLogic = Get.find<GroupChatSettingLogic>();

  String buildQRContent() {
    return '${Config.groupScheme}${groupSetupLogic.groupInfo.value.groupID}';
  }
}
