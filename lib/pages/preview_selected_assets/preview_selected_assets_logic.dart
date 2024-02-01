import 'package:get/get.dart';

class PreviewSelectedAssetsLogic extends GetxController {
  final assetsLogic = Get.arguments['assetsLogic'];
  final currentIndex = 0.obs;

  @override
  void onInit() {
    currentIndex.value = Get.arguments['currentIndex'];
    super.onInit();
  }

  void delete() {
    assetsLogic.deleteAssets(reviseIndex);
    if (assetsLogic.assetsList.isEmpty) {
      Get.back();
    }
  }

  int get reviseIndex {
    final index = currentIndex.value;
    return currentIndex.value = index >= assetsLogic.assetsList.length
        ? (assetsLogic.assetsList.length - 1)
        : index;
  }
}
