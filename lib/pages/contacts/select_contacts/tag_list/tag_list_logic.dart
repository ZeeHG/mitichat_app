import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../select_contacts_logic.dart';

class SelectContactsFromTagLogic extends GetxController {
  final operableList = <TagInfo>[].obs;
  final selectContactsLogic = Get.find<SelectContactsLogic>();

  @override
  void onReady() {
    queryTagGroup();
    super.onReady();
  }

  void queryTagGroup() async {
    final result = await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.getUserTags(),
    );
    operableList.assignAll(result.tags ?? []);
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
