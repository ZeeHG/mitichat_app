import 'package:get/get.dart';

import 'knowledgebase_files_logic.dart';

class KnowledgebaseFilesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => KnowledgebaseFilesLogic());
  }
}
