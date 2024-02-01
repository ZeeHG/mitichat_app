import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../meeting_client.dart';

class JoinMeetingLogic extends GetxController {
  final meetingNumberCtrl = TextEditingController();
  final yourNameCtrl = TextEditingController();
  final enabled = false.obs;

  @override
  void onInit() {
    meetingNumberCtrl.addListener(() {
      enabled.value = meetingNumberCtrl.text.trim().isNotEmpty;
    });
    super.onInit();
  }

  @override
  void onClose() {
    meetingNumberCtrl.dispose();
    yourNameCtrl.dispose();
    super.onClose();
  }

  // void joinMeeting() => MeetingHelper.joinMeeting(
  //       meetingID: meetingNumberCtrl.text,
  //       participantNickname: yourNameCtrl.text,
  //     );
  void joinMeeting() => MeetingClient().join(
        Get.context!,
        meetingID: meetingNumberCtrl.text,
        participantNickname: yourNameCtrl.text,
      );
}
