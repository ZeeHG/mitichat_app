import 'package:get/get.dart';

import '../publish_logic.dart';

class PreviewSelectedPictureLogic extends GetxController {
  final publishLogic = Get.find<PublishLogic>();
  final currentIndex = 0.obs;

  @override
  void onInit() {
    currentIndex.value = Get.arguments['currentIndex'];
    super.onInit();
  }

  void delete() {
    publishLogic.deleteAssets(reviseIndex);
    if (publishLogic.assetsList.isEmpty) {
      Get.back();
    }
  }

  int get reviseIndex {
    final index = currentIndex.value;
    return currentIndex.value = index >= publishLogic.assetsList.length
        ? (publishLogic.assetsList.length - 1)
        : index;
  }
}
