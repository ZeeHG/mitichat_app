import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/contacts/group_profile/group_profile_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:sprintf/sprintf.dart';

enum SearchType {
  user,
  group,
}

class SearchAddContactsLogic extends GetxController {
  final refreshCtrl = RefreshController();
  final searchCtrl = TextEditingController();
  final focusNode = FocusNode();
  final userInfoList = <UserFullInfo>[].obs;
  final groupInfoList = <GroupInfo>[].obs;
  late SearchType searchType;
  int pageNo = 0;

  @override
  void onClose() {
    searchCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    searchType = Get.arguments['searchType'] ?? SearchType.user;
    searchCtrl.addListener(() {
      if (searchKey.isEmpty) {
        focusNode.requestFocus();
        userInfoList.clear();
        groupInfoList.clear();
      }
    });
    super.onInit();
  }

  bool get isSearchUser => searchType == SearchType.user;

  String get searchKey => searchCtrl.text.trim();

  bool get isNotFoundUser => userInfoList.isEmpty && searchKey.isNotEmpty;

  bool get isNotFoundGroup => groupInfoList.isEmpty && searchKey.isNotEmpty;

  void search() {
    if (searchKey.isEmpty) return;
    if (isSearchUser) {
      searchUser();
    } else {
      searchGroup();
    }
  }

  void searchUser() async {
    var list = await LoadingView.singleton.start(
      fn: () => Apis.searchUserFullInfo(
        content: searchKey,
        pageNumber: pageNo = 1,
        showNumber: 20,
      ),
    );
    // todo, 暂时本地精确匹配id 和手机
    var filterList = (list ?? []).where((element) =>
        element.userID! == searchKey.toLowerCase() ||
        element.phoneNumber == searchKey);
    userInfoList.assignAll(filterList);
    // userInfoList.assignAll(list ?? []);
    refreshCtrl.refreshCompleted();
    if (null == list || list.isEmpty || list.length < 20) {
      refreshCtrl.loadNoData();
    } else {
      refreshCtrl.loadComplete();
    }
  }

  void loadMoreUser() async {
    var list = await LoadingView.singleton.start(
      fn: () => Apis.searchUserFullInfo(
        content: searchKey,
        pageNumber: ++pageNo,
        showNumber: 20,
      ),
    );
    userInfoList.addAll(list ?? []);
    refreshCtrl.refreshCompleted();
    if (null == list || list.isEmpty || list.length < 20) {
      refreshCtrl.loadNoData();
    } else {
      refreshCtrl.loadComplete();
    }
  }

  void searchGroup() async {
    var list = await OpenIM.iMManager.groupManager.getGroupsInfo(
      groupIDList: [searchKey],
    );
    groupInfoList.assignAll(list);
  }

  String getMatchContent(UserFullInfo userInfo) {
    final keyword = searchCtrl.text;
    // String searchPrefix = "%s";
    // if (keyword == userInfo.userID) {
    //   searchPrefix = StrLibrary .searchIDIs;
    // } else if (keyword == userInfo.phoneNumber) {
    //   searchPrefix = StrLibrary .searchPhoneIs;
    // } else if (keyword == userInfo.email) {
    //   searchPrefix = StrLibrary .searchEmailIs;
    // } else if (keyword == userInfo.nickname) {
    //   searchPrefix = StrLibrary .searchNicknameIs;
    // }
    return sprintf(StrLibrary.searchNicknameIs, [userInfo.nickname]);
  }

  String? getShowName(dynamic info) {
    if (info is UserFullInfo) {
      return info.nickname;
    } else if (info is GroupInfo) {
      return info.groupName;
    }
    return null;
  }

  void viewInfo(dynamic info) {
    if (info is UserFullInfo) {
      AppNavigator.startUserProfilePane(
        userID: info.userID!,
        nickname: info.nickname,
        faceURL: info.faceURL,
      );
    } else if (info is GroupInfo) {
      AppNavigator.startGroupProfile(
        groupID: info.groupID,
        joinGroupMethod: JoinGroupMethod.search,
      );
    }
  }

  String getShowTitle(info) {
    if (!isSearchUser) {
      return sprintf(StrLibrary.searchGroupNicknameIs, [getShowName(info)]);
    }

    UserFullInfo userFullInfo = info;
    String? tips, content;
    if (int.tryParse(searchKey) != null) {
      // if (searchKey.length == 11) {
      //   tips = StrLibrary .phoneNumber;
      //   content = userFullInfo.phoneNumber ?? searchKey;
      // } else {
      //   tips = StrLibrary .userID;
      //   content = userFullInfo.userID;
      // }
      tips = StrLibrary.userIDOrPhone;
      content = searchKey;
    } else {
      tips = StrLibrary.searchNicknameIs;
      content = getShowName(info);
    }
    return "$tips:$content";
  }
}
