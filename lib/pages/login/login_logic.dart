import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';
import '../../core/ctrl/im_ctrl.dart';
import '../../core/ctrl/push_ctrl.dart';
import '../../routes/app_navigator.dart';

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
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final accountUtil = Get.find<AccountUtil>();
  final isAddAccount = false.obs;
  final server = Config.hostWithProtocol.obs;
  int curStatusChangeCount = 0;

  _init() async {
    isAddAccount.value = Get.arguments?['isAddAccount'] ?? false;
    server.value = Get.arguments?['server'] ?? server.value;
    curStatusChangeCount = accountUtil.statusChangeCount.value;

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
    super.onClose();
  }

  @override
  void onInit() async {
    _init();
    phoneEmailCtrl.addListener(handleFormChange);
    pwdCtrl.addListener(handleFormChange);
    verificationCodeCtrl.addListener(handleFormChange);
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
}
