import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';

import 'm_pages.dart';

class MNavigator {
  static Future<T?>? startMeeting<T>() => Get.toNamed(MRoutes.meeting);

  static Future<T?>? startJoinMeeting<T>() => Get.toNamed(MRoutes.joinMeeting);

  static startBookMeeting({
    MeetingInfo? meetingInfo,
    bool offAndToNamed = false,
  }) {
    final args = {'meetingInfo': meetingInfo};
    return offAndToNamed
        ? Get.offAndToNamed(MRoutes.bookMeeting, arguments: args)
        : Get.toNamed(MRoutes.bookMeeting, arguments: args);
  }

  static startMeetingDetail(
    MeetingInfo meetingInfo,
    String meetingCreator, {
    bool offAndToNamed = false,
  }) {
    final args = {'meetingInfo': meetingInfo, 'meetingCreator': meetingCreator};
    return offAndToNamed
        ? Get.offAndToNamed(MRoutes.meetingDetail, arguments: args)
        : Get.toNamed(MRoutes.meetingDetail, arguments: args);
  }
}
