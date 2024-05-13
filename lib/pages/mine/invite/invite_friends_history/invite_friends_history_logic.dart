import 'dart:async';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti_common/miti_common.dart';

class InviteFriendsHistoryLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final users = <UserFullInfo>[].obs;

  get userID => imCtrl.userInfo.value.userID;

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  loadingData() {
    LoadingView.singleton.start(fn: () async {
      final res1 = await ClientApis.queryInvitedUsers();
      if (null != res1?["users"]) {
        users.value = List<UserFullInfo>.from(
            res1?["users"]!.map((e) => UserFullInfo.fromJson(e)).toList())
            ;
      }
    });
  }
}
