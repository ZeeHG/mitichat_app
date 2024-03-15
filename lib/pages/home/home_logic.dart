import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screen_lock/flutter_screen_lock.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import 'package:miti/pages/contacts/contacts_logic.dart';
import 'package:miti/pages/xhs/xhs_logic.dart';
import 'package:miti/utils/ai_util.dart';
import 'package:miti_common/miti_common.dart';
import 'package:miti_circle/miti_circle.dart';
import 'package:miti_circle/src/w_apis.dart';
import 'package:rxdart/rxdart.dart';

import '../../core/controller/app_ctrl.dart';
import '../../core/controller/im_controller.dart';
import '../../core/controller/push_controller.dart';
import '../../core/im_callback.dart';
import '../../routes/app_navigator.dart';
import '../../widgets/screen_lock_error_view.dart';

class HomeLogic extends SuperController with WorkingCircleBridge {
  final pushLogic = Get.find<PushController>();
  final imLogic = Get.find<IMController>();
  final cacheLogic = Get.find<CacheController>();
  final appCtrl = Get.find<AppCtrl>();
  final index = 0.obs;
  final unreadMsgCount = 0.obs;
  final unreadMomentsCount = 0.obs;
  final unhandledFriendApplicationCount = 0.obs;
  final unhandledGroupApplicationCount = 0.obs;
  final unhandledCount = 0.obs;
  String? _lockScreenPwd;
  bool _isShowScreenLock = false;
  late bool _isAutoLogin;
  final auth = LocalAuthentication();
  final _errorController = PublishSubject<String>();
  final aiUtil = Get.find<AiUtil>();
  final xhsLogic = Get.find<XhsLogic>();

  Function()? onScrollToUnreadMessage;

  switchTab(dynamic index) {
    this.index.value = index;
    if (index == 2) {
      Apis.addActionRecord(actionRecordList: [
        ActionRecord(
            category: ActionCategory.discover,
            actionName: ActionName.enter_discover)
      ]);
    }
  }

  void viewDiscover(index) async {
    await WNavigator.startWorkMomentsList();
    xhsLogic.refreshWorkingCircleList();
    _getUnreadMomentsCount();
  }

  scrollToUnreadMessage(index) {
    onScrollToUnreadMessage?.call();
  }

  _getUnreadMomentsCount() {
    WApis.getUnreadCount().then((value) => unreadMomentsCount.value = value);
  }

  /// 获取消息未读数
  _getUnreadMsgCount() {
    OpenIM.iMManager.conversationManager.getTotalUnreadMsgCount().then((count) {
      unreadMsgCount.value = int.tryParse(count) ?? 0;
      appCtrl.showBadge(unreadMsgCount.value);
    });
  }

  /// 获取好友申请未处理数
  /// 浏览过得不再计入红点
  void getUnhandledFriendApplicationCount() async {
    var i = 0;
    var list = await OpenIM.iMManager.friendshipManager
        .getFriendApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleFriendApplication();
    haveReadList ??= <String>[];
    for (var info in list) {
      var id = IMUtils.buildFriendApplicationID(info);
      if (!haveReadList.contains(id)) {
        if (info.handleResult == 0) i++;
      }
    }
    unhandledFriendApplicationCount.value = i;
    unhandledCount.value = unhandledGroupApplicationCount.value + i;
  }

  /// 获取群申请未处理数
  void getUnhandledGroupApplicationCount() async {
    var i = 0;
    var list = await OpenIM.iMManager.groupManager
        .getGroupApplicationListAsRecipient();
    var haveReadList = DataSp.getHaveReadUnHandleGroupApplication();
    haveReadList ??= <String>[];
    for (var info in list) {
      var id = IMUtils.buildGroupApplicationID(info);
      if (!haveReadList.contains(id)) {
        if (info.handleResult == 0) i++;
      }
    }
    unhandledGroupApplicationCount.value = i;
    unhandledCount.value = unhandledFriendApplicationCount.value + i;
  }

  @override
  void onInit() {
    index.value = Get.arguments['index'] ?? 0;
    _isAutoLogin = Get.arguments['isAutoLogin'];
    if (_isAutoLogin) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showLockScreenPwd());
    }

    _getUnreadMomentsCount();

    PackageBridge.workingCircleBridge = this;

    imLogic.unreadMsgCountEventSubject.listen((value) {
      unreadMsgCount.value = value;
    });
    imLogic.momentsSubject.listen((value) {
      onRecvNewMessageForWorkingCircle?.call(value);
      _getUnreadMomentsCount();
    });
    imLogic.friendApplicationChangedSubject.listen((value) {
      getUnhandledFriendApplicationCount();
    });
    imLogic.groupApplicationChangedSubject.listen((value) {
      getUnhandledGroupApplicationCount();
    });
    super.onInit();
  }

  @override
  void onReady() {
    aiUtil.init();
    _getUnreadMsgCount();
    getUnhandledFriendApplicationCount();
    getUnhandledGroupApplicationCount();
    cacheLogic.initCallRecords();
    cacheLogic.initFavoriteEmoji();
    Future.delayed(Duration(milliseconds: 500), () {
      PackageBridge.workingCircleBridge = this;
      final contactsLogic = Get.find<ContactsLogic>();
      contactsLogic.initPackageBridge();
    });
    super.onReady();
  }

  @override
  void onClose() {
    PackageBridge.workingCircleBridge = null;
    _errorController.close();
    super.onClose();
  }

  _localAuth() async {
    final didAuthenticate = await IMUtils.checkingBiometric(auth);
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
            await imLogic.logout();
            await DataSp.removeLoginCertificate();
            await DataSp.clearLockScreenPassword();
            await DataSp.closeBiometric();
            pushLogic.logout();
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
    // TODO: implement onResumed
    if (imLogic.imSdkStatusSubject.valueOrNull ==
        IMSdkStatus.connectionSucceeded) {
      _getRTCInvitationStart();
    } else {
      imLogic.imSdkStatusSubject.listen((value) {
        if (value == IMSdkStatus.connectionSucceeded) {
          _getRTCInvitationStart();
        }
      });
    }
  }

  void _getRTCInvitationStart() async {
    final signalingInfo = await OpenIM.iMManager.signalingManager
        .getSignalingInvitationInfoStartApp();
    if (null != signalingInfo.invitation) {
      // 调用视频界面
      imLogic.receiveNewInvitation(signalingInfo);
    }
  }

  @override
  void onHidden() {
    // TODO: implement onHidden
  }
}
