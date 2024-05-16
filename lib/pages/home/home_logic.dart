import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:miti/pages/contacts/contacts_logic.dart';
import 'package:miti/pages/xhs/xhs_logic.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_circle/miti_circle.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/ctrl/app_ctrl.dart';
import '../../core/ctrl/im_ctrl.dart';
import '../../core/ctrl/push_ctrl.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../../widgets/screen_lock_error_view.dart';

class HomeLogic extends SuperController with FriendCircleBridge {
  final pushCtrl = Get.find<PushCtrl>();
  final imCtrl = Get.find<IMCtrl>();
  final cacheLogic = Get.find<HiveCtrl>();
  final appCtrl = Get.find<AppCtrl>();
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final unreadMomentsCount = 0.obs;
  final unhandledFriendApplicationCount = 0.obs;
  final unhandledGroupApplicationCount = 0.obs;
  final unhandledFriendAndGroupCount = 0.obs;
  String? _lockScreenPwd;
  bool _isShowScreenLock = false;
  late bool _isAutoLogin;
  final auth = LocalAuthentication();
  final _errorController = PublishSubject<String>();
  final aiUtil = Get.find<AiUtil>();
  final xhsLogic = Get.find<XhsLogic>();
  final accountUtil = Get.find<AccountUtil>();
  final unHandleInviteCount = 0.obs;

  Function()? onscrollToUnreadConversation;

  switchTab(dynamic index) {
    this.index.value = index;
    if (index == 1) {
      ClientApis.addActionRecord(actionRecordList: [
        ActionRecord(
            category: ActionCategory.discover,
            actionName: ActionName.enter_discover)
      ]);
    }
  }

  void viewDiscover(index) async {
    await CircleNavigator.startWorkMomentsList();
    // 发布完xhs刷新
    xhsLogic.refreshWorkingCircleList();
    getUnreadMomentsCount();
  }

  scrollToUnreadConversation(index) {
    onscrollToUnreadConversation?.call();
  }

  getUnreadMomentsCount() {
    CircleApis.getUnreadCount()
        .then((value) => unreadMomentsCount.value = value);
  }

  getUnHandleInviteCount() async {
    final result = await ClientApis.queryApplyActiveList();
    unHandleInviteCount.value =
        (null == result?["total"] || result?["total"] == 0) ? 0 : 1;
  }

  getUnreadMsgCount() {
    OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount().then((count) {
      unreadMsgCount.value = int.tryParse(count) ?? 0;
    });
  }

  /// 获取好友申请未处理数
  /// 浏览过得不再计入红点
  void getUnhandledFriendApplicationCount() async {
    var i = 0;
    var list = await OpenIM.iMManager.friendshipManager
        .getFriendApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleFriendApplication() ?? [];
    for (var info in list) {
      var id = MitiUtils.buildFriendApplicationID(info);
      if (!haveReadList.contains(id) && info.handleResult == 0) {
        i++;
      }
    }
    unhandledFriendApplicationCount.value = i;
    // 待处理的未读未处理总数
    unhandledFriendAndGroupCount.value =
        unhandledGroupApplicationCount.value + i;
  }

  /// 获取群申请未处理数
  void getUnhandledGroupApplicationCount() async {
    var i = 0;
    var list = await OpenIM.iMManager.groupManager
        .getGroupApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleGroupApplication() ?? [];
    for (var info in list) {
      var id = MitiUtils.buildGroupApplicationID(info);
      if (!haveReadList.contains(id) && info.handleResult == 0) {
        i++;
      }
    }
    unhandledGroupApplicationCount.value = i;
    // 待处理的未读未处理总数
    unhandledFriendAndGroupCount.value =
        unhandledFriendApplicationCount.value + i;
  }

  void _getRTCInvitationStart() async {
    final signalingInfo = await OpenIM.iMManager.signalingManager
        .getSignalingInvitationInfoStartApp();
    if (null != signalingInfo.invitation) {
      // 调用视频界面
      imCtrl.receiveNewInvitation(signalingInfo);
    }
  }

  _localAuth() async {
    final didAuthenticate = await MitiUtils.checkingBiometric(auth);
    if (didAuthenticate) {
      Get.back();
    }
  }

  _showLockScreenPwd() async {
    if (_isShowScreenLock) return;
    _lockScreenPwd = DataSp.getLockScreenPassword();
    if (null != _lockScreenPwd) {
      final isEnabledBiometric = DataSp.isEnabledBiometric() == true;
      bool enabled = false;
      if (isEnabledBiometric) {
        final isSupportedBiometrics = await auth.isDeviceSupported();
        final canCheckBiometrics = await auth.canCheckBiometrics;
        enabled = isSupportedBiometrics && canCheckBiometrics;
      }
      _isShowScreenLock = true;
      screenLock(
        context: Get.context!,
        correctString: _lockScreenPwd!,
        maxRetries: 3,
        title: ScreenLockErrorView(stream: _errorController.stream),
        canCancel: false,
        customizedButtonChild: enabled ? const Icon(Icons.fingerprint) : null,
        customizedButtonTap: enabled ? () async => await _localAuth() : null,
        // onOpened: enabled ? () async => await _localAuth() : null,
        onUnlocked: () {
          _isShowScreenLock = false;
          Get.back();
        },
        onMaxRetries: (_) async {
          Get.back();
          await LoadingView.singleton.start(fn: () async {
            await accountUtil.tryLogout();
            await DataSp.clearLockScreenPassword();
            await DataSp.closeBiometric();
          });
          AppNavigator.startLogin();
        },
        onError: (retries) {
          _errorController.sink.add(
            retries.toString(),
          );
        },
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    index.value = Get.arguments['index'] ?? 0;
    _isAutoLogin = Get.arguments['isAutoLogin'];

    MitiBridge.friendCircleBridge = this;

    if (_isAutoLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLockScreenPwd());
    }

    aiUtil.init();
    getUnreadMsgCount();
    getUnhandledFriendApplicationCount();
    getUnhandledGroupApplicationCount();
    getUnreadMomentsCount();
    getUnHandleInviteCount();

    imCtrl.unreadMsgCountEventSubject.listen((value) {
      unreadMsgCount.value = value;
    });
    imCtrl.friendApplicationChangedSubject.listen((value) {
      getUnhandledFriendApplicationCount();
    });
    imCtrl.groupApplicationChangedSubject.listen((value) {
      getUnhandledGroupApplicationCount();
    });
    imCtrl.momentsSubject.listen((value) {
      onRecvNewMessageForWorkingCircle?.call(value);
      getUnreadMomentsCount();
    });

    imCtrl.inviteApplySubject.listen((json) {
      if ("invite_apply" == json["key"] &&
          json["user"]?["userID"] == imCtrl.userInfo.value.userID) {
        return;
      }
      unHandleInviteCount.value = 1;
      appCtrl.promptInviteNotification(json);
    });

    imCtrl.inviteApplyHandleSubject.listen((json) {
      if ("invite_apply_handle" == json["key"] &&
          json["inviteUser"]?["userID"] == imCtrl.userInfo.value.userID) {
        return;
      }
      appCtrl.promptInviteHandleNotification(json);
    });
  }

  @override
  void onReady() {
    super.onReady();
    cacheLogic.initCallRecords();
    cacheLogic.initFavoriteEmoji();
    Future.delayed(Duration(milliseconds: 500), () {
      MitiBridge.friendCircleBridge = this;
      final contactsLogic = Get.find<ContactsLogic>();
      contactsLogic.initPackageBridge();
    });
  }

  @override
  void onClose() {
    super.onClose();
    MitiBridge.friendCircleBridge = null;
    _errorController.close();
  }

  @override
  void onDetached() {
    // TODO: implement onDetached
  }

  @override
  void onInactive() {
    // TODO: implement onInactive
  }

  @override
  void onPaused() {
    // TODO: implement onPaused
  }

  @override
  void onResumed() {
    if (imCtrl.imSdkStatusSubject.valueOrNull ==
        IMSdkStatus.connectionSucceeded) {
      _getRTCInvitationStart();
    } else {
      imCtrl.imSdkStatusSubject.listen((value) {
        if (value == IMSdkStatus.connectionSucceeded) {
          _getRTCInvitationStart();
        }
      });
    }
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
