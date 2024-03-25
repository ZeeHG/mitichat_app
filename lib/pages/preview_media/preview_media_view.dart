import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'preview_media_logic.dart';

class PreviewMediaPage extends StatelessWidget {
  final logic =Get.find<PreviewMediaLogic>();
  final mediaLogic = Get.arguments['mediaLogic'];
  bool showDel = Get.arguments['showDel'] ?? false;

  PreviewMediaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            backgroundColor: Styles.c_000000,
            backIconColor: Styles.c_FFFFFF,
            leftTitle:
                "${logic.reviseIndex + 1}/${mediaLogic.assetsList.length}",
            leftTitleStyle: Styles.ts_FFFFFF_16sp,
            right: showDel
                ? (StrLibrary.delete.toText
                  ..style = Styles.ts_FFFFFF_16sp
                  ..onTap = logic.delete)
                : null,
          ),
          backgroundColor: Styles.c_000000,
          body: ExtendedImageGesturePageView.builder(
            itemBuilder: (BuildContext context, int index) {
              var entity = mediaLogic.assetsList.elementAt(index);
              return ExtendedImage(
                image: AssetEntityImageProvider(entity),
                fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (ExtendedImageState state) {
                  return GestureConfig(
                    inPageView: true,
                    initialScale: 1.0,
                    maxScale: 20,
                    animationMaxScale: 21,
                    initialAlignment: InitialAlignment.center,
                  );
                },
              );
            },
            itemCount: mediaLogic.assetsList.length,
            onPageChanged: (int index) {
              logic.currentIndex.value = index;
            },
            controller: ExtendedPageController(
              initialPage: logic.currentIndex.value,
            ),
          ),
        ));
  }
}
