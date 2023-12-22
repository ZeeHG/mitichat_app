import 'package:common_utils/common_utils.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:openim_meeting/openim_meeting.dart';
import 'package:sprintf/sprintf.dart';

class MeetingLogic extends GetxController {
  final meetingInfoList = <MeetingInfo>[].obs;
  final nicknameMapping = <String, String>{}.obs;

  @override
  void onReady() {
    // queryUnfinishedMeeting();
    super.onReady();
  }

  Future<MeetingInfoList> _queryUnfinishedMeeting() => OpenIM.iMManager.signalingManager.signalingGetMeetings();

  Future<List<UserInfo>> _queryMeetingHostUserInfo(MeetingInfoList info) async {
    final users = await OpenIM.iMManager.userManager.getUsersInfo(userIDList: info.meetingInfoList!.map((e) => e.hostUserID!).toList());

    return users.map((e) => e.simpleUserInfo).toList();
  }

  void queryUnfinishedMeeting() async {
    final list = await LoadingView.singleton.wrap(asyncFunction: () async {
      final info = await _queryUnfinishedMeeting();
      if (info.meetingInfoList != null) {
        final userInfoList = await _queryMeetingHostUserInfo(info);
        for (var u in userInfoList) {
          nicknameMapping[u.userID!] = u.getShowName();
        }
        return info.meetingInfoList!;
      }
      return <MeetingInfo>[];
    });
    meetingInfoList.assignAll(list);
  }

  String getMeetingCreateDate(MeetingInfo meetingInfo) {
    return DateUtil.formatDateMs(
      meetingInfo.startTime! * 1000,
      format: Get.locale?.languageCode == 'zh' ? 'MM月dd日' : 'MM/dd',
    );
  }

  String getMeetingDuration(MeetingInfo meetingInfo) {
    final startTime = DateUtil.formatDateMs(
      meetingInfo.startTime! * 1000,
      format: 'HH:mm',
    );
    final endTime = DateUtil.formatDateMs(
      meetingInfo.endTime! * 1000,
      format: 'HH:mm',
    );
    return "$startTime - $endTime";
  }

  bool isStartedMeeting(MeetingInfo meetingInfo) {
    final start = DateUtil.getDateTimeByMs(meetingInfo.startTime! * 1000);
    final now = DateTime.now();
    return start.difference(now).isNegative;
  }

  String getMeetingSubject(MeetingInfo meetingInfo) {
    if (meetingInfo.meetingName != null && meetingInfo.meetingName!.isEmpty) {
      meetingInfo.meetingName = null;
    }
    return meetingInfo.meetingName ?? getTitle(meetingInfo);
  }

  String getTitle(MeetingInfo meetingInfo) {
    final nickname = nicknameMapping[meetingInfo.hostUserID];
    if (null != nickname) {
      return sprintf(StrRes.meetingInitiatorIs, [nickname]);
    }
    return meetingInfo.meetingName!;
  }

  String getMeetingOrganizer(MeetingInfo meetingInfo) {
    return sprintf(StrRes.meetingOrganizerIs, [nicknameMapping[meetingInfo.hostUserID]]);
  }

  void joinMeeting() => MNavigator.startJoinMeeting();

  void bookMeeting() => MNavigator.startBookMeeting();

  void meetingDetail(MeetingInfo meetingInfo) => MNavigator.startMeetingDetail(
        meetingInfo,
        nicknameMapping[meetingInfo.hostUserID] ?? '',
      );

  void quickMeeting() => MeetingClient().create(
        Get.context!,
        meetingName: _meetingName,
        startTime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        duration: 1 * 60 * 60,
      );

  String get _meetingName => sprintf(StrRes.meetingInitiatorIs, [OpenIM.iMManager.userInfo.nickname]);
// void quickMeeting() => MeetingHelper.createMeeting(
//       meetingName: sprintf(
//           StrRes.meetingInitiatorIs, [OpenIM.iMManager.uInfo.nickname]),
//       startTime: DateTime.now().millisecondsSinceEpoch ~/ 1000,
//       duration: 1 * 60 * 60,
//     );
}
