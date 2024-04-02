import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/chat/chat_setup/chat_history/media/media_logic.dart';
import 'package:miti_common/miti_common.dart';
import 'package:sprintf/sprintf.dart';

import '../../../core/ctrl/app_ctrl.dart';
import '../../../core/ctrl/im_ctrl.dart';
import '../../../routes/app_navigator.dart';
import '../chat_logic.dart';

class ChatSetupLogic extends GetxController {
  // final chatLogic = Get.find<ChatLogic>();
  final chatLogic = Get.find<ChatLogic>(tag: GetTags.chat);
  final appCtrl = Get.find<AppCtrl>();
  final imCtrl = Get.find<IMCtrl>();
  final translateLogic = Get.find<TranslateLogic>();
  late Rx<ConversationInfo> conversationInfo;
  late StreamSubscription ccSub;
  late StreamSubscription fcSub;

  String get conversationID => conversationInfo.value.conversationID;

  bool get isPinned => conversationInfo.value.isPinned == true;

  bool get isBurnAfterReading => conversationInfo.value.isPrivateChat == true;

  bool get isAutoTranslate => translateLogic.isAutoTranslate(conversationID);

  String? get targetLang => translateLogic.getTargetLang(conversationID);

  bool get isMsgDestruct => conversationInfo.value.isMsgDestruct == true;

  bool get isNotDisturb => conversationInfo.value.recvMsgOpt != 0;

  int get burnDuration => conversationInfo.value.burnDuration ?? 30;

  int get destructDuration =>
      conversationInfo.value.msgDestructTime ?? 7 * 24 * 60 * 60;

  String get getBurnAfterReadingDurationStr {
    int day = 1 * 24 * 60 * 60;
    int hour = 1 * 60 * 60;
    int fiveMinutes = 5 * 60;
    if (burnDuration == day) {
      return StrLibrary.oneDay;
    } else if (burnDuration == hour) {
      return StrLibrary.oneHour;
    } else if (burnDuration == fiveMinutes) {
      return StrLibrary.fiveMinutes;
    } else {
      return StrLibrary.thirtySeconds;
    }
  }

  String get targetLangStr => translateLogic.getTargetLangStr(targetLang);

  String get getDestructDurationStr {
    int day = 1 * 24 * 60 * 60;
    int week = 7 * day;
    int month = 1 * 30 * day;
    if (destructDuration % month == 0) {
      return sprintf(StrLibrary.nMonth, [destructDuration ~/ month]);
    } else if (destructDuration % week == 0) {
      return sprintf(StrLibrary.nWeek, [destructDuration ~/ week]);
    } else {
      return sprintf(StrLibrary.nDay, [destructDuration ~/ day]);
    }
  }

  @override
  void onClose() {
    ccSub.cancel();
    fcSub.cancel();
    super.onClose();
  }

  @override
  void onInit() {
    conversationInfo = Rx(Get.arguments['conversationInfo']);
    ccSub = imCtrl.conversationChangedSubject.listen((newList) {
      for (var newValue in newList) {
        if (newValue.conversationID == conversationID) {
          conversationInfo.update((val) {
            val?.burnDuration = newValue.burnDuration ?? 30;
            val?.isPrivateChat = newValue.isPrivateChat;
            val?.isPinned = newValue.isPinned;
            // 免打扰 0：正常；1：不接受消息；2：接受在线消息不接受离线消息；
            val?.recvMsgOpt = newValue.recvMsgOpt;
            val?.isMsgDestruct = newValue.isMsgDestruct;
            val?.msgDestructTime = newValue.msgDestructTime;
          });
          break;
        }
      }
    });
    // 好友信息变化
    fcSub = imCtrl.friendInfoChangedSubject.listen((value) {
      if (conversationInfo.value.userID == value.userID) {
        conversationInfo.update((val) {
          val?.showName = value.getShowName();
          val?.faceURL = value.faceURL;
        });
      }
    });
    super.onInit();
  }

  void toggleTopContacts() async {
    await LoadingView.singleton.start(
      fn: () => OpenIM.iMManager.conversationManager.pinConversation(
        conversationID: conversationID,
        isPinned: !isPinned,
      ),
    );
  }

  /// 消息免打扰 0：正常；1：不接受消息；2：接受在线消息不接受离线消息；
  void toggleNotDisturb() {
    LoadingView.singleton.start(
        fn: () =>
            OpenIM.iMManager.conversationManager.setConversationRecvMessageOpt(
              conversationID: conversationID,
              status: !isNotDisturb ? 2 : 0,
            ));
  }

  /// 阅后即焚
  void toggleBurnAfterReading() {
    LoadingView.singleton.start(fn: () async {
      await OpenIM.iMManager.conversationManager.setConversationPrivateChat(
        conversationID: conversationID,
        isPrivate: !isBurnAfterReading,
      );
    });
  }

  void toggleAutoTranslate() {
    translateLogic.updateLangConfig(
        conversation: conversationInfo.value,
        data: {"autoTranslate": !isAutoTranslate});
  }

  void setTargetLang() {
    translateLogic.setTargetLang(conversationInfo.value);
  }

  void setBurnAfterReadingDuration() async {
    IMViews.showSinglePicker(
      title: StrLibrary.burnAfterReading,
      description: StrLibrary.burnAfterReadingDescription,
      pickerData: [
        StrLibrary.thirtySeconds,
        StrLibrary.fiveMinutes,
        StrLibrary.oneHour,
        StrLibrary.oneDay,
      ],
      onConfirm: (indexList, valueList) {
        final index = indexList.firstOrNull;
        if (index == 0) {
          setConversationBurnDuration(30);
        } else if (index == 1) {
          setConversationBurnDuration(5 * 60);
        } else if (index == 2) {
          setConversationBurnDuration(60 * 60);
        } else if (index == 3) {
          setConversationBurnDuration(24 * 60 * 60);
        }
      },
    );
    // final result = await Get.bottomSheet(
    //   BottomSheetView(
    //     items: [
    //       SheetItem(
    //         label: StrLibrary .thirtySeconds,
    //         result: 30,
    //       ),
    //       SheetItem(
    //         label: StrLibrary .fiveMinutes,
    //         result: 5 * 60,
    //       ),
    //       SheetItem(
    //         label: StrLibrary .oneHour,
    //         result: 60 * 60,
    //       ),
    //       SheetItem(
    //         label: StrLibrary .oneDay,
    //         result: 24 * 60 * 60,
    //       ),
    //     ],
    //   ),
    // );
    // if (result is int) {
    //   LoadingView.singleton.start(
    //       fn: () => OpenIM.iMManager.conversationManager
    //           .setConversationBurnDuration(
    //               conversationID: conversationID, burnDuration: result));
    // }
  }

  void setConversationBurnDuration(int duration) {
    LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.conversationManager
            .setConversationBurnDuration(
                conversationID: conversationID, burnDuration: duration));
  }

  void toggleDestructMessage() {
    LoadingView.singleton.start(fn: () async {
      await OpenIM.iMManager.conversationManager.setConversationIsMsgDestruct(
        conversationID: conversationID,
        isMsgDestruct: !isMsgDestruct,
      );
    });
  }

  void setDestructMessageDuration() async {
    IMViews.showSinglePicker(
      title: StrLibrary.periodicallyDeleteMessage,
      description: StrLibrary.periodicallyDeleteMessageDescription,
      pickerData: [
        [1, 2, 3, 4, 5, 6],
        [
          sprintf(StrLibrary.nDay, ['']).trim(),
          sprintf(StrLibrary.nWeek, ['']).trim(),
          sprintf(StrLibrary.nMonth, ['']).trim(),
        ]
      ],
      isArray: true,
      // selected: [2, 2],
      onConfirm: (indexList, valueList) {
        int day = 1 * 24 * 60 * 60;
        int week = 7 * day;
        int month = 1 * 30 * day;
        int valueIndex = indexList.firstOrNull ?? 0;
        int unitIndex = indexList.lastOrNull ?? 0;
        if (unitIndex == 0) {
          setConversationMsgDestructTime((valueIndex + 1) * day);
        } else if (unitIndex == 1) {
          setConversationMsgDestructTime((valueIndex + 1) * week);
        } else if (unitIndex == 2) {
          setConversationMsgDestructTime((valueIndex + 1) * month);
        }
      },
    );
  }

  void setConversationMsgDestructTime(int duration) {
    LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.conversationManager
            .setConversationMsgDestructTime(
                conversationID: conversationID, duration: duration));
  }

  void clearChatHistory() async {
    var confirm = await Get.dialog(CustomDialog(
      title: StrLibrary.confirmClearChatHistory,
      rightText: StrLibrary.clearAll,
    ));
    if (confirm == true) {
      await LoadingView.singleton.start(
        fn: () => OpenIM.iMManager.conversationManager
            .clearConversationAndDeleteAllMsg(
          conversationID: conversationID,
        ),
      );
      chatLogic.clearAllMessage();
      showToast(StrLibrary.clearSuccessfully);
    }
  }

  void createGroup() => AppNavigator.startCreateGroup(defaultCheckedList: [
        UserInfo(
          userID: conversationInfo.value.userID,
          faceURL: conversationInfo.value.faceURL,
          nickname: conversationInfo.value.showName,
        ),
        OpenIM.iMManager.userInfo,
      ]);

  // void setFontSize() => AppNavigator.startSetFontSize();

  void backgroundSetting() => AppNavigator.startBackgroundSetting();

  void chatHistory() => AppNavigator.startChatHistory(
        conversationInfo: conversationInfo.value,
      );

  void chatHistoryPicture() => AppNavigator.startChatHistoryMedia(
        conversationInfo: conversationInfo.value,
      );

  void chatHistoryVideo() => AppNavigator.startChatHistoryMedia(
        conversationInfo: conversationInfo.value,
        multimediaType: MultimediaType.video,
      );

  void complaint() {
    AppNavigator.startComplaint(params: {
      "userID": conversationInfo.value.userID!,
      "complaintType": ComplaintType.user,
    });
  }

  void chatHistoryFile() => AppNavigator.startChatHistoryFile(
        conversationInfo: conversationInfo.value,
      );

  void viewUserInfo() => AppNavigator.startUserProfilePane(
        userID: conversationInfo.value.userID!,
        nickname: conversationInfo.value.showName,
        faceURL: conversationInfo.value.faceURL,
      );
}
