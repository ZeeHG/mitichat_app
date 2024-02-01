import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/contacts/add_by_search/add_by_search_logic.dart';
import 'package:miti/routes/app_navigator.dart';

class AddContactsMethodLogic extends GetxController {
  scan() => AppNavigator.startScan();

  addFriend() =>
      AppNavigator.startAddContactsBySearch(searchType: SearchType.user);

  createGroup() => AppNavigator.startCreateGroup(
      defaultCheckedList: [OpenIM.iMManager.userInfo]);

  addGroup() =>
      AppNavigator.startAddContactsBySearch(searchType: SearchType.group);
}
