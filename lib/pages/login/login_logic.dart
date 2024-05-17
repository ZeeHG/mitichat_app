import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';
import '../../core/ctrl/im_ctrl.dart';
import 'package:miti_common/src/utils/data_sp.dart';
import '../../core/ctrl/push_ctrl.dart';
import 'dart:convert';
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
  final onlyReadServerCtrl = TextEditingController();
  final verificationCodeCtrl = TextEditingController();
  final obscureText = true.obs;
  final enabled = false.obs;
  final areaCode = "+1".obs;
  final isPasswordLogin = true.obs;
  final versionInfo = ''.obs;
  final loginType = LoginType.phone.obs;
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
  final appCtrl = Get.find<AppCtrl>();
  int curStatusChangeCount = 0;
  OverlayEntry? overlayEntry;
  OverlayEntry? serverOverlayEntry;
  _init() async {
    isAddAccount.value = Get.arguments?['isAddAccount'] ?? false;
    server.value = Get.arguments?['server'] ?? server.value;
    curStatusChangeCount = accountUtil.statusChangeCount.value;

    loadHistoryAccountsFromStorage();
    loadHistoryServersFromStorage();
    onlyReadServerCtrl.text = DataSp.getCurServerKey().isNotEmpty
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
    phoneEmailFocusNode.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    _init();
    phoneEmailCtrl.addListener(handleFormChange);
    pwdCtrl.addListener(handleFormChange);
    verificationCodeCtrl.addListener(handleFormChange);
    serverFocusNode.addListener(() {
      if (serverFocusNode.hasFocus) {
        showServerOverlay();
      } else {
        hideServerOverlay();
      }
    });
    super.onInit();
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
    if (!appCtrl.supportFirebase.value) {
      accountUtil.googleOauth();
    } else {
      accountUtil.signInWithGoogle();
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
    await Get.dialog(CustomDialog(
      // bigTitle: "",
      body: Container(
        padding: EdgeInsets.only(
          top: 16.w,
          left: 20.w,
          right: 20.w,
        ),
        child: Column(
          children: [
            Text(
              StrLibrary.switchServer,
              textAlign: TextAlign.center,
              style: StylesLibrary.ts_333333_16sp_medium,
            ),
            31.verticalSpace,
            Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: StylesLibrary.c_F7F8FA,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: InputBox(
                autofocus: false,
                hintText: StrLibrary.addAccountServerTips,
                hintStyle: StylesLibrary.ts_CCCCCC_14sp,
                border: false,
                controller: serverCtrl,
                // focusNode: serverFocusNode,
              ),
            ),
            31.verticalSpace
          ],
        ),
      ),
      onTapLeft: () {
        serverCtrl.text = "";
        Get.back(result: true);
      },
      onTapRight: () async {
        // http://xx
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
                  Get.back(result: true);
                  if (isAddAccount.value) {
                    AppNavigator.startLoginWithoutOff(
                        isAddAccount: true, server: serverCtrl.text);
                  }
                  serverCtrl.text = "";
                } catch (e) {
                  showToast(StrLibrary.serverErr);
                }
                onlyReadServerCtrl.text = DataSp.getCurServerKey().isNotEmpty
                    ? DataSp.getCurServerKey()
                    : Config.hostWithProtocol;
              });
        }
      },
    ));
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
        "server": onlyReadServerCtrl.text
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
          password: password ?? '',
        );
        saveHistoryAccountsToStorage(newAccountInfo);
        loadHistoryAccountsFromStorage();
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

  void selectAccount(AccountInfo account) {
    phoneEmailCtrl.text = account.username;
    pwdCtrl.text = account.password;
    toggleDropdown();
  }

  void loadHistoryAccountsFromStorage() async {
    List<AccountInfo>? accounts = DataSp.getRememberedAccounts();
    if (accounts != null) {
      historyAccounts.assignAll(accounts);
    }
  }

  void saveHistoryAccountsToStorage(AccountInfo newAccount) async {
    // 从存储中获取当前的账户列表
    List<AccountInfo>? accounts = await DataSp.getRememberedAccounts() ?? [];

    if (accounts.contains(newAccount)) {
      accounts.remove(newAccount);
    }

    accounts.insert(0, newAccount);

    await DataSp.putRememberedAccounts(accounts);
  }

  void handleInputFocusChange(bool isFocused, String text) {
    if (isFocused) {
      filteredAccounts.assignAll(historyAccounts);

      if (!isDropdownExpanded.value) {
        isDropdownExpanded.value = true;
        showOverlay();
      }
    } else {
      hideOverlay();
    }
  }

  void filterHistoryAccounts(String input) {
    if (input.isEmpty) {
      filteredAccounts.clear();
      hideOverlay();
      isDropdownExpanded.value = false;
      return;
    }

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

  OverlayEntry _createOverlayEntry() {
    return OverlayEntry(
      builder: (context) => Positioned(
        left: 10,
        right: 10,
        top: 200,
        child: Material(
          elevation: 3.0,
          child: GetBuilder<LoginLogic>(
            // 使用 GetBuilder
            builder: (LoginLogic controller) {
              // 确保在这里定义 controller
              return Obx(() => ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.all(0),
                    itemCount: controller.filteredAccounts.length,
                    itemBuilder: (context, index) {
                      final account = controller.filteredAccounts[index];
                      return ListTile(
                        title: Text(account.username),
                        trailing: IconButton(
                          icon: Icon(Icons.close, color: Colors.grey),
                          onPressed: () {
                            controller.removeAccount(index); // 调用 GetX 控制器的方法
                          },
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
        left: 72,
        right: 72,
        top: 485, // Adjust position as needed
        child: Material(
          elevation: 2.0,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: historyServer.length,
            itemBuilder: (BuildContext context, int index) {
              final server = historyServer[index];
              return ListTile(
                title: Text(server.url),
                onTap: () {
                  // Implement action on select
                  hideServerOverlay();
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
