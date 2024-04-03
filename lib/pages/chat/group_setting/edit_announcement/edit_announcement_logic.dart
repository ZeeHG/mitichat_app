import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class EditGroupAnnouncementLogic extends GetxController {
  // final groupSetupLogic = Get.find<ChatSettingLogic>();
  final inputCtrl = TextEditingController();
  final focusNode = FocusNode();
  final onlyRead = true.obs;
  final updateMember = GroupMembersInfo().obs;
  late Rx<GroupInfo> groupInfo;
  final hasEditPermissions = false.obs;

  String? get ntfUpdateUserID => groupInfo.value.notificationUserID;

  @override
  void onInit() {
    groupInfo = Rx(GroupInfo.fromJson({"groupID": Get.arguments}));
    _queryGroupInfo();
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  void _queryGroupInfo() async {
    var list = await LoadingView.singleton.start(
      fn: () => OpenIM.iMManager.groupManager.getGroupsInfo(
        groupIDList: [groupInfo.value.groupID],
      ),
    );
    var info = list.firstOrNull;
    groupInfo.update((val) {
      val?.groupName = info?.groupName;
      val?.notification = info?.notification;
      val?.introduction = info?.introduction;
      val?.faceURL = info?.faceURL;
      val?.ownerUserID = info?.ownerUserID;
      val?.createTime = info?.createTime;
      val?.memberCount = info?.memberCount;
      val?.status = info?.status;
      val?.creatorUserID = info?.creatorUserID;
      val?.groupType = info?.groupType;
      val?.ex = info?.ex;
      val?.needVerification = info?.needVerification;
      val?.lookMemberInfo = info?.lookMemberInfo;
      val?.applyMemberFriend = info?.applyMemberFriend;
      val?.notificationUpdateTime = info?.notificationUpdateTime;
      val?.notificationUserID = info?.notificationUserID;
    });
    inputCtrl.text = groupInfo.value.notification ?? '';
    _queryNoticeUpdateMember();
  }

  void _queryNoticeUpdateMember() async {
    bool isSelf = ntfUpdateUserID == OpenIM.iMManager.userID;
    final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
      groupID: groupInfo.value.groupID,
      userIDList: [
        if (null != ntfUpdateUserID) ntfUpdateUserID!,
        if (!isSelf) OpenIM.iMManager.userID
      ],
    );
    final user = list.firstWhereOrNull((e) => e.userID == ntfUpdateUserID);
    if (null != user) {
      updateMember.update((val) {
        val?.nickname = user.nickname;
        val?.faceURL = user.faceURL;
      });
    }
    final me =
        list.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID);
    hasEditPermissions.value =
        [GroupRoleLevel.admin, GroupRoleLevel.owner].contains(me?.roleLevel);
  }

  editing() {
    onlyRead.value = false;
    Future.delayed(
        const Duration(milliseconds: 20), () => focusNode.requestFocus());
  }

  void publish() async {
    await LoadingView.singleton.start(
      fn: () async {
        await OpenIM.iMManager.groupManager.setGroupInfo(GroupInfo(
            groupID: groupInfo.value.groupID,
            notification: inputCtrl.text.trim()));
        groupInfo.update((val) {
          val?.notification = inputCtrl.text.trim();
        });
        Get.back();
      },
    );
  }
}
