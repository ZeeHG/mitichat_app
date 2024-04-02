import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/chat/group_setup/group_setup_logic.dart';
import 'package:miti_common/miti_common.dart';

import '../../../../routes/app_navigator.dart';
import '../group_member_list/group_member_list_logic.dart';

class GroupManageLogic extends GetxController {
  final groupSetupLogic = Get.find<GroupSetupLogic>();

  Rx<GroupInfo> get groupInfo => groupSetupLogic.groupInfo;

  bool get allowLookProfiles => groupInfo.value.lookMemberInfo == 1;

  bool get allowAddFriend => groupInfo.value.applyMemberFriend == 1;

  void toggleGroupMute() {
    LoadingView.singleton.start(fn: () async {
      await OpenIM.iMManager.groupManager.changeGroupMute(
        groupID: groupInfo.value.groupID,
        mute: !(groupInfo.value.status == 3),
      );
    });
  }

  /// 不允许通过群获取成员资料 0：关闭，1：打开
  void toggleMemberProfiles() async {
    await LoadingView.singleton.start(
      fn: () => OpenIM.iMManager.groupManager.setGroupLookMemberInfo(
        groupID: groupInfo.value.groupID,
        status: !allowLookProfiles ? 1 : 0,
      ),
    );
  }

  /// 0：关闭，1：打开
  void toggleAddMemberToFriend() async {
    await LoadingView.singleton.start(
      fn: () => OpenIM.iMManager.groupManager.setGroupApplyMemberFriend(
        groupID: groupInfo.value.groupID,
        status: !allowAddFriend ? 1 : 0,
      ),
    );
  }

  void modifyJoinGroupSet() async {
    final index = await Get.bottomSheet(
      barrierColor: Styles.c_191919_opacity50,
      BottomSheetView(
        items: [
          SheetItem(
            label: StrLibrary.allowAnyoneJoinGroup,
            result: 0,
          ),
          SheetItem(
            label: StrLibrary.inviteNotVerification,
            result: 1,
          ),
          SheetItem(
            label: StrLibrary.needVerification,
            result: 2,
          ),
        ],
      ),
    );
    if (null != index) {
      final value = index == 0
          ? GroupVerification.directly
          : (index == 1
              ? GroupVerification.applyNeedVerificationInviteDirectly
              : GroupVerification.allNeedVerification);
      await LoadingView.singleton.start(
        fn: () async {
          await OpenIM.iMManager.groupManager.setGroupVerification(
            groupID: groupInfo.value.groupID,
            needVerification: value,
          );
          groupInfo.update((val) {
            val?.needVerification = value;
          });
        },
      );
    }
  }

  String get joinGroupOption {
    final value = groupInfo.value.needVerification;
    if (value == GroupVerification.allNeedVerification) {
      return StrLibrary.needVerification;
    } else if (value == GroupVerification.directly) {
      return StrLibrary.allowAnyoneJoinGroup;
    }
    return StrLibrary.inviteNotVerification;
  }

  void transferGroupOwnerRight() async {
    var result = await AppNavigator.startGroupMemberList(
      groupInfo: groupInfo.value,
      opType: GroupMemberOpType.transferRight,
    );
    if (result is GroupMembersInfo) {
      await LoadingView.singleton.start(
        fn: () async {
          await OpenIM.iMManager.groupManager.transferGroupOwner(
            groupID: groupInfo.value.groupID,
            userID: result.userID!,
          );
          groupInfo.update((val) {
            val?.ownerUserID = result.userID;
          });
          Get.back();
        },
      );
    }
  }
}
