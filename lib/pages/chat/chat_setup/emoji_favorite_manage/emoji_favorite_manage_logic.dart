import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:wechat_assets_picker/wechat_assets_picker.dart';

class EmojiFavoriteManageLogic extends GetxController {
  var cacheLogic = Get.find<CacheController>();
  var isMultiModel = false.obs;
  var selectedList = <String>[].obs;

  void addFavorite() async {
    final List<AssetEntity>? assets = await AssetPicker.pickAssets(
      Get.context!,
      pickerConfig: const AssetPickerConfig(requestType: RequestType.image),
    );
    if (null != assets) {
      for (var asset in assets) {
        var path = (await asset.file)!.path;
        var width = asset.width;
        var height = asset.height;
        if (asset.type == AssetType.image) {
          cacheLogic.addFavoriteFromPath(path, width, height);
          showToast(StrLibrary.addSuccessfully);
        }
      }
    }
  }

  void updateSelectedStatus(String url) {
    if (selectedList.contains(url)) {
      selectedList.remove(url);
    } else {
      selectedList.add(url);
    }
  }

  void manage() {
    selectedList.clear();
    isMultiModel.value = !isMultiModel.value;
  }

  void delete() {
    if (selectedList.isNotEmpty) {
      cacheLogic.delFavoriteList(selectedList);
      selectedList.clear();
    }
  }

  bool isChecked(String url) => selectedList.contains(url);
}
