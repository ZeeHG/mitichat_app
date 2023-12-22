import 'package:common_utils/common_utils.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../openim_meeting.dart';

class MeetingDetailLogic extends GetxController {
  late MeetingInfo meetingInfo;
  late String meetingCreator;
  late int startTime;
  late int endTime;

  SelectContactsBridge? get bridge => PackageBridge.selectContactsBridge;

  @override
  void onInit() {
    meetingInfo = Get.arguments['meetingInfo'];
    meetingCreator = Get.arguments['meetingCreator'];
    startTime = meetingInfo.startTime! * 1000;
    endTime = meetingInfo.endTime! * 1000;
    super.onInit();
  }

  String get meetingStartTime =>
      DateUtil.formatDateMs(startTime, format: 'HH:mm');

  String get meetingEndTime => DateUtil.formatDateMs(endTime, format: 'HH:mm');

  String get meetingStartDate =>
      DateUtil.formatDateMs(startTime, format: IMUtils.getTimeFormat1());

  String get meetingEndDate =>
      DateUtil.formatDateMs(endTime, format: IMUtils.getTimeFormat1());

  String get meetingNo => meetingInfo.roomID ?? '';

  String get meetingDuration {
    final offset = meetingInfo.endTime! - meetingInfo.startTime!;
    return '${offset ~/ 60}${StrRes.minute}';
  }

  bool isStartedMeeting() {
    final start = DateUtil.getDateTimeByMs(meetingInfo.startTime! * 1000);
    final now = DateTime.now();
    return start.difference(now).isNegative;
  }

  void copy() {
    IMUtils.copy(text: meetingInfo.roomID!);
  }

  enterMeeting() =>
      MeetingClient().join(Get.context!, meetingID: meetingInfo.roomID!);

  shareMeeting() async {
    final meetingID = meetingInfo.roomID!;
    final meetingName = meetingInfo.meetingName!;
    final startTime = meetingInfo.startTime!;
    final duration = meetingInfo.endTime! - meetingInfo.startTime!;
    Logger.print('metaData meetingID : $meetingID');
    Logger.print('metaData meetingName : $meetingName');
    Logger.print('metaData startTime : $startTime');
    Logger.print('metaData duration : $duration');
    final result = await bridge?.selectContacts(2);
    if (result is Map) {
      final list = IMUtils.convertCheckedListToShare(result.values);
      await LoadingView.singleton.wrap(
          asyncFunction: () => Future.forEach(
                list,
                (map) => MeetingClient().invite(
                  userID: map['userID'],
                  groupID: map['groupID'],
                  meetingID: meetingID,
                  meetingName: meetingName,
                  startTime: startTime,
                  duration: duration,
                ),
              ));
      IMViews.showToast('分享成功');
    }
  }

  editMeeting() {
    Get.bottomSheet(
      BottomSheetView(
        items: [
          SheetItem(label: StrRes.updateMeetingInfo, onTap: _modifyMeetingInfo),
          SheetItem(
            label: StrRes.cancelMeeting,
            textStyle: Styles.ts_FF381F_17sp,
            onTap: _cancelMeeting,
          ),
        ],
      ),
    );
  }

  _cancelMeeting() async {
    try {
      await LoadingView.singleton.wrap(
          asyncFunction: () =>
              OpenIM.iMManager.signalingManager.signalingCloseRoom(
                roomID: meetingInfo.roomID!,
              ));
      Get.back();
    } catch (e, s) {
      Logger.print('error: $e,  stack: $s');
      if (e.toString().contains('NotExist')) {
        IMViews.showToast("会议已经结束！");
      } else {
        IMViews.showToast("网络异常请稍后再试！");
      }
    }
  }

  _modifyMeetingInfo() => MNavigator.startBookMeeting(
        meetingInfo: meetingInfo,
        offAndToNamed: true,
      );
}
