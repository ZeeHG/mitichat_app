import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';

import '../../select_contacts/select_contacts_logic.dart';

class CreateTagGroupLogic extends GetxController {
  final inputCtrl = TextEditingController();
  final memberList = <UserInfo>[].obs;
  final enabled = false.obs;
  TagInfo? tagInfo;

  bool get isEdit => tagInfo != null;

  @override
  void onInit() {
    tagInfo = Get.arguments["tagInfo"];
    if (null != tagInfo) {
      inputCtrl.text = tagInfo!.tagName ?? '';
      memberList
          .assignAll(tagInfo!.users!.map((e) => UserInfo.fromJson(e.toJson())));
    }
    inputCtrl.addListener(_onChanged);
    super.onInit();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    super.onClose();
  }

  void _onChanged() {
    enabled.value = inputCtrl.text.trim().isNotEmpty && memberList.isNotEmpty;
  }

  void selectTagMember() async {
    final result = await AppNavigator.startSelectContacts(
      action: SelAction.createTag,
      checkedList: memberList.value,
    );
    if (null != result) {
      final list = IMUtils.convertSelectContactsResultToUserInfo(result);
      memberList.assignAll(list ?? []);
      _onChanged();
    }
  }

  void delTagMember(UserInfo userInfo) {
    memberList.remove(userInfo);
    _onChanged();
  }

  void completeCreation() async {
    await LoadingView.singleton.wrap(
      asyncFunction: () async {
        final increaseUserIDList = <String>[];
        final reduceUserIDList = <String>[];
        if (isEdit) {
          final oldList =
              tagInfo!.users!.map((e) => UserInfo.fromJson(e.toJson()));
          for (var user in oldList) {
            if (!memberList.value.contains(user)) {
              reduceUserIDList.add(user.userID!);
            }
          }
          for (var user in memberList.value) {
            if (!oldList.contains(user)) {
              increaseUserIDList.add(user.userID!);
            }
          }
        }
        return isEdit
            ? Apis.updateTag(
                tagID: tagInfo!.tagID!,
                name: inputCtrl.text.trim(),
                increaseUserIDList: increaseUserIDList,
                reduceUserIDList: reduceUserIDList,
              )
            : Apis.createTag(
                tagName: inputCtrl.text.trim(),
                userIDList: memberList.map((e) => e.userID!).toList(),
              );
      },
    );
    Get.back(result: true);
  }
}
