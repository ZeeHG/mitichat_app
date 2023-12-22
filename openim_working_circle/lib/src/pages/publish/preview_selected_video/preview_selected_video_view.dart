import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import 'preview_selected_video_logic.dart';

class PreviewSelectedVideoPage extends StatelessWidget {
  final logic = Get.find<PreviewSelectedVideoLogic>();

  PreviewSelectedVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        backgroundColor: Styles.c_000000,
        backIconColor: Styles.c_FFFFFF,
        leftTitleStyle: Styles.ts_FFFFFF_17sp_semibold,
        right: StrRes.delete.toText
          ..style = Styles.ts_FFFFFF_17sp_semibold
          ..onTap = logic.delete,
      ),
      backgroundColor: Styles.c_000000,
      body: SafeArea(
        child: Obx(() => logic.isInitialized.value
            ? Chewie(controller: logic.chewieController!)
            : const SizedBox()),
      ),
    );
  }
}
