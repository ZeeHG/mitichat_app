import 'dart:convert';

import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class FriendPermissionsLogic extends GetxController {
  final momentsStatus = false.obs;
  final userID = "".obs;

  changeMoments() async {
    await LoadingView.singleton.start(
      fn: () => Apis.blockMoment(
          userID: userID.value, operation: momentsStatus.value ? 1 : 0),
    );
    momentsStatus.value = !momentsStatus.value;
  }

  @override
  void onReady() {
    userID.value = Get.arguments["userID"];
    _queryBlockMoment();
    super.onReady();
  }

  _queryBlockMoment() async {
    final result = await LoadingView.singleton.start(
      fn: () => Apis.getBlockMoment(
        userID: userID.value,
      ),
    );
    momentsStatus.value = result["blocked"] == 1 ? false : true;
  }
}
