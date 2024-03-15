import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti_common/miti_common.dart';

import '../../../core/controller/im_ctrl.dart';

class MyAiLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final friendList = <ISUserInfo>[].obs;
  final userIDList = <String>[];
  late StreamSubscription delSub;
  late StreamSubscription addSub;
  late StreamSubscription infoChangedSub;
  final aiUtil = Get.find<AiUtil>();
  final myAiList = <Ai>[].obs;

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

  void startSearchMyAi() => AppNavigator.startSearchMyAi();

  void startTrainAi(ISUserInfo info) {
    AppNavigator.startTrainAi(
        userID: info.userID!,
        faceURL: info.faceURL,
        showName: info.showName,
        ai: myAiList.firstWhere((e) => e.userID == info.userID));
  }

  Future<void> _getFriendList() async {
    myAiList.value = await aiUtil.queryMyAiList();
    final myAiUserIDList = myAiList.map((e) => e.userID).toList();
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
        .then((list) =>
            list.where((e) => myAiUserIDList.contains(e.userID)).toList())
        .then((list) => IMUtils.convertToAZList(list));
    onUserIDList(userIDList);
    friendList.assignAll(list.cast<ISUserInfo>());
  }

  void onUserIDList(List<String> userIDList) {}

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
    friendList.add(IMUtils.setAzPinyinAndTag(info) as ISUserInfo);

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
