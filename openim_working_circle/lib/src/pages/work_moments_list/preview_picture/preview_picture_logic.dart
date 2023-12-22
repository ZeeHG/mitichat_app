import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class PreviewPictureLogic extends GetxController {
  late List<Metas> metas;
  late int currentIndex;
  String? heroTag;

  @override
  void onInit() {
    metas = Get.arguments['metas'];
    currentIndex = Get.arguments['currentIndex'];
    heroTag = Get.arguments['heroTag'];
    super.onInit();
  }
}
