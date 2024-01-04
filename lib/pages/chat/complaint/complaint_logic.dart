import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:openim/routes/app_navigator.dart';
import 'package:openim_common/openim_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ComplaintLogic extends GetxController {
  final status = "select".obs;
  final type = "".obs;
  final content = "".obs;
  final assetsList = <AssetEntity>[].obs;
  final inputCtrl = TextEditingController();
  final focusNode = FocusNode();
  final userID = "".obs;
  final maxAssetsCount = 9;

  int get btnLength => (assetsList.length < maxAssetsCount ? 1 : 0);

  changeType(String value) {
    type.value = value;
    status.value = "input";
  }

  previewSelectedPicture(int index) =>
      AppNavigator.startPreviewSelectedAssetsPage(
          assetsLogic: this, currentIndex: index);

  bool showAddAssetsBtn(index) =>
      (assetsList.length < maxAssetsCount) &&
      (index == (assetsList.length + btnLength) - 1);

  bool get enabled => content.isNotEmpty;

  deleteAssets(int index) {
    assetsList.removeAt(index);
  }

  selectAssetsFromAlbum() async {
    Permissions.requestStorage(() async {
      final List<AssetEntity>? assets = await AssetPicker.pickAssets(
        Get.context!,
        pickerConfig: AssetPickerConfig(
          selectedAssets: assetsList,
          maxAssets: maxAssetsCount,
          requestType: RequestType.image,
          selectPredicate: (_, entity, isSelected) {
            return true;
          },
        ),
      );
      if (null != assets) {
        assetsList.assignAll(assets);
      }
    });
  }

  submit() async {
    await LoadingView.singleton.wrap(asyncFunction: () async {
      await Apis.complain(
        userID: userID.value,
        content: content.value,
        type: type.value,
        assets: assetsList.value,
      );
    });
    status.value = "result";
  }

  backHome() {
    AppNavigator.startBackMain();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    userID.value = Get.arguments["userID"];
    inputCtrl.addListener(() {
      content.value = inputCtrl.text.trim();
    });
    super.onInit();
  }
}
