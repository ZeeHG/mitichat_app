import 'dart:typed_data';
import 'dart:ui';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:miti/core/ctrl/im_ctrl.dart';
import 'package:miti_common/miti_common.dart';

class InviteFriendsQrcodeLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final iMCtrl = Get.find<IMCtrl>();
  GlobalKey previewContainer = GlobalKey();

  String get mitiID => iMCtrl.userInfo.value.mitiID ?? "";

  String get qrcodeData => "${Config.inviteUrl}?mitiID=$mitiID";

  Future<void> saveImg() async {
    RenderRepaintBoundary boundary = previewContainer.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    var image = await boundary.toImage();
    ByteData? byteData = await image.toByteData(format: ImageByteFormat.png);
    Uint8List pngBytes = byteData!.buffer.asUint8List();

    final result = await ImageGallerySaver.saveImage(pngBytes);
    if (result != null && result["isSuccess"]) {
      showToast(StrLibrary.success);
    } else {
      showToast(StrLibrary.fail);
    }
  }
}
