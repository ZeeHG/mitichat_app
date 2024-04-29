import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';

import 'preview_selected_video_logic.dart';

class PreviewSelectedVideoPage extends StatelessWidget {
  final logic = Get.find<PreviewSelectedVideoLogic>();

  PreviewSelectedVideoPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: TitleBar.back(
        backgroundColor: StylesLibrary.c_000000,
        backIconColor: StylesLibrary.c_FFFFFF,
        leftTitleStyle: StylesLibrary.ts_FFFFFF_17sp_semibold,
        right: StrLibrary.delete.toText
          ..style = StylesLibrary.ts_FFFFFF_17sp_semibold
          ..onTap = logic.delete,
      ),
      backgroundColor: StylesLibrary.c_000000,
      body: SafeArea(
        child: Obx(() => logic.isInitialized.value
            ? Chewie(controller: logic.chewieController!)
            : const SizedBox()),
      ),
    );
  }
}
