import 'dart:async';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

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
  Knowledgebase knowledgebase = Get.arguments['knowledgebase'];

  Future<void> getFiles() async {
    LoadingView.singleton.start(fn: () async {
      final list = List<String>.from((await Apis.getKnowledgeFiles(
              knowledgebaseID: knowledgebase.knowledgebaseID))["files"] ??
          []);
      files.value = list;
    });
  }
}
