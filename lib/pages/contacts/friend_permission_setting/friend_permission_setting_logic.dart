import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class FriendPermissionSettingLogic extends GetxController {
  final seeMomentPermission = false.obs;
  final userID = "".obs;

  changeMoments() async {
    await LoadingView.singleton.start(
      fn: () async {
        await Apis.blockMoment(
            userID: userID.value, operation: seeMomentPermission.value ? 1 : 0);
        seeMomentPermission.value = !seeMomentPermission.value;
      },
    );
  }

  @override
  void onInit() {
    super.onInit();
    userID.value = Get.arguments["userID"];
    queryMomentPermission();
  }

  queryMomentPermission() async {
    await LoadingView.singleton.start(fn: () async {
      final result = await Apis.getBlockMoment(
        userID: userID.value,
      );
      seeMomentPermission.value = result["blocked"] == 1 ? false : true;
    });
  }
}
