import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/ctrl/im_ctrl.dart';

class AiFriendListLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final friendList = <ISUserInfo>[].obs;
  final userIDList = <String>[];
  late StreamSubscription delSub;
  late StreamSubscription addSub;
  late StreamSubscription infoChangedSub;
  final aiUtil = Get.find<AiUtil>();

  List<Map<String, dynamic>> get menus => [
        // {
        //   "key": "createAi",
        //   "text": StrLibrary .createAi,
        //   "color": StylesLibrary.c_8544F8,
        //   "shadowColor": Color.fromRGBO(0, 203, 197, 0.5),
        // },
        {
          "key": "trainAi",
          "text": StrLibrary.trainAi,
          "color": StylesLibrary.c_FEA836,
          "shadowColor": Color.fromRGBO(254, 168, 54, 0.5),
          "onTap": () => myAi()
        },
      ];

  @override
  void onInit() {
    delSub = imCtrl.friendDelSubject.listen(_delFriend);
    addSub = imCtrl.friendAddSubject.listen(_addFriend);
    infoChangedSub = imCtrl.friendInfoChangedSubject.listen(_friendInfoChanged);
    imCtrl.onBlacklistAdd = _delFriend;
    imCtrl.onBlacklistDeleted = _addFriend;
    super.onInit();
  }

  @override
  void onReady() {
    LoadingView.singleton.start(fn: () async {
      await _getFriendList();
    });
    super.onReady();
  }

  @override
  void onClose() {
    delSub.cancel();
    addSub.cancel();
    infoChangedSub.cancel();
    super.onClose();
  }

  void myAi() => AppNavigator.startMyAi();

  Future<void> _getFriendList() async {
    await aiUtil.queryAiList();
    final list = await OpenIM.iMManager.friendshipManager
        .getFriendListMap()
        .then((list) => list.where(_filterBlacklist))
        .then((list) => list.map((e) {
              final fullUser = FullUserInfo.fromJson(e);
              final user = fullUser.friendInfo != null
                  ? ISUserInfo.fromJson(fullUser.friendInfo!.toJson())
                  : ISUserInfo.fromJson(fullUser.publicInfo!.toJson());
              return user;
            }).toList())
        .then((list) => list.where((e) => aiUtil.isAi(e.userID)).toList())
        .then((list) => MitiUtils.convertToAZList(list));
    friendList.assignAll(list.cast<ISUserInfo>());
  }

  bool _filterBlacklist(e) {
    final user = FullUserInfo.fromJson(e);
    final isBlack = user.blackInfo != null;

    if (isBlack) {
      return false;
    } else {
      userIDList.add(user.userID);
      return true;
    }
  }

  _addFriend(dynamic user) {
    if ((user is FriendInfo || user is BlacklistInfo) &&
        aiUtil.isAi(user.userID)) {
      _addUser(user.toJson());
    }
  }

  _delFriend(dynamic user) {
    if (user is FriendInfo || user is BlacklistInfo) {
      friendList.removeWhere((e) => e.userID == user.userID);
    }
  }

  _friendInfoChanged(FriendInfo user) {
    friendList.removeWhere((e) => e.userID == user.userID);
    _addUser(user.toJson());
  }

  void _addUser(Map<String, dynamic> json) {
    final info = ISUserInfo.fromJson(json);
    friendList.add(MitiUtils.setAzPinyinAndTag(info) as ISUserInfo);

    // A-Z sort.
    SuspensionUtil.sortListBySuspensionTag(friendList);

    // show sus tag.
    SuspensionUtil.setShowSuspensionStatus(friendList);
    // IMUtil.convertToAZList(friendList);

    // friendList.refresh();
  }

  void viewFriendInfo(ISUserInfo info) => AppNavigator.startUserProfilePane(
        userID: info.userID!,
      );

  void searchAiFriend() => AppNavigator.startSearchAiFriend();
}
