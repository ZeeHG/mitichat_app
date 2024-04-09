import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/chat/group_setting/group_setting_logic.dart';
import 'package:miti_common/miti_common.dart';

enum EditNameType {
  myGroupMemberNickname,
  groupNickname,
}

class EditGroupNameLogic extends GetxController {
  final groupSetupLogic = Get.find<GroupChatSettingLogic>();
  late TextEditingController inputCtrl;
  late EditNameType type;

  @override
  void onInit() {
    type = Get.arguments['type'];
    inputCtrl = TextEditingController(
      text: type == EditNameType.groupNickname
          ? groupSetupLogic.groupInfo.value.groupName
          : groupSetupLogic.myGroupMembersInfo.value.nickname,
    );
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  String? get title => type == EditNameType.myGroupMemberNickname
      ? StrLibrary.myGroupMemberNickname
      : StrLibrary.changeGroupName;

  void save() async {
    await LoadingView.singleton.start(fn: () async {
      if (type == EditNameType.myGroupMemberNickname) {
        await OpenIM.iMManager.groupManager.setGroupMemberNickname(
            groupID: groupSetupLogic.groupInfo.value.groupID,
            userID: OpenIM.iMManager.userID,
            groupNickname: inputCtrl.text.trim());
      } else if (type == EditNameType.groupNickname) {
        await OpenIM.iMManager.groupManager.setGroupInfo(GroupInfo(
            groupID: groupSetupLogic.groupInfo.value.groupID,
            groupName: inputCtrl.text.trim()));
      }
      showToast(StrLibrary.setSuccessfully);
      Get.back();
    });
  }
}
