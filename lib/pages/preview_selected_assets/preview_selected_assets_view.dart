import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import 'preview_selected_assets_logic.dart';

class PreviewSelectedAssetsPage extends StatelessWidget {
  final logic = Get.find<PreviewSelectedAssetsLogic>();
  final assetsLogic = Get.arguments['assetsLogic'];

  PreviewSelectedAssetsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            backgroundColor: Styles.c_000000,
            backIconColor: Styles.c_FFFFFF,
            leftTitle:
                "${logic.reviseIndex + 1}/${assetsLogic.assetsList.length}",
            leftTitleStyle: Styles.ts_FFFFFF_17sp_semibold,
            right: StrLibrary.delete.toText
              ..style = Styles.ts_FFFFFF_17sp_semibold
              ..onTap = logic.delete,
          ),
          backgroundColor: Styles.c_000000,
          body: ExtendedImageGesturePageView.builder(
            itemBuilder: (BuildContext context, int index) {
              var entity = assetsLogic.assetsList.elementAt(index);
              return ExtendedImage(
                image: AssetEntityImageProvider(entity),
                fit: BoxFit.contain,
                mode: ExtendedImageMode.gesture,
                initGestureConfigHandler: (ExtendedImageState state) {
                  return GestureConfig(
                    inPageView: true,
                    initialScale: 1.0,
                    maxScale: 5.0,
                    animationMaxScale: 6.0,
                    initialAlignment: InitialAlignment.center,
                  );
                },
              );
            },
            itemCount: assetsLogic.assetsList.length,
            onPageChanged: (int index) {
              logic.currentIndex.value = index;
            },
            controller: ExtendedPageController(
              initialPage: logic.currentIndex.value,
              // pageSpacing: 50,
            ),
          ),
        ));
  }
}
