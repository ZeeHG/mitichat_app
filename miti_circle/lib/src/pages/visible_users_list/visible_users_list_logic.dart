import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class VisibleUsersListLogic extends GetxController {
  late WorkMoments workMoments;
  final listUserInfo = <UserInfo>[].obs;

  @override
  void onInit() {
    workMoments = Get.arguments['workMoments'];
    _queryUserInfo();
    super.onInit();
  }

  String get title => workMoments.permission == 2
      ? StrLibrary.whoCanWatch
      : StrLibrary.partiallyInvisible;

  void _queryUserInfo() async {
    final list = await LoadingView.singleton.start(
      fn: () => OpenIM.iMManager.userManager.getUsersInfo(
        userIDList: workMoments.permissionUsers!.map((e) => e.userID!).toList(),
      ),
    );
    listUserInfo.addAll(list.map((e) => e.simpleUserInfo));
  }

}
