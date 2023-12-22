import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';

import '../../../../routes/app_navigator.dart';
import '../../group_profile_panel/group_profile_panel_logic.dart';
import '../tag_notification_issued_logic.dart';

class TagNotificationDetailLogic extends GetxController {
  final logic = Get.find<TagNotificationIssuedLogic>();
  late TagNotification notification;
  late TagNotificationContent content;
  TextElem? textElem;
  SoundElem? soundElem;
  final list = <dynamic>[];

  @override
  void onInit() {
    notification = Get.arguments['notification'];
    content = notification.parseContent()!;
    textElem = content.textElem;
    soundElem = content.soundElem;
    list
      ..addAll(notification.users ?? [])
      ..addAll(notification.groups ?? [])
      ..addAll(notification.tags ?? []);
    super.onInit();
  }

  playVoiceMessage() => logic.playVoiceMessage(notification);

  isPlaySound() => logic.isPlaySound(notification);

  @override
  void onClose() {
    // logic.stopVoiceMessage(notification);
    super.onClose();
  }

  void againSend() async {
    await LoadingView.singleton.wrap(asyncFunction: () async {
      await Apis.sendTagNotification(
        textElem: textElem,
        soundElem: soundElem,
        tagIDList: notification.tags?.map((e) => e.tagID!).toList() ?? [],
        userIDList: notification.users?.map((e) => e.userID!).toList() ?? [],
        groupIDList: notification.groups?.map((e) => e.groupID).toList() ?? [],
      );
    });
    IMViews.showToast(StrRes.sendSuccessfully);
    Get.back(result: true);
  }

  void viewMember(info) {
    if (info is ConversationInfo) {
      if (info.isSingleChat) {
        AppNavigator.startUserProfilePane(
          userID: info.userID!,
          nickname: info.showName,
          faceURL: info.faceURL,
        );
      } else {
        AppNavigator.startGroupProfilePanel(
          groupID: info.groupID!,
          joinGroupMethod: JoinGroupMethod.search,
        );
      }
    } else if (info is GroupInfo) {
      AppNavigator.startGroupProfilePanel(
        groupID: info.groupID,
        joinGroupMethod: JoinGroupMethod.search,
      );
    } else if (info is UserInfo) {
      AppNavigator.startUserProfilePane(
        userID: info.userID!,
        nickname: info.nickname,
        faceURL: info.faceURL,
      );
    } else if (info is TagInfo) {
      // AppNavigator.startCreateTagGroup(tagInfo: info);
    }
  }
}
