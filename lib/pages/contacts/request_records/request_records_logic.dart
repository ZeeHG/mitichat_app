import 'dart:async';

import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/ctrl/im_ctrl.dart';
import '../../home/home_logic.dart';

class RequestRecordsLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final homeLogic = Get.find<HomeLogic>();
  final friendApplicationList = <FriendApplicationInfo>[].obs;
  late StreamSubscription faSub;
  final groupApplicationList = <GroupApplicationInfo>[].obs;
  final groupList = <String, GroupInfo>{}.obs;
  final memberList = <GroupMembersInfo>[].obs;
  final userInfoList = <UserInfo>[].obs;
  final allList = <dynamic>[].obs;

  @override
  void onInit() {
    super.onInit();
    getData();
    faSub = imCtrl.friendApplicationChangedSubject.listen((value) {
      getFriendRequestsList();
    });
  }

  @override
  void onClose() {
    super.onClose();
    faSub.cancel();
    homeLogic.getUnhandledFriendApplicationCount();
    homeLogic.getUnhandledGroupApplicationCount();
  }

  getData() async {
    await LoadingView.singleton.start(fn: () async {
      await Future.wait(
          [getFriendRequestsList(), getApplicationList(), getJoinedGroup()]);

      sortAllList();
    });
  }

  sortAllList() {
    allList.clear();
    allList
      ..addAll(friendApplicationList)
      ..addAll(groupApplicationList);

    allList.sort((a, b) {
      if (a.createTime! > b.createTime!) {
        return -1;
      } else if (a.createTime! < b.createTime!) {
        return 1;
      }
      return 0;
    });
  }

  /// 获取好友申请列表
  Future<void> getFriendRequestsList() async {
    final list = await Future.wait([
      OpenIM.iMManager.friendshipManager.getFriendApplicationListAsRecipient(),
      OpenIM.iMManager.friendshipManager.getFriendApplicationListAsApplicant(),
    ]);

    final allList = <FriendApplicationInfo>[];
    allList
      ..addAll(list[0])
      ..addAll(list[1]);

    var haveReadList = DataSp.getHaveReadUnHandleFriendApplication();
    haveReadList ??= <String>[];
    for (var e in list[0]) {
      var id = MitiUtils.buildFriendApplicationID(e);
      if (!haveReadList.contains(id)) {
        haveReadList.add(id);
      }
    }
    DataSp.putHaveReadUnHandleFriendApplication(haveReadList);
    friendApplicationList.assignAll(allList);
    sortAllList();
  }

  bool isISendRequest(FriendApplicationInfo info) =>
      info.fromUserID == OpenIM.iMManager.userID;

  /// 接受好友申请
  void acceptFriendApplication(FriendApplicationInfo info) =>
      AppNavigator.startHandleFriendRequests(
        applicationInfo: info,
      );

  bool isInvite(GroupApplicationInfo info) {
    if (info.joinSource == 2) {
      return info.inviterUserID != null && info.inviterUserID!.isNotEmpty;
    }
    return false;
  }

  Future<void> getApplicationList() async {
    final list = await LoadingView.singleton.start(fn: () async {
      final list = await Future.wait([
        OpenIM.iMManager.groupManager.getGroupApplicationListAsRecipient(),
        OpenIM.iMManager.groupManager.getGroupApplicationListAsApplicant(),
      ]);

      final allList = <GroupApplicationInfo>[];
      allList
        ..addAll(list[0])
        ..addAll(list[1]);

      var map = <String, List<String>>{};
      var inviterList = <String>[];
      // 统计未查看的群申请数量
      var haveReadList = DataSp.getHaveReadUnHandleGroupApplication();
      haveReadList ??= <String>[];
      for (var a in list[0]) {
        var id = MitiUtils.buildGroupApplicationID(a);
        if (!haveReadList.contains(id)) {
          haveReadList.add(id);
        }
      }
      DataSp.putHaveReadUnHandleGroupApplication(haveReadList);

      // 记录邀请者id
      for (var a in allList) {
        if (isInvite(a)) {
          if (!map.containsKey(a.groupID)) {
            map[a.groupID!] = [a.inviterUserID!];
          } else {
            if (!map[a.groupID!]!.contains(a.inviterUserID!)) {
              map[a.groupID!]!.add(a.inviterUserID!);
            }
          }
          if (!inviterList.contains(a.inviterUserID!)) {
            inviterList.add(a.inviterUserID!);
          }
        }
      }

      // 查询邀请者的群成员信息
      if (map.isNotEmpty) {
        await Future.wait(map.entries.map((e) => OpenIM.iMManager.groupManager
            .getGroupMembersInfo(groupID: e.key, userIDList: e.value)
            .then((list) => memberList.assignAll(list))));
      }

      // 查询邀请者的用户信息
      if (inviterList.isNotEmpty) {
        final list = await OpenIM.iMManager.userManager
            .getUsersInfo(userIDList: inviterList);
        userInfoList.assignAll(list.map((e) => e.simpleUserInfo).toList());
      }

      return allList;
    });
    groupApplicationList.assignAll(list);
  }

  Future<void> getJoinedGroup() async {
    final list = await OpenIM.iMManager.groupManager.getJoinedGroupList();
    final map = <String, GroupInfo>{};
    for (var e in list) {
      map[e.groupID] = e;
    }
    groupList.addAll(map);
  }

  String getGroupName(GroupApplicationInfo info) =>
      info.groupName ?? groupList[info.groupID]?.groupName ?? '';

  String getInviterNickname(GroupApplicationInfo info) =>
      (getMemberInfo(info.inviterUserID!)?.nickname) ??
      (getUserInfo(info.inviterUserID!)?.nickname) ??
      '-';

  GroupMembersInfo? getMemberInfo(inviterUserID) =>
      memberList.firstWhereOrNull((e) => e.userID == inviterUserID);

  UserInfo? getUserInfo(inviterUserID) =>
      userInfoList.firstWhereOrNull((e) => e.userID == inviterUserID);

  void handle(GroupApplicationInfo info) async {
    final result =
        await AppNavigator.startHandleGroupRequests(applicationInfo: info);
    if (result is int) {
      info.handleResult = result;
      groupApplicationList.refresh();
      sortAllList();
      allList.refresh();
    }
  }
}
