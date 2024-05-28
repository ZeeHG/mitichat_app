import 'package:common_utils/common_utils.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

class MitiIDChangeEntryLogic extends GetxController {
  final Rx<MitiIDChangeRecord?> latestRecord = Rx<MitiIDChangeRecord?>(null);
  final enable = true.obs;

  String get dateTips => latestRecord.value != null
      ? sprintf(StrLibrary.changeMitiIDDateTips, [
          DateUtil.formatDateMs(latestRecord.value!.updateTime * 1000,
              format: "yyyy.MM.dd"),
          DateUtil.formatDateMs(
              latestRecord.value!.updateTime * 1000 + 365 * 24 * 60 * 60 * 1000,
              format: "yyyy.MM.dd")
        ])
      : "";

  @override
  void onInit() {
    loadingData();
    super.onInit();
  }

  mitiIDChange() {
    AppNavigator.startMitiIDChange();
  }

  loadingData() async {
    LoadingView.singleton.start(fn: () async {
      final result = await ClientApis.queryUpdateMitiIDRecords();
      if (result.isNotEmpty) {
        latestRecord.value = result[0];
        enable.value = DateTime.now().millisecondsSinceEpoch -
                latestRecord.value!.updateTime * 1000 >
            365 * 24 * 60 * 60 * 1000;
      }
    });
  }
}
