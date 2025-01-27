import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';
import '../../core/ctrl/im_ctrl.dart';
import 'package:miti_common/src/utils/data_sp.dart';
import '../../core/ctrl/push_ctrl.dart';
import '../../routes/app_navigator.dart';
import 'package:flutter_openim_sdk/src/models/login_AccountInfo.dart';
import 'package:flutter_openim_sdk/src/models/login_serverInfo.dart';
import 'package:miti/core/ctrl/app_ctrl.dart';

enum LoginType {
  phone,
  email,
}

extension LoginTypeExt on LoginType {
  int get rawValue {
    switch (this) {
      case LoginType.phone:
        return 0;
      case LoginType.email:
        return 1;
    }
  }

  String get name {
    switch (this) {
      case LoginType.phone:
        return StrLibrary.phoneNumber;
      case LoginType.email:
        return StrLibrary.email;
    }
  }

  String get hintText {
    switch (this) {
      case LoginType.phone:
        return StrLibrary.plsEnterPhoneNumber;
      case LoginType.email:
        return StrLibrary.plsEnterEmail;
    }
  }

  String get exclusiveName {
    switch (this) {
      case LoginType.phone:
        return StrLibrary.email;
      case LoginType.email:
        return StrLibrary.phoneNumber;
    }
  }
}

class LoginLogic extends GetxController {
  final imCtrl = Get.find<IMCtrl>();
  final pushCtrl = Get.find<PushCtrl>();
  final phoneEmailCtrl = TextEditingController();
  final pwdCtrl = TextEditingController();
  final serverCtrl = TextEditingController();
  final verificationCodeCtrl = TextEditingController();
  final obscureText = true.obs;
  final enabled = false.obs;
  final areaCode = "+1".obs;
  final isPasswordLogin = true.obs;
  final versionInfo = ''.obs;
  final loginType = LoginType.phone.obs;
  final readOnlyServer = true.obs;
  String? get email =>
      loginType.value == LoginType.email ? phoneEmailCtrl.text.trim() : null;
  String? get phone =>
      loginType.value == LoginType.phone ? phoneEmailCtrl.text.trim() : null;
  LoginType operateType = LoginType.phone;
  final agree = false.obs;
  final rememberPassword = true.obs;
  final isDropdownExpanded = false.obs;
  final historyAccounts = <AccountInfo>[].obs;
  final filteredAccounts = <AccountInfo>[].obs;
  final historyServer = <ServerInfo>[].obs;
  final isServerDropdownExpanded = false.obs;
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final accountUtil = Get.find<AccountUtil>();
  final isAddAccount = false.obs;
  final server = Config.hostWithProtocol.obs;
  final FocusNode phoneEmailFocusNode = FocusNode();
  final FocusNode serverFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();
  final appCtrl = Get.find<AppCtrl>();
  final serverHistory = <String>[Config.hostWithProtocol].obs;
  final serverInput = "".obs;
  int curStatusChangeCount = 0;
  OverlayEntry? overlayEntry;
  OverlayEntry? serverOverlayEntry;

  List<String> get filterServerHistory => serverInput.value == ""
      ? serverHistory
      : serverHistory.where((e) => e.startsWith(serverInput.value)).toList();

  _init() async {
    isAddAccount.value = Get.arguments?['isAddAccount'] ?? false;
    server.value = Get.arguments?['server'] ?? server.value;
    curStatusChangeCount = accountUtil.statusChangeCount.value;
    serverHistory.assignAll(DataSp.getServerHistory().isNotEmpty
        ? DataSp.getServerHistory()
        : [Config.hostWithProtocol]);
    loadHistoryAccountsFromStorage();
    loadHistoryServersFromStorage();
    serverCtrl.text = DataSp.getCurServerKey().isNotEmpty
        ? DataSp.getCurServerKey()
        : Config.hostWithProtocol;
    var map = DataSp.getMainLoginAccount();
    if (map is Map) {
      String? areaCode = map["areaCode"];
      if (areaCode != null && areaCode.isNotEmpty) {
        this.areaCode.value = areaCode;
      }
    }

    loginType.value =
        DataSp.getLoginType() == 0 ? LoginType.phone : LoginType.email;
  }

  @override
  void onClose() {
    phoneEmailCtrl.dispose();
    pwdCtrl.dispose();
    verificationCodeCtrl.dispose();
    serverCtrl.dispose();
    phoneEmailFocusNode.dispose();
    serverFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    _init();
    phoneEmailCtrl.addListener(handleFormChange);
    pwdCtrl.addListener(handleFormChange);
    verificationCodeCtrl.addListener(handleFormChange);
    serverCtrl.addListener(() {
      serverInput.value = serverCtrl.text;
      showServerOverlay();
    });
    serverFocusNode.addListener(() {
      if (serverFocusNode.hasFocus && !readOnlyServer.value) {
        showServerOverlay();
      } else {
        hideServerOverlay();
      }
    });
    super.onInit();
  }

  @override
  onReady() {
    filteredAccounts.assignAll(historyAccounts);
    showOverlay();
    super.onReady();
  }

  handleFormChange() {
    enabled.value = (isPasswordLogin.value &&
            phoneEmailCtrl.text.trim().isNotEmpty &&
            pwdCtrl.text.trim().isNotEmpty ||
        !isPasswordLogin.value &&
            phoneEmailCtrl.text.trim().isNotEmpty &&
            verificationCodeCtrl.text.trim().isNotEmpty);
  }

  devEntry() {
    if (!Config.isProd) {
      AppNavigator.startDevEntry();
    }
  }

  loginGoogle() {
    if (!agree.value) {
      showToast(StrLibrary.plsAgree);
      return;
    }
    if (Platform.isIOS) {
      accountUtil.signInWithGoogle();
    } else {
      // accountUtil.signInWithGoogle();
      // accountUtil.signInWithGoogleByBrowser();
      if (!appCtrl.isGoogleServerRunning.value) {
        accountUtil.signInWithGoogleByBrowser();
      } else {
        accountUtil.signInWithGoogle();
      }
    }
  }

  loginFb() {
    if (!agree.value) {
      showToast(StrLibrary.plsAgree);
      return;
    }
    accountUtil.signInWithFacebook();
  }

  loginApple() {
    if (!agree.value) {
      showToast(StrLibrary.plsAgree);
      return;
    }
    accountUtil.signInWithApple();
  }

  login(BuildContext context) {
    FocusScope.of(context).requestFocus(FocusNode());
    DataSp.putLoginType(loginType.value.rawValue);
    LoadingView.singleton.start(
        topBarHeight: 0,
        fn: () async {
          if (!checkForm()) {
            return;
          }
          if (!isAddAccount.value) {
            await loginAccount();
          } else {
            await addAndLoginAccount();
          }
        });
  }

  Future<void> addAndLoginAccount() async {
    final password = MitiUtils.emptyStrToNull(pwdCtrl.text);
    final code = MitiUtils.emptyStrToNull(verificationCodeCtrl.text);
    final isOk = await accountUtil.loginAccount(
        switchBack: false,
        serverWithProtocol: server.value,
        areaCode: areaCode.value,
        phoneNumber: phone,
        email: email,
        password: password,
        verificationCode: isPasswordLogin.value ? null : code);
    if (isOk) AppNavigator.startMain();
  }

  cusBack() async {
    Get.back();
  }

  switchServer() async {
    // readOnlyServer.value = !readOnlyServer.value;
    if (readOnlyServer.value) {
      serverFocusNode.requestFocus();
      readOnlyServer.value = false;
    } else {
      serverFocusNode.unfocus();
      if (!Config.targetIsDomainOrIPWithProtocol(serverCtrl.text)) {
        showToast(StrLibrary.serverFormatErr);
      } else {
        LoadingView.singleton.start(
            topBarHeight: 0,
            fn: () async {
              try {
                await accountUtil.checkServerValid(
                    serverWithProtocol: serverCtrl.text);
                await accountUtil.switchServer(serverCtrl.text);
                if (isAddAccount.value) {
                  AppNavigator.startLoginWithoutOff(
                      isAddAccount: true, server: serverCtrl.text);
                }
                readOnlyServer.value = true;
                if (serverHistory.contains(serverCtrl.text)) {
                  serverHistory.removeAt(serverHistory
                      .indexWhere((element) => element == serverCtrl.text));
                }
                serverHistory.insert(0, serverCtrl.text);
                DataSp.putServerHistory(serverHistory.value);
                update();
                hideOverlay();
              } catch (e) {
                showToast(StrLibrary.serverErr);
              }
            });
      }
    }
  }

  bool checkForm() {
    if (phone?.isNotEmpty == true &&
        !MitiUtils.isMobile(areaCode.value, phoneEmailCtrl.text)) {
      showToast(StrLibrary.plsEnterRightPhone);
      return false;
    }

    if (email?.isNotEmpty == true && !phoneEmailCtrl.text.isEmail) {
      showToast(StrLibrary.plsEnterRightEmail);
      return false;
    }

    if (!agree.value) {
      showToast(StrLibrary.plsAgree);
      return false;
    }

    if (!readOnlyServer.value) {
      showToast(StrLibrary.plsConfirmServer);
      return false;
    }

    return true;
  }

  Future<bool> loginAccount() async {
    try {
      final password = MitiUtils.emptyStrToNull(pwdCtrl.text);
      final code = MitiUtils.emptyStrToNull(verificationCodeCtrl.text);
      final data = await ClientApis.login(
        areaCode: areaCode.value,
        phoneNumber: phone,
        email: email,
        password: isPasswordLogin.value ? password : null,
        verificationCode: isPasswordLogin.value ? null : code,
      );
      final account = {
        "areaCode": areaCode.value,
        "phoneNumber": phone,
        'email': email,
        "server": serverCtrl.text
      };
      await DataSp.putLoginCertificate(data);
      await DataSp.putMainLoginAccount(account);
      await imCtrl.login(data.userID, data.imToken);
      Get.find<HiveCtrl>().resetCache();
      await setAccountLoginInfo(
          userID: data.userID,
          imToken: data.imToken,
          chatToken: data.chatToken,
          email: email,
          phoneNumber: phone,
          areaCode: areaCode.value,
          password: MitiUtils.generateMD5(password ?? "")!,
          faceURL: imCtrl.userInfo.value.faceURL,
          nickname: imCtrl.userInfo.value.nickname);
      translateLogic.init(data.userID);
      ttsLogic.init(data.userID);
      pushCtrl.login(data.userID);
      AppNavigator.startMain();

      // 登录成功后判断是否需要记住密码
      if (rememberPassword.value) {
        String username;
        if (loginType.value == LoginType.phone) {
          username = phone ?? '';
        } else {
          username = email ?? '';
        }
        AccountInfo newAccountInfo = AccountInfo(
          username: username,
          password: encrypt(password ?? ''),
        );
        saveHistoryAccountsToStorage(newAccountInfo);
      }

      return true;
    } catch (e, s) {
      myLogger.e({"message": "登录失败", "error": e, "stack": s});
    }
    return false;
  }

  // void togglePasswordType() {
  //   isPasswordLogin.value = !isPasswordLogin.value;
  // }

  void toggleLoginType() {
    loginType.value =
        loginType.value == LoginType.phone ? LoginType.email : LoginType.phone;
    phoneEmailCtrl.text = '';
  }

  Future<bool> getVerificationCode() async {
    if (phone?.isNotEmpty == true &&
        !MitiUtils.isMobile(areaCode.value, phoneEmailCtrl.text)) {
      showToast(StrLibrary.plsEnterRightPhone);
      return false;
    }

    if (email?.isNotEmpty == true && !phoneEmailCtrl.text.isEmail) {
      showToast(StrLibrary.plsEnterRightEmail);
      return false;
    }

    return await LoadingView.singleton.start(
        fn: () => ClientApis.requestVerificationCode(
              areaCode: areaCode.value,
              phoneNumber: phone,
              email: email,
              usedFor: 3,
            ));
  }

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  void registerNow() => AppNavigator.startRegister(
      isAddAccount: isAddAccount.value, server: server.value);

  void forgetPassword() => AppNavigator.startForgetPwd(
      isAddAccount: isAddAccount.value, server: server.value);

  void changeAgree(bool? bool) {
    agree.value = bool!;
    handleFormChange();
  }

  void changeRememberPassword(bool? bool) {
    rememberPassword.value = bool!;
  }

  void toggleDropdown() {
    if (isDropdownExpanded.value) {
      overlayEntry?.remove();
      overlayEntry = null;
      isDropdownExpanded.value = false;
    } else {
      overlayEntry = _createOverlayEntry();
      Overlay.of(Get.context!)?.insert(overlayEntry!);
      isDropdownExpanded.value = true;
    }
  }

  void toggleServerDropdown() {
    if (isServerDropdownExpanded.value) {
      serverOverlayEntry?.remove();
      serverOverlayEntry = null;
      isServerDropdownExpanded.value = false;
    } else {
      serverOverlayEntry = _createServerOverlayEntry();
      Overlay.of(Get.context!)?.insert(serverOverlayEntry!);
      isServerDropdownExpanded.value = true;
    }
  }

  void selectAccount(AccountInfo account) {
    phoneEmailCtrl.text = account.username;
    pwdCtrl.text = account.password;
    toggleDropdown();
  }

  void selectServer(String server) {
    serverCtrl.text = server;
    toggleServerDropdown();
  }

  void loadHistoryAccountsFromStorage() async {
    List<AccountInfo>? accounts = DataSp.getRememberedAccounts();
    if (accounts != null) {
      historyAccounts.assignAll(accounts);
      for (var account in historyAccounts) {
        account.password = decrypt(account.password);
      }
    }
  }

  void saveHistoryAccountsToStorage(AccountInfo newAccount) async {
    // 从存储中获取当前的账户列表
    List<AccountInfo>? accounts = await DataSp.getRememberedAccounts() ?? [];

    final index = accounts
        .indexWhere((element) => element.username == newAccount.username);
    if (index != -1) {
      accounts.removeAt(index);
    }

    accounts.insert(0, newAccount);

    await DataSp.putRememberedAccounts(accounts);
  }

  // void handleInputFocusChange(bool isFocused, String text) {
  //   if (isFocused) {
  //     filteredAccounts.assignAll(historyAccounts);

  //     if (!isDropdownExpanded.value) {
  //       isDropdownExpanded.value = true;
  //       showOverlay();
  //     }
  //   } else {
  //     hideOverlay();
  //   }
  // }

  void filterHistoryAccounts(String input) {
    if (input.isEmpty) {
      filteredAccounts.value = [...historyAccounts.value];
    } else {
      List<AccountInfo> matches = [];
      if (loginType.value == LoginType.phone) {
        matches = historyAccounts
            .where((account) => account.username.startsWith(input))
            .toList();
      } else if (loginType.value == LoginType.email) {
        matches = historyAccounts
            .where((account) =>
                account.username.toLowerCase().startsWith(input.toLowerCase()))
            .toList();
      }

      filteredAccounts.assignAll(matches);
    }

    if (filteredAccounts.isNotEmpty) {
      showOverlay();
    } else {
      hideOverlay();
    }
  }

  void showOverlay() {
    if (!filteredAccounts.isNotEmpty) {
      return;
    }
    isDropdownExpanded.value = true;
    if (overlayEntry == null) {
      overlayEntry = _createOverlayEntry();
      Overlay.of(Get.context!)?.insert(overlayEntry!);
    }
  }

  void hideOverlay() {
    overlayEntry?.remove();
    overlayEntry = null;
    isDropdownExpanded.value = false;
  }

  void removeAccount(int index) async {
    bool success = await DataSp.removeRememberedAccount(index);
    if (success) {
      print("账号删除成功");
      AccountInfo removedAccount = filteredAccounts[index];
      filteredAccounts.removeAt(index);
      historyAccounts.remove(removedAccount); // 同样从 historyAccounts 中移除

      update(); // 通知 GetX 更新相关的 UI 组件

      // 重新插入 OverlayEntry
      overlayEntry?.remove();
      overlayEntry = _createOverlayEntry();
      Overlay.of(Get.context!)?.insert(overlayEntry!);

      print(
          "更新后的账户列表: ${filteredAccounts.map((acc) => acc.username).toList()}");
    } else {
      print("账号删除失败");
    }
  }

  void removeServer(int index) async {
    serverHistory.removeAt(index);
    DataSp.putServerHistory(serverHistory.value);

    update(); // 通知 GetX 更新相关的 UI 组件

    // 重新插入 OverlayEntry
    serverOverlayEntry?.remove();
    serverOverlayEntry = _createServerOverlayEntry();
    Overlay.of(Get.context!)?.insert(serverOverlayEntry!);
  }

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: 36.w,
        right: 36.w,
        top: 200.h,
        child: Material(
          elevation: 3.0,
          child: GetBuilder<LoginLogic>(
            // 使用 GetBuilder
            builder: (LoginLogic controller) {
              // 确保在这里定义 controller
              return Obx(() => ListView.builder(
                    padding: EdgeInsets.zero, // 设置 padding 为 zero
                    shrinkWrap: true,
                    itemCount: controller.filteredAccounts.length,
                    itemBuilder: (context, index) {
                      final account = controller.filteredAccounts[index];
                      return ListTile(
                        title: Text(account.username),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            controller.removeAccount(index);
                          },
                          padding: EdgeInsets.zero,
                          constraints: BoxConstraints(),
                        ),
                        onTap: () {
                          // 确保 selectAccount 和 hideOverlay 被正确定义
                          controller.selectAccount(account);
                          controller.hideOverlay();
                        },
                      );
                    },
                  ));
            },
          ),
        ),
      ),
    );
  }

  void showServerOverlay() {
    isServerDropdownExpanded.value = true;
    if (serverOverlayEntry == null) {
      serverOverlayEntry = _createServerOverlayEntry();
      Overlay.of(Get.context!)?.insert(serverOverlayEntry!);
    }
  }

  void hideServerOverlay() {
    serverOverlayEntry?.remove();
    serverOverlayEntry = null;
    isServerDropdownExpanded.value = false;
  }

  void loadHistoryServersFromStorage() async {
    ServerInfo? serverInfo = DataSp.getRememberServer();
    if (serverInfo != null) {
      historyServer.assignAll([serverInfo]);
    }
  }

  void saveHistoryServersToStorage() async {
    if (historyServer.isNotEmpty) {
      ServerInfo serverInfo = historyServer.first;
      await DataSp.putRememberServer(serverInfo);
    }
  }

  OverlayEntry _createServerOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: 36.w,
        right: 36.w,
        top: 315.h,
        child: Material(
            elevation: 2.0,
            child: GetBuilder<LoginLogic>(
                // 使用 GetBuilder
                builder: (LoginLogic controller) {
              // 确保在这里定义 controller
              return Obx(() => ListView.builder(
                    shrinkWrap: true,
                    itemCount: filterServerHistory.length,
                    padding: EdgeInsets.all(0),
                    itemBuilder: (BuildContext context, int index) {
                      final server = filterServerHistory[index];
                      return ListTile(
                        title: Text(server),
                        trailing: server == Config.hostWithProtocol
                            ? null
                            : IconButton(
                                icon: Icon(Icons.close, color: Colors.grey),
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                onPressed: () {
                                  controller
                                      .removeServer(index); // 调用 GetX 控制器的方法
                                },
                              ),
                        onTap: () {
                          // Implement action on select
                          controller.selectServer(server);
                          hideServerOverlay();
                        },
                      );
                    },
                  ));
            })),
      ),
    );
  }
}
