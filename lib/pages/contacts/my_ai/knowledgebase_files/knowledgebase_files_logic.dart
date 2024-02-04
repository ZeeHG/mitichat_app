import 'dart:async';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

class KnowledgebaseFilesLogic extends GetxController {
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    getFiles();
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  final files = <String>[].obs;
  final knowledgebaseId = Get.arguments['knowledgebaseId'];

  Future<void> getFiles() async {
    LoadingView.singleton.wrap(asyncFunction: () async {
      final list = await Apis.getKnowledgeFiles(knowledgebaseId: knowledgebaseId);
      files.value = list;
    });
  }
}
