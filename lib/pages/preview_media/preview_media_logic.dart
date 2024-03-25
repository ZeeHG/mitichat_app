import 'package:get/get.dart';

class PreviewMediaLogic extends GetxController {
  final mediaLogic = Get.arguments['mediaLogic'];
  final currentIndex = 0.obs;

  @override
  void onInit() {
    currentIndex.value = Get.arguments['currentIndex'];
    super.onInit();
  }

  void delete() {
    mediaLogic?.deleteAssets(reviseIndex);
    if (mediaLogic.assetsList.isEmpty) {
      Get.back();
    }
  }

  int get reviseIndex {
    final index = currentIndex.value;
    return currentIndex.value = index >= mediaLogic.assetsList.length
        ? (mediaLogic.assetsList.length - 1)
        : index;
  }
}
