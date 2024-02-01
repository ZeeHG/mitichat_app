import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:openim_common/openim_common.dart';
import 'package:uuid/uuid.dart';

import '../../../../routes/app_navigator.dart';
import '../../select_contacts/select_contacts_logic.dart';

class BuildTagNotificationLogic extends GetxController {
  final textEditingCtrl = TextEditingController();
  final focusNode = FocusNode();
  final list = [].obs;
  final enabled = false.obs;

  @override
  void onClose() {
    textEditingCtrl.dispose();
    focusNode.dispose();
    super.onClose();
  }

  selectIssuedMember() async {
    final result = await AppNavigator.startSelectContacts(
      action: SelAction.notificationIssued,
      checkedList: list.value,
    );
    if (result is Map) {
      list.assignAll(result.values);
      enabled.value = list.isNotEmpty;
    }
  }

  removeIssuedMember(info) {
    list.remove(info);
    enabled.value = list.isNotEmpty;
  }

  void sendTextNotification() async {
    final content = textEditingCtrl.text.trim();
    if (content.isEmpty) {
      IMViews.showToast(StrRes.contentNotBlank);
      return;
    }
    final map = buildApiParams();
    await LoadingView.singleton.wrap(
      asyncFunction: () => Apis.sendTagNotification(
        textElem: TextElem(content: content),
        tagIDList: map['tagIDList'] ?? [],
        userIDList: map['userIDList'] ?? [],
        groupIDList: map['groupIDList'] ?? [],
      ),
    );
    IMViews.showToast(StrRes.sendSuccessfully);
    Get.back(result: true);
  }

  sendSoundNotification(int sec, String path) async {
    await LoadingView.singleton.wrap(asyncFunction: () async {
      final result = await OpenIM.iMManager.uploadFile(
        id: const Uuid().v4(),
        filePath: path,
        fileName: path,
      );
      String? url;
      if (result is String) {
        url = jsonDecode(result)['url'];
        Logger.print('url:$url');
      }
      if (null != url) {
        final map = buildApiParams();
        await Apis.sendTagNotification(
          soundElem: SoundElem(
            uuid: const Uuid().v4(),
            sourceUrl: url,
            duration: sec,
          ),
          tagIDList: map['tagIDList'] ?? [],
          userIDList: map['userIDList'] ?? [],
          groupIDList: map['groupIDList'] ?? [],
        );
      }
    });
    IMViews.showToast(StrRes.sendSuccessfully);
    Get.back(result: true);
  }

  void onTapAlbum() {}

  void onTapCamera() {}

  void onTapFile() {}

  void onTapCard() {}

  void onTapLocation() {}

  Map<String, List<String>> buildApiParams() {
    final tagIDList = <String>[];
    final userIDList = <String>[];
    final groupIDList = <String>[];
    for (var info in list) {
      if (info is ConversationInfo) {
        if (info.isSingleChat) {
          userIDList.add(info.userID!);
        } else {
          groupIDList.add(info.groupID!);
        }
      } else if (info is GroupInfo) {
        groupIDList.add(info.groupID);
      } else if (info is UserInfo) {
        userIDList.add(info.userID!);
      } else if (info is TagInfo) {
        tagIDList.add(info.tagID!);
      }
    }
    return {"tagIDList": tagIDList, "userIDList": userIDList, "groupIDList": groupIDList};
  }
}
