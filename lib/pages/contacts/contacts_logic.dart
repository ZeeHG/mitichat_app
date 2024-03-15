import 'dart:async';
import 'dart:ui';

import 'package:azlistview/azlistview.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/contacts/group_profile_panel/group_profile_panel_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
// import 'package:miti_circle/miti_circle.dart';

import '../../core/ctrl/im_ctrl.dart';
import '../home/home_logic.dart';
import 'add_by_search/add_by_search_logic.dart';
import 'select_contacts/select_contacts_logic.dart';

class ContactsLogic extends GetxController
    implements ViewUserProfileBridge, SelectContactsBridge, ScanBridge {
  final imCtrl = Get.find<IMCtrl>();
  final homeLogic = Get.find<HomeLogic>();
  final friendList = <ISUserInfo>[].obs;
  final userIDList = <String>[];
  final popCtrl = CustomPopupMenuController();
  late StreamSubscription delSub;
  late StreamSubscription addSub;
  late StreamSubscription infoChangedSub;

  List<Map<String, dynamic>> get menus => [
        // {
        //   "key": "myFriend",
        //   "text": StrLibrary .myFriend,
        //   "color": Styles.c_8544F8,
        //   "shadowColor": Color.fromRGBO(132, 67, 248, 0.5),
        //   "onTap": () => myFriend()
        // },
        {
          "key": "myGroup",
          "text": StrLibrary.myGroup,
          "color": Styles.c_8544F8,
          "shadowColor": Color.fromRGBO(132, 67, 248, 0.5),
          "onTap": () => myGroup()
        },
        {
          "key": "newRecent",
          "text": StrLibrary.recentRequests,
          "color": Styles.c_00CBC5,
          "shadowColor": Color.fromRGBO(0, 203, 197, 0.5),
          "onTap": () => newRecent()
        },
        {
          "key": "aiFriendList",
          "text": StrLibrary.aiFriends,
          "color": Styles.c_FEA836,
          "shadowColor": Color.fromRGBO(254, 168, 54, 0.5),
          "onTap": () => aiFriendList()
        },
      ];

  // final organizationLogic = Get.find<OrganizationLogic>();
  final friendApplicationList = <UserInfo>[];

  int get friendApplicationCount =>
      homeLogic.unhandledFriendApplicationCount.value;

  int get groupApplicationCount =>
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
    initPackageBridge();

    delSub = imCtrl.friendDelSubject.listen(_delFriend);
    addSub = imCtrl.friendAddSubject.listen(_addFriend);
    infoChangedSub = imCtrl.friendInfoChangedSubject.listen(_friendInfoChanged);
    imCtrl.onBlacklistAdd = _delFriend;
    imCtrl.onBlacklistDeleted = _addFriend;

    // imCtrl.momentsSubject.listen((value) {
    //   onRecvNewMessageForWorkingCircle?.call(value);
    // });
    super.onInit();
  }

  @override
  void onReady() {
    _getFriendList();
    super.onReady();
  }

  @override
  void onClose() {
    PackageBridge.selectContactsBridge = null;
    PackageBridge.viewUserProfileBridge = null;
    // PackageBridge.workingCircleBridge = null;
    PackageBridge.scanBridge = null;
    super.onClose();
  }

  initPackageBridge() {
    PackageBridge.selectContactsBridge = this;
    PackageBridge.viewUserProfileBridge = this;
    // PackageBridge.workingCircleBridge = this;
    PackageBridge.scanBridge = this;
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
        .then((list) => IMUtils.convertToAZList(list));

    onUserIDList(userIDList);
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
    if (user is FriendInfo || user is BlacklistInfo) {
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

  void onUserIDList(List<String> userIDList) {}

  void newFriend() => AppNavigator.startFriendRequests();

  void newRecent() => AppNavigator.startRecentRequests();

  void newGroup() => AppNavigator.startGroupRequests();

  void myFriend() => AppNavigator.startFriendList();

  void aiFriendList() => AppNavigator.startAiFriendList();

  void myGroup() => AppNavigator.startGroupList();

  void searchContacts() => AppNavigator.startGlobalSearch();

  void addContacts() => AppNavigator.startAddContactsMethod();

  void tagGroup() => AppNavigator.startTagGroup();

  void createBot() => AppNavigator.startCreateBot();

  void notificationIssued() => AppNavigator.startNotificationIssued();

  scan() => AppNavigator.startScan();

  addFriend() =>
      AppNavigator.startAddContactsBySearch(searchType: SearchType.user);

  createGroup() => AppNavigator.startCreateGroup(
      defaultCheckedList: [OpenIM.iMManager.userInfo]);

  addGroup() =>
      AppNavigator.startAddContactsBySearch(searchType: SearchType.group);

  // void workMoments() => WNavigator.startWorkMomentsList();

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
  scanOutGroupID(String groupID) => AppNavigator.startGroupProfilePanel(
        groupID: groupID,
        joinGroupMethod: JoinGroupMethod.qrcode,
        offAndToNamed: true,
      );

  @override
  scanOutUserID(String userID) =>
      AppNavigator.startUserProfilePane(userID: userID, offAndToNamed: true);
}
