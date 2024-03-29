import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class ComplaintLogic extends GetxController {
  // select, input, result
  final status = "select".obs;
  final type = "".obs;
  final content = "".obs;
  final assetsList = <AssetEntity>[].obs;
  final inputCtrl = TextEditingController();
  final focusNode = FocusNode();
  final params = <String, dynamic>{}.obs;
  final maxAssetsCount = 3;
  final pageTitle = "".obs;
  final complaintType = ComplaintType.user.obs;
  final reasonList = <String>[].obs;

  int get btnLength => (assetsList.length < maxAssetsCount ? 1 : 0);

  changeType(String value, {bool autoJump = true}) {
    type.value = value;
    if (autoJump) {
      status.value = "input";
    }
  }

  mulSelect(String value) {
    if (reasonList.contains(value)) {
      reasonList.remove(value);
    } else {
      reasonList.add(value);
    }
  }

  nextStep(String value) {
    status.value = value;
  }

  previewSelectedPicture(int index) => AppNavigator.startPreviewMediaPage(
      mediaLogic: this, currentIndex: index, showDel: true);

  bool showAddAssetsBtn(index) =>
      (assetsList.length < maxAssetsCount) &&
      (index == (assetsList.length + btnLength) - 1);

  bool get enabled => content.isNotEmpty;

  deleteAssets(int index) {
    assetsList.removeAt(index);
  }

  selectAssetsFromAlbum() async {
    Permissions.storage(permissions: [Permission.photos, Permission.videos],
        () async {
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
    if (complaintType.value == ComplaintType.xhs) {
      await LoadingView.singleton.start(fn: () async {
        await Apis.complainXhs(
          workMomentID: params["workMomentID"] ?? "",
          content: content.value,
          reason: reasonList,
          assets: assetsList,
        );
      });
    } else {
      await LoadingView.singleton.start(fn: () async {
        await Apis.complain(
          userID: params["userID"] ?? "",
          content: content.value,
          type: type.value,
          assets: assetsList,
        );
      });
    }

    status.value = "result";
    pageTitle.value = "";
  }

  backHome() {
    // AppNavigator.startBackMain();
    Get.back();
  }

  @override
  void onClose() {
    inputCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  @override
  void onInit() {
    params.value = Get.arguments["params"];
    pageTitle.value = params["pageTitle"] ?? StrLibrary.complaint;
    complaintType.value = params["complaintType"] ?? ComplaintType.user;
    inputCtrl.addListener(() {
      content.value = inputCtrl.text.trim();
    });
    super.onInit();
  }
}
