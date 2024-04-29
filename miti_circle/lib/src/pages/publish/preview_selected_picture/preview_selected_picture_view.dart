import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

import '../publish_logic.dart';
import 'preview_selected_picture_logic.dart';

class PreviewSelectedPicturePage extends StatelessWidget {
  final logic = Get.find<PreviewSelectedPictureLogic>();
  final publishLogic = Get.find<PublishLogic>();

  PreviewSelectedPicturePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() => Scaffold(
          appBar: TitleBar.back(
            backgroundColor: StylesLibrary.c_000000,
            backIconColor: StylesLibrary.c_FFFFFF,
            leftTitle:
                "${logic.reviseIndex + 1}/${publishLogic.assetsList.length}",
            leftTitleStyle: StylesLibrary.ts_FFFFFF_17sp_semibold,
            right: StrLibrary.delete.toText
              ..style = StylesLibrary.ts_FFFFFF_17sp_semibold
              ..onTap = logic.delete,
          ),
          backgroundColor: StylesLibrary.c_000000,
          body: ExtendedImageGesturePageView.builder(
            itemBuilder: (BuildContext context, int index) {
              var entity = publishLogic.assetsList.elementAt(index);
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
            itemCount: publishLogic.assetsList.length,
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
