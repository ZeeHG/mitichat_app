import 'dart:async';
import 'dart:math';

import 'package:collection/collection.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

import '../../../../core/ctrl/im_ctrl.dart';

enum GroupMemberOpType {
  view,
  transferRight,
  call,
  at,
  del,
}

class GroupMemberListLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final controller = RefreshController();
  final memberList = <GroupMembersInfo>[].obs;
  final checkedList = <GroupMembersInfo>[].obs;
  final count = 20;
  final myGroupMemberLevel = 1.obs;
  late GroupInfo groupInfo;
  late GroupMemberOpType opType;
  late StreamSubscription mISub;

  /// 多选模式
  bool get isMultiSelMode =>
      opType == GroupMemberOpType.call ||
      opType == GroupMemberOpType.at ||
      opType == GroupMemberOpType.del;

  /// 需要移除自己
  bool get excludeSelfFromList =>
      opType == GroupMemberOpType.call ||
      opType == GroupMemberOpType.at ||
      opType == GroupMemberOpType.transferRight;

  bool get isDelMember => opType == GroupMemberOpType.del;

  bool get isAdmin => myGroupMemberLevel.value == GroupRoleLevel.admin;

  bool get isOwner => myGroupMemberLevel.value == GroupRoleLevel.owner;

  bool get isOwnerOrAdmin => isAdmin || isOwner;

  int get maxLength => min(groupInfo.memberCount!, 999);

  @override
  void onClose() {
    mISub.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    groupInfo = Get.arguments['groupInfo'];
    opType = Get.arguments['opType'];
    mISub = imCtrl.memberInfoChangedSubject.listen(_updateMemberLevel);
    _queryMyGroupMemberLevel();
    super.onInit();
  }

  void _updateMemberLevel(GroupMembersInfo e) {
    if (e.groupID == groupInfo.groupID) {
      equal(GroupMembersInfo el) => el.userID == e.userID;
      final member = memberList.firstWhereOrNull(equal);
      if (null != member && e.roleLevel != member.roleLevel) {
        member.roleLevel = e.roleLevel;
        // memberList.refresh();
      }
      memberList.sort((a, b) {
        if (a.roleLevel == b.roleLevel) {
          return a.joinTime! > b.joinTime! ? -1 : 1;
        } else {
          return a.roleLevel! > b.roleLevel! ? -1 : 1;
        }
      });
    }
  }

  void _queryMyGroupMemberLevel() async {
    LoadingView.singleton.start(fn: () async {
      final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: groupInfo.groupID,
        userIDList: [OpenIM.iMManager.userID],
      );
      final myInfo = list.firstOrNull;
      if (null != myInfo) {
        myGroupMemberLevel.value = myInfo.roleLevel ?? 1;
      }
      onLoad();
    });
  }

  Future<List<GroupMembersInfo>> _getGroupMembers() =>
      OpenIM.iMManager.groupManager.getGroupMemberList(
        groupID: groupInfo.groupID,
        count: count,
        offset: memberList.length,
        filter: isDelMember ? (isOwner ? 4 : (isAdmin ? 3 : 0)) : 0,
      );

  onLoad() async {
    final list = await _getGroupMembers();
    memberList.addAll(list);
    if (list.length < count) {
      controller.loadNoData();
    } else {
      controller.loadComplete();
    }
  }

  bool isChecked(GroupMembersInfo membersInfo) =>
      checkedList.contains(membersInfo);

  clickMember(GroupMembersInfo membersInfo) async {
    if (opType == GroupMemberOpType.transferRight) {
      _transferGroupRight(membersInfo);
      return;
    }
    if (isMultiSelMode) {
      if (isChecked(membersInfo)) {
        checkedList.remove(membersInfo);
      } else {
        checkedList.add(membersInfo);
      }
    } else {
      viewMemberInfo(membersInfo);
    }
  }

  static _transferGroupRight(GroupMembersInfo membersInfo) async {
    var confirm = await Get.dialog(CustomDialog(
      title: sprintf(
          StrLibrary.confirmTransferGroupToUser, [membersInfo.nickname]),
    ));
    if (confirm == true) {
      Get.back(result: membersInfo);
    }
  }

  void removeSelectedMember(GroupMembersInfo membersInfo) {
    checkedList.remove(membersInfo);
  }

  viewMemberInfo(GroupMembersInfo membersInfo) =>
      AppNavigator.startUserProfilePane(
        userID: membersInfo.userID!,
        groupID: membersInfo.groupID,
        nickname: membersInfo.nickname,
        faceURL: membersInfo.faceURL,
      );

  void addOrDelMember() async {
    await Get.bottomSheet(
      barrierColor: StylesLibrary.c_191919_opacity50,
      BottomSheetView(
        items: [
          SheetItem(label: StrLibrary.addMember, result: 0),
          if (isOwnerOrAdmin)
            SheetItem(
              label: StrLibrary.delMember,
              result: 1,
              textStyle: StylesLibrary.ts_FF4E4C_17sp,
            ),
        ],
      ),
    );
  }

  void search() async {
    final memberInfo = await AppNavigator.startSearchGroupMember(
      groupInfo: groupInfo,
      opType: opType,
    );
    if (opType == GroupMemberOpType.transferRight) {
      Get.back(result: memberInfo);
    } else if (isMultiSelMode) {
      clickMember(memberInfo);
    }
  }

  static _buildEveryoneMemberInfo() => GroupMembersInfo(
        userID: OpenIM.iMManager.conversationManager.atAllTag,
        nickname: StrLibrary.everyone,
      );

  void selectEveryone() {
    // checkedList.add(_buildEveryoneMemberInfo());
    // confirmSelectedMember();
    Get.back(result: <GroupMembersInfo>[_buildEveryoneMemberInfo()]);
  }

  void confirmSelectedMember() {
    Get.back(result: checkedList);
  }

  bool hiddenMember(GroupMembersInfo membersInfo) =>
      excludeSelfFromList && membersInfo.userID == OpenIM.iMManager.userID;
}
