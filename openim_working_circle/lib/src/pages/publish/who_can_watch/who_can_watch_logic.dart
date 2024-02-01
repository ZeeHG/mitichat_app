import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class WhoCanWatchLogic extends GetxController {
  /// 0/1/2/3, 公开/私密/部分可见/不给谁看
  final permission = 0.obs;
  final checkedVisibleList = <dynamic>[].obs;
  final checkedInvisibleList = <dynamic>[].obs;

  SelectContactsBridge? get bridge => PackageBridge.selectContactsBridge;

  @override
  void onInit() {
    permission.value = Get.arguments['permission'];
    if (permission.value == 2) {
      checkedVisibleList.addAll(Get.arguments['checkedList']);
    } else if (permission.value == 3) {
      checkedInvisibleList.addAll(Get.arguments['checkedList']);
    }
    // checkedVisibleList.addAll(Get.arguments['remindList']);
    super.onInit();
  }

  selectPermission(int index) async {
    permission.value = index;
    if (index == 2 || index == 3) {
      final result = await bridge?.selectContacts(
        0,
        checkedList: index == 2 ? checkedVisibleList : checkedInvisibleList,
      );
      if (result is Map) {
        final values = result.values;
        if (index == 2) {
          checkedVisibleList.assignAll(values);
        } else if (index == 3) {
          checkedInvisibleList.assignAll(values);
        }
      }
    }
  }

  determine() {
    if (permission.value == 2 && checkedVisibleList.isEmpty ||
        permission.value == 3 && checkedInvisibleList.isEmpty) {
      IMViews.showToast(StrRes.selectContactsLimit);
      return;
    }
    Get.back(result: {
      'permission': permission.value,
      'checkedList': permission.value == 2
          ? checkedVisibleList.value
          : checkedInvisibleList.value,
    });
  }
}
