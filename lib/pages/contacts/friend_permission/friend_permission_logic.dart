import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

class FriendPermissionLogic extends GetxController {
  final seeMomentPermission = false.obs;
  final userID = "".obs;

  changeMoments() async {
    await LoadingView.singleton.start(
      fn: () => Apis.blockMoment(
          userID: userID.value, operation: seeMomentPermission.value ? 1 : 0),
    );
    seeMomentPermission.value = !seeMomentPermission.value;
  }

  @override
  void onInit() {
    userID.value = Get.arguments["userID"];
    queryMomentPermission();
    super.onInit();
  }

  queryMomentPermission() async {
    final result = await LoadingView.singleton.start(
      fn: () => Apis.getBlockMoment(
        userID: userID.value,
      ),
    );
    seeMomentPermission.value = result["blocked"] == 1 ? false : true;
  }
}
