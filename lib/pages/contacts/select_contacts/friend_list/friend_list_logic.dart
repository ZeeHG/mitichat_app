import 'package:get/get.dart';
import 'package:miti/pages/contacts/friend_list/friend_list_logic.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';

import '../select_contacts_logic.dart';

class SelectContactsFromFriendsLogic extends FriendListLogic {
  final selectContactsLogic = Get.find<SelectContactsLogic>();
  String appBarTitle = "";

  @override
  void onInit() {
    appBarTitle = Get.arguments['appBarTitle'] ?? StrLibrary.myFriend;
    super.onInit();
  }

  @override
  searchFriend() async {
    final result = await AppNavigator.startSelectContactsFromSearchFriends(
        appBarTitle: appBarTitle);
    if (null != result) {
      Get.back(result: result);
    }
  }

  @override
  void onUserIDList(List<String> userIDList) {
    selectContactsLogic.updateDefaultCheckedList(userIDList);
    super.onUserIDList(userIDList);
  }

  bool get isSelectAll {
    if (selectContactsLogic.checkedList.isEmpty) {
      return false;
    } else if (operableList
        .every((item) => selectContactsLogic.isChecked(item))) {
      return true;
    } else {
      return false;
    }
  }

  Iterable<ISUserInfo> get operableList => friendList.where(_remove);

  bool _remove(ISUserInfo info) => !selectContactsLogic.isDefaultChecked(info);

  selectAll() {
    if (isSelectAll) {
      for (var info in operableList) {
        selectContactsLogic.removeItem(info);
      }
    } else {
      for (var info in operableList) {
        final isChecked = selectContactsLogic.isChecked(info);
        if (!isChecked) {
          selectContactsLogic.toggleChecked(info);
        }
      }
    }
  }
}
