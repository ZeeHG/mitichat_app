import 'package:extended_image/extended_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
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
            backgroundColor: Styles.c_000000,
            backIconColor: Styles.c_FFFFFF,
            leftTitle:
                "${logic.reviseIndex + 1}/${publishLogic.assetsList.length}",
            leftTitleStyle: Styles.ts_FFFFFF_17sp_semibold,
            right: StrRes.delete.toText
              ..style = Styles.ts_FFFFFF_17sp_semibold
              ..onTap = logic.delete,
          ),
          backgroundColor: Styles.c_000000,
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
                    maxScale: 5.0,
                    animationMaxScale: 6.0,
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
