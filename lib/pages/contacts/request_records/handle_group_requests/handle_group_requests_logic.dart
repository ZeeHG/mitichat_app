import 'package:flutter/services.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:get/get.dart';
import 'package:miti/pages/contacts/request_records/request_records_logic.dart';
import 'package:miti_common/miti_common.dart';

class HandleGroupRequestsLogic extends GetxController {
  final requestRecordsLogic = Get.find<RequestRecordsLogic>();
  late GroupApplicationInfo applicationInfo;

  @override
  void onInit() {
    super.onInit();
    applicationInfo = Get.arguments['applicationInfo'];
  }

  bool get isInvite => requestRecordsLogic.isInvite(applicationInfo);

  String get groupName => requestRecordsLogic.getGroupName(applicationInfo);

  String get inviterNickname =>
      requestRecordsLogic.getInviterNickname(applicationInfo);

  GroupMembersInfo? getMemberInfo(inviterUserID) =>
      requestRecordsLogic.getMemberInfo(inviterUserID);

  UserInfo? getUserInfo(inviterUserID) =>
      requestRecordsLogic.getUserInfo(inviterUserID);

  /// 2：通过邀请  3：通过搜索  4：通过二维码
  String get sourceFrom {
    if (applicationInfo.joinSource == 2) {
      return '$inviterNickname${StrLibrary.byMemberInvite}';
    } else if (applicationInfo.joinSource == 4) {
      return StrLibrary.byScanQrcode;
    }
    return StrLibrary.bySearch;
  }

  void approve() {
    LoadingView.singleton.start(fn: () async {
      await OpenIM.iMManager.groupManager.acceptGroupApplication(
        groupID: applicationInfo.groupID!,
        userID: applicationInfo.userID!,
        handleMsg: "reason",
      );
      Get.back(result: 1);
    }).catchError(handleError);
  }

  void reject() {
    LoadingView.singleton
        .start(fn: () async {
          await OpenIM.iMManager.groupManager.refuseGroupApplication(
            groupID: applicationInfo.groupID!,
            userID: applicationInfo.userID!,
            handleMsg: "reason",
          );
          Get.back(result: -1);
        })
        .catchError(handleError)
        .catchError((_) => showToast(StrLibrary.rejectFailed));
  }

  handleError(e) {
    if (e is PlatformException) {
      if (e.code == '${SDKErrorCode.groupApplicationHasBeenProcessed}') {
        showToast(StrLibrary.groupRequestHandled);
        return;
      }
    }
    throw e;
  }
}
