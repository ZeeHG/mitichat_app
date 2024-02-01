import 'package:flutter/material.dart';
import 'package:flutter_openim_sdk/flutter_openim_sdk.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/pages/mine/server_config/server_config_binding.dart';
import 'package:miti/pages/mine/server_config/server_config_view.dart';
import 'package:miti/utils/account_util.dart';
import 'package:openim_common/openim_common.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/controller/im_controller.dart';
import '../../core/controller/push_controller.dart';
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
        return StrRes.phoneNumber;
      case LoginType.email:
        return StrRes.email;
    }
  }

  String get hintText {
    switch (this) {
      case LoginType.phone:
        return StrRes.plsEnterPhoneNumber;
      case LoginType.email:
        return StrRes.plsEnterEmail;
    }
  }

  String get exclusiveName {
    switch (this) {
      case LoginType.phone:
        return StrRes.email;
      case LoginType.email:
        return StrRes.phoneNumber;
    }
  }
}

class LoginLogic extends GetxController {
  final imLogic = Get.find<IMController>();
  final pushLogic = Get.find<PushController>();
  final phoneCtrl = TextEditingController();
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
      loginType.value == LoginType.email ? phoneCtrl.text.trim() : null;
  String? get phone =>
      loginType.value == LoginType.phone ? phoneCtrl.text.trim() : null;
  LoginType operateType = LoginType.phone;
  final agree = false.obs;
  final translateLogic = Get.find<TranslateLogic>();
  final ttsLogic = Get.find<TtsLogic>();
  final accountUtil = Get.find<AccountUtil>();
  final isAddAccount = false.obs;
  final server = Config.hostWithProtocol.obs;
  int curStatusChangeCount = 0;

  _initData() async {
    onlyReadServerCtrl.text = DataSp.getCurServerKey().isNotEmpty? DataSp.getCurServerKey() : Config.hostWithProtocol;
    var map = DataSp.getMainLoginAccount();
    if (map is Map) {
      // String? email = map["email"];
      // String? phoneNumber = map["phoneNumber"];
      String? areaCode = map["areaCode"];
      // if (email != null && email.isNotEmpty && !isAddAccount.value) {
      //   phoneCtrl.text = email;
      // }
      // if (phoneNumber != null &&
      //     phoneNumber.isNotEmpty &&
      //     !isAddAccount.value) {
      //   phoneCtrl.text = phoneNumber;
      // }
      if (areaCode != null && areaCode.isNotEmpty) {
        this.areaCode.value = areaCode;
      }
    }

    loginType.value =
        (await DataSp.getLoginType()) == 0 ? LoginType.phone : LoginType.email;
  }

  @override
  void onClose() {
    phoneCtrl.dispose();
    pwdCtrl.dispose();
    verificationCodeCtrl.dispose();
    super.onClose();
  }

  @override
  void onInit() async {
    isAddAccount.value = Get.arguments?['isAddAccount'] ?? false;
    server.value = Get.arguments?['server'] ?? server.value;
    curStatusChangeCount = accountUtil.statusChangeCount.value;
    _initData();
    phoneCtrl.addListener(_onChanged);
    pwdCtrl.addListener(_onChanged);
    verificationCodeCtrl.addListener(_onChanged);
    // if (!isAddAccount.value) {
    //   LoadingView.singleton.wrap(
    //       navBarHeight: 0, asyncFunction: () => accountUtil.reloadServerConf());
    // }
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
    getPackageInfo();
  }

  _onChanged() {
    enabled.value = (isPasswordLogin.value &&
            phoneCtrl.text.trim().isNotEmpty &&
            pwdCtrl.text.trim().isNotEmpty ||
        !isPasswordLogin.value &&
            phoneCtrl.text.trim().isNotEmpty &&
            verificationCodeCtrl.text.trim().isNotEmpty);
  }

  login(BuildContext context) {
    FocusScope.of(context).requestFocus(new FocusNode());
    DataSp.putLoginType(loginType.value.rawValue);
    LoadingView.singleton.wrap(
        navBarHeight: 0,
        asyncFunction: () async {
          if (!isAddAccount.value) {
            var suc = await _login();
            if (suc) {
              Get.find<CacheController>().resetCache();
              AppNavigator.startMain();
            }
          } else {
            if (!checkForm()) {
              return false;
            }
            final password = IMUtils.emptyStrToNull(pwdCtrl.text);
            final code = IMUtils.emptyStrToNull(verificationCodeCtrl.text);
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
        });
  }

  cusBack() async {
    // await accountUtil.backMain(curStatusChangeCount);
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
              StrRes.switchServer,
              textAlign: TextAlign.center,
              style: Styles.ts_333333_16sp_medium,
            ),
            31.verticalSpace,
            Container(
              height: 46.h,
              padding: EdgeInsets.symmetric(horizontal: 10.w),
              decoration: BoxDecoration(
                color: Styles.c_F7F8FA,
                borderRadius: BorderRadius.circular(8.r),
              ),
              child: InputBox(
                autofocus: false,
                label: "",
                hintText: StrRes.addAccountServerTips,
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
          showToast(StrRes.serverFormatErr);
        } else {
          LoadingView.singleton.wrap(
              navBarHeight: 0,
              asyncFunction: () async {
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
                  showToast(StrRes.serverErr);
                }
                onlyReadServerCtrl.text = DataSp.getCurServerKey().isNotEmpty? DataSp.getCurServerKey() : Config.hostWithProtocol;
              });
        }
      },
    ));
  }

  bool checkForm() {
    if (phone?.isNotEmpty == true &&
        !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return false;
    }

    if (email?.isNotEmpty == true && !phoneCtrl.text.isEmail) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return false;
    }

    if (!agree.value) {
      IMViews.showToast(StrRes.plsAgree);
      return false;
    }

    return true;
  }

  Future<bool> _login() async {
    try {
      if (!checkForm()) {
        return false;
      }

      final password = IMUtils.emptyStrToNull(pwdCtrl.text);
      final code = IMUtils.emptyStrToNull(verificationCodeCtrl.text);
      final data = await Apis.login(
        areaCode: areaCode.value,
        phoneNumber: phone,
        email: email,
        password: isPasswordLogin.value ? password : null,
        verificationCode: isPasswordLogin.value ? null : code,
      );
      final account = {
        "areaCode": areaCode.value,
        "phoneNumber": phoneCtrl.text,
        'email': email
      };
      await DataSp.putLoginCertificate(data);
      await DataSp.putMainLoginAccount(account);
      Logger.print('login : ${data.userID}, token: ${data.imToken}');
      await imLogic.login(data.userID, data.imToken);
      await setAccountLoginInfo(
          userID: data.userID,
          imToken: data.imToken,
          chatToken: data.chatToken,
          email: email,
          phoneNumber: phone,
          areaCode: areaCode.value,
          password: IMUtils.generateMD5(password ?? "")!,
          faceURL: imLogic.userInfo.value.faceURL,
          nickname: imLogic.userInfo.value.nickname);
      Logger.print('im login success');
      translateLogic.init(data.userID);
      ttsLogic.init(data.userID);
      pushLogic.login(data.userID);
      Logger.print('push login success');
      return true;
    } catch (e, s) {
      Logger.print('login e: $e $s');
      myLogger.e({"message": "登录失败", "error": e, "stack": s});
    }
    return false;
  }

  void togglePasswordType() {
    isPasswordLogin.value = !isPasswordLogin.value;
  }

  void toggleLoginType() {
    if (loginType.value == LoginType.phone) {
      loginType.value = LoginType.email;
    } else {
      loginType.value = LoginType.phone;
    }

    phoneCtrl.text = '';
  }

  Future<bool> getVerificationCode() async {
    if (phone?.isNotEmpty == true &&
        !IMUtils.isMobile(areaCode.value, phoneCtrl.text)) {
      IMViews.showToast(StrRes.plsEnterRightPhone);
      return false;
    }

    if (email?.isNotEmpty == true && !phoneCtrl.text.isEmail) {
      IMViews.showToast(StrRes.plsEnterRightEmail);
      return false;
    }

    return sendVerificationCode();
  }

  /// [usedFor] 1：注册，2：重置密码 3：登录
  Future<bool> sendVerificationCode() => LoadingView.singleton.wrap(
      asyncFunction: () => Apis.requestVerificationCode(
            areaCode: areaCode.value,
            phoneNumber: phone,
            email: email,
            usedFor: 3,
          ));

  void openCountryCodePicker() async {
    String? code = await IMViews.showCountryCodePicker();
    if (null != code) areaCode.value = code;
  }

  void configService() => Get.to(
        () => ServerConfigPage(),
        binding: ServerConfigBinding(),
      );

  void registerNow() => AppNavigator.startRegister(
      isAddAccount: isAddAccount.value, server: server.value);

  void forgetPassword() => AppNavigator.startForgetPassword(
      isAddAccount: isAddAccount.value, server: server.value);

  void getPackageInfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final version = packageInfo.version;
    final appName = packageInfo.appName;
    final buildNumber = packageInfo.buildNumber;

    versionInfo.value = '$appName $version+$buildNumber SDK: ${OpenIM.version}';
  }

  void changeAgree(bool? bool) {
    agree.value = bool!;
    _onChanged();
  }
}
