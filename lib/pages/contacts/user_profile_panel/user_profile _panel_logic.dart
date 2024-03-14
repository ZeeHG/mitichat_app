import 'dart:async';

import 'package:collection/collection.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_live/miti_live.dart';
import 'package:miti_circle/miti_circle.dart';
import 'package:sprintf/sprintf.dart';

import '../../../core/controller/app_controller.dart';
import '../../../core/controller/im_controller.dart';
import '../../conversation/conversation_logic.dart';

import 'dart:convert';
import 'package:miti_circle/src/w_apis.dart';

class UserProfilePanelLogic extends GetxController {
  final appLogic = Get.find<AppController>();
  final imLogic = Get.find<IMController>();
  final conversationLogic = Get.find<ConversationLogic>();
  late Rx<UserFullInfo> userInfo;
  GroupMembersInfo? groupMembersInfo;
  GroupInfo? groupInfo;
  String? groupID;
  bool? offAllWhenDelFriend = false;
  final iHasMutePermissions = false.obs;
  final iAmOwner = false.obs;
  final mutedTime = "".obs;
  final onlineStatus = false.obs;
  final onlineStatusDesc = ''.obs;
  final groupUserNickname = "".obs;
  final joinGroupTime = 0.obs;
  final joinGroupMethod = ''.obs;
  final hasAdminPermission = false.obs;
  final notAllowLookGroupMemberProfiles = false.obs;
  final notAllowAddGroupMemberFriend = false.obs;
  final iHaveAdminOrOwnerPermission = false.obs;
  late StreamSubscription _friendAddedSub;
  late StreamSubscription _friendInfoChangedSub;
  late StreamSubscription _memberInfoChangedSub;
  final picMetas = <Metas>[].obs;
  final baseDataFinished = false.obs;

  @override
  void onClose() {
    _friendAddedSub.cancel();
    _friendInfoChangedSub.cancel();
    _memberInfoChangedSub.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    userInfo = (UserFullInfo()
          ..userID = Get.arguments['userID']
          ..nickname = Get.arguments['nickname']
          ..faceURL = Get.arguments['faceURL'])
        .obs;
    groupID = Get.arguments['groupID'];
    offAllWhenDelFriend = Get.arguments['offAllWhenDelFriend'];

    _friendAddedSub = imLogic.friendAddSubject.listen((user) {
      if (user.userID == userInfo.value.userID) {
        userInfo.update((val) {
          val?.isFriendship = true;
        });
      }
    });
    _friendInfoChangedSub = imLogic.friendInfoChangedSubject.listen((user) {
      if (user.userID == userInfo.value.userID) {
        userInfo.update((val) {
          val?.nickname = user.nickname;
          val?.faceURL = user.faceURL;
          val?.remark = user.remark;
        });
        // fixme 上面返回不全, 重新请求更新部分字段
        _requestUsersInfo();
      }
    });
    // 禁言时间被改变，或群成员资料改变
    _memberInfoChangedSub = imLogic.memberInfoChangedSubject.listen((value) {
      if (value.userID == userInfo.value.userID) {
        if (null != value.muteEndTime) {
          _calMuteTime(value.muteEndTime!);
        }
        groupUserNickname.value = value.nickname ?? '';
      }
    });
    super.onInit();
  }

  @override
  void onReady() {
    _getUsersInfo();
    _queryGroupInfo();
    _queryGroupMemberInfo();
    _queryWorkingCircleList();
    // _queryUserOnlineStatus();
    super.onReady();
  }

  /// 是当前登录用户的资料页
  bool get isMyself => userInfo.value.userID == OpenIM.iMManager.userID;

  /// 当前是群成员资料页面
  bool get isGroupMemberPage => null != groupID && groupID!.isNotEmpty;

  bool get isFriendship => userInfo.value.isFriendship == true;

  ///用户是否允许添加好友
  bool get isAllowAddFriend => userInfo.value.allowAddFriend == 1;

  /// 是否能给非好友发送消息
  bool get allowSendMsgNotFriend =>
      null == appLogic.clientConfigMap['allowSendMsgNotFriend'] ||
      appLogic.clientConfigMap['allowSendMsgNotFriend'] == '1';

  void _getUsersInfo() {
    LoadingView.singleton.start(fn: _requestUsersInfo);
  }

  Future<void> _requestUsersInfo() async {
    final userID = userInfo.value.userID!;
    final list = await OpenIM.iMManager.userManager.getUsersInfoWithCache(
      [userID],
    );
    final list2 = await Apis.getUserFullInfo(userIDList: [userID]);
    final user = list.firstOrNull;
    final fullInfo = list2?.firstOrNull;

    final isFriendship = user?.friendInfo != null;
    final isBlack = user?.blackInfo != null;

    if (null != user && null != fullInfo) {
      userInfo.update((val) {
        val?.nickname = user.nickname;
        val?.faceURL = user.faceURL;
        val?.remark = user.friendInfo?.remark;
        val?.isBlacklist = isBlack;
        val?.isFriendship = isFriendship;
        val?.allowAddFriend = fullInfo.allowAddFriend;
        val?.gender = fullInfo.gender;
      });
    }

    baseDataFinished.value = true;
  }

  _queryGroupInfo() async {
    if (isGroupMemberPage) {
      var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
        groupIDList: [groupID!],
      );
      groupInfo = list.firstOrNull;
      // 不允许查看群成员资料
      notAllowLookGroupMemberProfiles.value = groupInfo?.lookMemberInfo == 1;
      // 不允许添加组成员为好友
      notAllowAddGroupMemberFriend.value = groupInfo?.applyMemberFriend == 1;
    }
  }

  /// 查询我与当前页面用户的群成员信息
  _queryGroupMemberInfo() async {
    if (isGroupMemberPage) {
      final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
        groupID: groupID!,
        userIDList: [
          userInfo.value.userID!,
          if (!isMyself) OpenIM.iMManager.userID
        ],
      );
      final other =
          list.firstWhereOrNull((e) => e.userID == userInfo.value.userID);
      groupMembersInfo = other;
      groupUserNickname.value = other?.nickname ?? '';
      joinGroupTime.value = other?.joinTime ?? 0;

      _getJoinGroupMethod(other);

      hasAdminPermission.value = other?.roleLevel == GroupRoleLevel.admin;

      // 是我查看其他人的资料
      if (!isMyself) {
        var me =
            list.firstWhereOrNull((e) => e.userID == OpenIM.iMManager.userID);
        // 只有群主可以设置管理员
        iAmOwner.value = me?.roleLevel == GroupRoleLevel.owner;
        // 群主禁言（取消禁言）管理员和普通成员，管理员只能禁言（取消禁言）普通成员
        iHasMutePermissions.value = me?.roleLevel == GroupRoleLevel.owner ||
            (me?.roleLevel == GroupRoleLevel.admin &&
                other?.roleLevel == GroupRoleLevel.member);
        // 我是管理员或群主
        iHaveAdminOrOwnerPermission.value =
            me?.roleLevel == GroupRoleLevel.owner ||
                me?.roleLevel == GroupRoleLevel.admin;
      }

      if (null != other &&
          null != other.muteEndTime &&
          other.muteEndTime! > 0) {
        _calMuteTime(other.muteEndTime!);
      }
    }
  }

  _getJoinGroupMethod(GroupMembersInfo? other) async {
    // 入群方式 2：邀请加入 3：搜索加入 4：通过二维码加入
    if (other?.joinSource == 2) {
      if (other!.inviterUserID != null && other.inviterUserID != other.userID) {
        final list = await OpenIM.iMManager.groupManager.getGroupMembersInfo(
          groupID: groupID!,
          userIDList: [other.inviterUserID!],
        );
        var inviterUserInfo = list.firstOrNull;
        joinGroupMethod.value = sprintf(
          StrLibrary.byInviteJoinGroup,
          [inviterUserInfo?.nickname ?? ''],
        );
      }
    } else if (other?.joinSource == 3) {
      joinGroupMethod.value = StrLibrary.byIDJoinGroup;
    } else if (other?.joinSource == 4) {
      joinGroupMethod.value = StrLibrary.byQrcodeJoinGroup;
    }
  }

  /// 禁言时长
  _calMuteTime(int time) {
    var date = DateUtil.formatDateMs(time, format: IMUtils.getTimeFormat2());
    var now = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var diff = time - now;
    if (diff > 0) {
      mutedTime.value = date;
    } else {
      mutedTime.value = "";
    }
  }

  /// 在线状态
  _queryUserOnlineStatus() {
    Apis.queryUserOnlineStatus(
      uidList: [userInfo.value.userID!],
      onlineStatusCallback: (map) {
        onlineStatus.value = map[userInfo.value.userID!]!;
      },
      onlineStatusDescCallback: (map) {
        onlineStatusDesc.value = map[userInfo.value.userID!]!;
      },
    );
  }

  String getShowName() {
    if (isGroupMemberPage) {
      if (isFriendship) {
        // if (userInfo.value.nickname != groupUserNickname.value) {
        //   return '${groupUserNickname.value}(${IMUtils.emptyStrToNull(userInfo.value.remark) ?? userInfo.value.nickname})';
        // } else {
        //   if (userInfo.value.remark != null &&
        //       userInfo.value.remark!.isNotEmpty) {
        //     return '${groupUserNickname.value}(${IMUtils.emptyStrToNull(userInfo.value.remark)})';
        //   }
        // }
        if (null != IMUtils.emptyStrToNull(userInfo.value.remark)) {
          return '${groupUserNickname.value}(${IMUtils.emptyStrToNull(userInfo.value.remark)})';
        }
      }
      if (groupUserNickname.value.isEmpty) {
        return userInfo.value.nickname ??= "";
      }
      return groupUserNickname.value;
    }
    if (userInfo.value.remark != null && userInfo.value.remark!.isNotEmpty) {
      return '${userInfo.value.nickname}(${userInfo.value.remark})';
    }
    return userInfo.value.nickname ?? '';
  }

  /// 设置为管理员
  void toggleAdmin() async {
    final hasPermission = !hasAdminPermission.value;
    final roleLevel =
        hasPermission ? GroupRoleLevel.admin : GroupRoleLevel.member;
    await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.groupManager.setGroupMemberRoleLevel(
              groupID: groupID!,
              userID: userInfo.value.userID!,
              roleLevel: roleLevel,
            ));

    groupMembersInfo?.roleLevel = roleLevel;
    hasAdminPermission.value = hasPermission;
    // 更新其他界面群成员权限
    if (null != groupMembersInfo) {
      imLogic.memberInfoChangedSubject.add(groupMembersInfo!);
    }
    IMViews.showToast(StrLibrary.setSuccessfully);
  }

  void toChat() {
    conversationLogic.toChat(
      userID: userInfo.value.userID,
      nickname: userInfo.value.showName,
      faceURL: userInfo.value.faceURL,
    );
  }

  void toCall() {
    IMViews.openIMCallSheet(userInfo.value.showName, (index) {
      imLogic.call(
        callObj: CallObj.single,
        callType: index == 0 ? CallType.audio : CallType.video,
        inviteeUserIDList: [userInfo.value.userID!],
      );
    });
  }

  /// 群主禁言（取消禁言）管理员和普通成员，管理员只能禁言（取消禁言）普通成员
  void setMute() => AppNavigator.startSetMuteForGroupMember(
        groupID: groupID!,
        userID: userInfo.value.userID!,
      );

  void copyID() {
    IMUtils.copy(text: userInfo.value.userID!);
  }

  void addFriend() => AppNavigator.startSendVerificationApplication(
        userID: userInfo.value.userID!,
      );

  void viewPersonalInfo() => AppNavigator.startPersonalInfo(
        userID: userInfo.value.userID!,
      );

  void friendSetup() => AppNavigator.startFriendSetup(
        userID: userInfo.value.userID!,
      );

  void viewDynamics() => WNavigator.startUserWorkMomentsList(
        userID: userInfo.value.userID!,
        nickname: userInfo.value.showName,
        faceURL: userInfo.value.faceURL,
      );

  _queryWorkingCircleList() async {
    final userID = userInfo.value.userID!;
    final result = await WApis.getUserMomentsList(
      userID: userID,
      pageNumber: 1,
      showNumber: 10,
    );
    final list = result.workMoments ?? [];
    list.forEach((item) {
      if (item.content?.type == 0 &&
          null != item.content?.metas &&
          item.content!.metas!.isNotEmpty) {
        picMetas.assignAll(item.content!.metas!);
      }
    });
  }

  void setFriendRemark() => AppNavigator.startSetFriendRemark();
}
