import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_live/miti_live.dart';

import '../../../core/controller/im_controller.dart';

class CallRecordsLogic extends GetxController {
  final cacheLogic = Get.find<CacheController>();
  final imLogic = Get.find<IMController>();
  // final meetingInfoList = <MeetingInfo>[].obs;
  final nicknameMapping = <String, String>{}.obs;
  final index = 0.obs;
  // final rtcIsBusy = PackageBridge.rtcBridge?.hasConnection == true || PackageBridge.meetingBridge?.hasConnection == true;
  final rtcIsBusy = PackageBridge.rtcBridge?.hasConnection == true;

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onClose() {
    super.onClose();
  }

  Future<bool> remove(CallRecords records) async {
    await cacheLogic.deleteCallRecords(records);
    return true;
  }

  void switchTab(index) {
    this.index.value = index;
  }

  void call(CallRecords records) {
    if (rtcIsBusy) {
      IMViews.showToast(StrLibrary.callingBusy);
      return;
    }
    IMViews.openIMCallSheet(records.nickname, (index) {
      imLogic.call(
        callObj: CallObj.single,
        callType: index == 0 ? CallType.audio : CallType.video,
        inviteeUserIDList: [records.userID],
      );
    });
  }
}
