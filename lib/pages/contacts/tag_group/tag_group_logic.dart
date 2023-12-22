import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TagGroupLogic extends GetxController {
  final tagGroups = <TagInfo>[].obs;
  final refreshCtrl = RefreshController();

  @override
  void onReady() {
    queryTagGroup();
    super.onReady();
  }

  void createTagGroup() async {
    final isCreated = await AppNavigator.startCreateTagGroup();
    if (isCreated == true) {
      queryTagGroup();
    }
  }

  void queryTagGroup() async {
    final result = await Apis.getUserTags();
    tagGroups.assignAll(result.tags ?? []);
    refreshCtrl.refreshCompleted();
  }

  void edit(TagInfo tagInfo) async {
    final isEdited = await AppNavigator.startCreateTagGroup(tagInfo: tagInfo);
    if (isEdited == true) {
      queryTagGroup();
    }
  }

  void delete(TagInfo tagInfo) async {
    final result = await Get.dialog(
      CustomDialog(title: StrRes.confirmDelTagGroupHint),
    );
    if (result == true) {
      await LoadingView.singleton.wrap(
        asyncFunction: () => Apis.deleteTag(tagID: tagInfo.tagID!),
      );
      tagGroups.remove(tagInfo);
    }
  }
}
