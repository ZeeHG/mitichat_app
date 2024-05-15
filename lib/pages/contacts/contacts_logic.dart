import 'dart:async';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/app_ctrl.dart';
import 'package:miti/pages/contacts/group_profile/group_profile_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
// import 'package:miti_circle/miti_circle.dart';

import '../../core/ctrl/im_ctrl.dart';
import '../home/home_logic.dart';
import 'search_add_contacts/search_add_contacts_logic.dart';
import 'select_contacts/select_contacts_logic.dart';

class ContactsLogic extends GetxController
    implements ViewUserProfileBridge, SelectContactsBridge, ScanBridge {
  final imCtrl = Get.find<IMCtrl>();
  final homeLogic = Get.find<HomeLogic>();
  final friendList = <ISUserInfo>[].obs;
  final userIDList = <String>[];
  final popCtrl = CustomPopupMenuController();
  final appCtrl = Get.find<AppCtrl>();
  late StreamSubscription delSub;
  late StreamSubscription addSub;
  late StreamSubscription infoChangedSub;

  List<Map<String, dynamic>> get menus => [
        {
          "key": "myGroup",
          "text": StrLibrary.myGroup,
          "color": StylesLibrary.c_8544F8,
          "shadowColor": Color.fromRGBO(132, 67, 248, 0.5),
          "onTap": () => myGroup()
        },
        {
          "key": "newRecent",
          "text": StrLibrary.requestRecords,
          "color": StylesLibrary.c_00CBC5,
          "shadowColor": Color.fromRGBO(0, 203, 197, 0.5),
          "onTap": () => newRecent()
        },
        {
          "key": "aiFriendList",
          "text": StrLibrary.aiFriends,
          "color": StylesLibrary.c_FEA836,
          "shadowColor": Color.fromRGBO(254, 168, 54, 0.5),
          "onTap": () => aiFriendList()
        },
      ];

  // final organizationLogic = Get.find<OrganizationLogic>();
  final friendApplicationList = <UserInfo>[];

  int get unhandledFriendApplicationCount =>
      homeLogic.unhandledFriendApplicationCount.value;

  int get unhandledGroupApplicationCount =>
      homeLogic.unhandledGroupApplicationCount.value;

  // String? get organizationName => organizationLogic.organizationName;
  //
  // RxList<UserInDept> get myDeptList => organizationLogic.myDeptList;

  @override
  void onInit() {
    // imCtrl.friendApplicationSubject.listen((value) {
    //
    // });
    // 收到新的好友申请
    // imCtrl.onFriendApplicationListAdded = (u) {
    //   getFriendApplicationList();
    // };
    // 删除好友申请记录
    // imCtrl.onFriendApplicationListDeleted = (u) {
    //   getFriendApplicationList();
    // };
    /// 我的申请被拒绝了
    // imCtrl.onFriendApplicationListRejected = (u) {
    //   getFriendApplicationList();
    // };
    // 我的申请被接受了
    // imCtrl.onFriendApplicationListAccepted = (u) {
    //   getFriendApplicationList();
    // };
    super.onInit();
    initPackageBridge();

    delSub = imCtrl.friendDelSubject.listen(_delFriend);
    addSub = imCtrl.friendAddSubject.listen(_addFriend);
    infoChangedSub = imCtrl.friendInfoChangedSubject.listen(_friendInfoChanged);
    imCtrl.onBlacklistAdd = _delFriend;
    imCtrl.onBlacklistDeleted = _addFriend;

    // imCtrl.momentsSubject.listen((value) {
    //   onRecvNewMessageForWorkingCircle?.call(value);
    // });

    _getFriendList();
  }

  @override
  void onClose() {
    MitiBridge.selectContactsBridge = null;
    MitiBridge.viewUserProfileBridge = null;
    MitiBridge.scanBridge = null;
    super.onClose();
  }

  initPackageBridge() {
    MitiBridge.selectContactsBridge = this;
    MitiBridge.viewUserProfileBridge = this;
    MitiBridge.scanBridge = this;
  }

  _getFriendList() async {
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
    if (!_checkUserType(user)) return;
    _addUser(user.toJson());
  }

  _delFriend(dynamic user) {
    if (!_checkUserType(user)) return;
    friendList.removeWhere((e) => e.userID == user.userID);
  }

  _checkUserType(dynamic user) => user is FriendInfo || user is BlacklistInfo;

  _friendInfoChanged(FriendInfo user) {
    _delFriend(user);
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

  // void newFriend() => AppNavigator.startFriendRequests();

  void newRecent() => AppNavigator.startRequestRecords();

  // void newGroup() => AppNavigator.startGroupRequests();

  void myFriend() => AppNavigator.startMyFriend();

  void aiFriendList() => AppNavigator.startAiFriendList();

  void myGroup() => AppNavigator.startMyGroup();

  void searchContacts() => AppNavigator.startGlobalSearch();

  // void addContacts() => AppNavigator.startAddContactsMethod();

  // void tagGroup() => AppNavigator.startTagGroup();

  void createBot() => AppNavigator.startCreateBot();

  // void notificationIssued() => AppNavigator.startNotificationIssued();

  scan() => AppNavigator.startScan();

  addFriend() =>
      AppNavigator.startSearchAddContacts(searchType: SearchType.user);

  createGroup() => AppNavigator.startCreateGroup(
      defaultCheckedList: [OpenIM.iMManager.userInfo]);

  addGroup() =>
      AppNavigator.startSearchAddContacts(searchType: SearchType.group);

  // void workMoments() => CircleNavigator.startWorkMomentsList();

  @override
  Future<T?>? selectContacts<T>(
    int type, {
    List<String>? defaultCheckedIDList,
    List? checkedList,
    List<String>? excludeIDList,
    bool openSelectedSheet = false,
    String? groupID,
    String? ex,
  }) =>
      // AppNavigator.startSelectContacts(
      //   action: type == 0
      //       ? SelAction.whoCanWatch
      //       : (type == 1 ? SelAction.remindWhoToWatch : SelAction.meeting),
      AppNavigator.startSelectContacts(
        action: type == 0 ? SelAction.whoCanWatch : SelAction.remindWhoToWatch,
        defaultCheckedIDList: defaultCheckedIDList,
        checkedList: checkedList,
        excludeIDList: excludeIDList,
        openSelectedSheet: openSelectedSheet,
        groupID: groupID,
        ex: ex,
      );

  @override
  viewUserProfile(String userID, String? nickname, String? faceURL,
          [String? groupID]) =>
      AppNavigator.startUserProfilePane(
        userID: userID,
        nickname: nickname,
        faceURL: faceURL,
        groupID: groupID,
      );

  @override
  scanOutGroupID(String groupID) => AppNavigator.startGroupProfile(
        groupID: groupID,
        joinGroupMethod: JoinGroupMethod.qrcode,
        offAndToNamed: true,
      );

  @override
  scanOutUserID(String userID) =>
      AppNavigator.startUserProfilePane(userID: userID, offAndToNamed: true);

  @override
  scanActiveAccount({required String useInviteMitiID}) =>
      appCtrl.requestActiveAccount(useInviteMitiID: useInviteMitiID);
}
