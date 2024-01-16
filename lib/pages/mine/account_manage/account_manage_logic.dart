import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti/utils/account_util.dart';
import 'package:openim_common/openim_common.dart';

class AccountManageLogic extends GetxController {
  final loginInfoList = <AccountLoginInfo>[].obs;
  final curLoginInfoKey = "".obs;
  int curSwitchCount = 0;
  int originSwitchCount = 0;
  final miscUtil = Get.find<MiscUtil>();
  final serverCtrl = TextEditingController();

  @override
  void onInit() {
    setLoginInfoList();
    setCurLoginInfoKey();
    curSwitchCount = miscUtil.switchCount.value;
    originSwitchCount = miscUtil.switchCount.value;
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  setLoginInfoList() {
    final map = DataSp.getAccountLoginInfoMap();
    if (null != map) {
      loginInfoList.value = map.values.toList();
    }
  }

  setCurLoginInfoKey() {
    curLoginInfoKey.value = DataSp.getCurAccountLoginInfoKey();
  }

  cusBack() async {
    if (miscUtil.switchCount.value > curSwitchCount) {
      LoadingView.singleton.wrap(
          navBarHeight: 0,
          asyncFunction: () async {
            await miscUtil.backCurAccount();
            AppNavigator.startMain();
          });
    } else if (miscUtil.switchCount.value > originSwitchCount) {
      AppNavigator.startMain();
    } else {
      Get.back();
    }
  }

  switchAccount(AccountLoginInfo loginInfo) async {
    if (loginInfo.id == curLoginInfoKey) return;
    LoadingView.singleton.wrap(
        navBarHeight: 0,
        asyncFunction: () async {
          await miscUtil.switchAccount(
              server: loginInfo.server, userID: loginInfo.userID);
          setCurLoginInfoKey();
          curSwitchCount = miscUtil.switchCount.value;
        });
  }

  goLogin() async {
    final confirm = await Get.dialog(CustomDialog(
      bigTitle: StrRes.addAccountServer,
      body: Container(
        padding: EdgeInsets.only(
          top: 16.w,
          left: 20.w,
          right: 20.w,
        ),
        child: Column(
          children: [
            Text(
              StrRes.addAccountServer,
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
        if (!Config.targetIsDomainOrIP(serverCtrl.text)) {
          showToast(StrRes.serverFormatErr);
        } else {
          LoadingView.singleton.wrap(
              navBarHeight: 0,
              asyncFunction: () async {
                try {
                  await miscUtil.switchServer(serverCtrl.text);
                  Get.back(result: true);
                  AppNavigator.startLoginWithoutOff(
                      isAddAccount: true, server: serverCtrl.text);
                  serverCtrl.text = "";
                } catch (e) {
                  showToast(StrRes.serverErr);
                }
              });
        }
      },
    ));
  }
}
