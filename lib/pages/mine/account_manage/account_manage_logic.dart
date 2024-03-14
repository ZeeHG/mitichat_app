import 'dart:async';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:miti/routes/app_navigator.dart';
import 'package:miti/utils/account_util.dart';
import 'package:miti_common/miti_common.dart';

class AccountManageLogic extends GetxController {
  final loginInfoList = <AccountLoginInfo>[].obs;
  final curLoginInfoKey = "".obs;
  int curStatusChangeCount = 0;
  int originStatusChangeCount = 0;
  final accountUtil = Get.find<AccountUtil>();
  final serverCtrl = TextEditingController();

  @override
  void onInit() {
    setLoginInfoList();
    setCurLoginInfoKey();
    curStatusChangeCount = accountUtil.statusChangeCount.value;
    originStatusChangeCount = accountUtil.statusChangeCount.value;
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

  delLoginInfo(AccountLoginInfo info) async {
    final confirm = await Get.dialog(CustomDialog(
      title: StrLibrary.confirmDelAccount,
    ));
    if (confirm) {
      LoadingView.singleton.start(
          topBarHeight: 0,
          fn: () async {
            if (curLoginInfoKey.value == info.id) {
              await accountUtil.delAccount(info.id, finishLogout: true);
            } else {
              loginInfoList.remove(info);
              await accountUtil.delAccount(info.id);
            }
          });
    }
  }

  cusBack() async {
    if (accountUtil.statusChangeCount.value > curStatusChangeCount) {
      // 最后一次操作切换了服务器
      LoadingView.singleton.start(
          topBarHeight: 0,
          fn: () async {
            await accountUtil.backCurAccount();
            AppNavigator.startMain();
          });
    } else if (accountUtil.statusChangeCount.value > originStatusChangeCount) {
      // 只切换账号
      AppNavigator.startMain();
    } else {
      Get.back();
    }
  }

  switchAccount(AccountLoginInfo loginInfo) async {
    if (loginInfo.id == curLoginInfoKey) return;
    LoadingView.singleton.start(
        topBarHeight: 0,
        loadingTips: StrLibrary.loading,
        fn: () async {
          await accountUtil.switchAccount(
              serverWithProtocol: loginInfo.server, userID: loginInfo.userID);
          setCurLoginInfoKey();
          curStatusChangeCount = accountUtil.statusChangeCount.value;
        });
  }

  goLogin() async {
    final confirm = await Get.dialog(CustomDialog(
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
              StrLibrary.addAccountServer,
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
                hintText: StrLibrary.addAccountServerTips,
                hintStyle: Styles.ts_CCCCCC_14sp,
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
                  AppNavigator.startLoginWithoutOff(
                      isAddAccount: true, server: serverCtrl.text);
                  serverCtrl.text = "";
                } catch (e) {
                  showToast(StrLibrary.serverErr);
                }
              });
        }
      },
    ));
  }
}
